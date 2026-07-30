import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';
import 'api_client.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isRefreshing = false;
  final List<Future<String?>> _pendingRequests = [];

  DioClient._internal() {
    _initializeDio();
  }

  factory DioClient() {
    return _instance;
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_dio, _secureStorage, this),
      _ErrorInterceptor(),
      _LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<String?> _getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<void> _saveAccessToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  Future<void> _saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  Future<bool> _refreshAccessToken() async {
    if (_isRefreshing) {
      return false;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _getRefreshToken();

      if (refreshToken == null) {
        throw UnauthorizedException(message: 'Aucun refresh token disponible');
      }

      final response = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'] as Map<String, dynamic>?;
        final newAccessToken =
            (responseData?['access_token'] ?? responseData?['token'])
                as String?;
        final newRefreshToken = responseData?['refresh_token'] as String?;

        if (newAccessToken != null) {
          await _saveAccessToken(newAccessToken);
        }

        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await _saveRefreshToken(newRefreshToken);
        }

        return newAccessToken != null;
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      _isRefreshing = false;
      _pendingRequests.clear();
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
    _dio.interceptors.clear();
    _initializeDio();
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final DioClient dioClient;

  _AuthInterceptor(this.dio, this.secureStorage, this.dioClient);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    final accessToken = await secureStorage.read(key: 'access_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await dioClient._refreshAccessToken();

      if (refreshed) {
        final options = err.requestOptions;
        final newAccessToken = await secureStorage.read(key: 'access_token');

        if (newAccessToken != null) {
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final response = await dio.fetch(options);
            return handler.resolve(response);
          } catch (e) {
            return handler.reject(err);
          }
        }
      }

      await secureStorage.deleteAll();
      return handler.reject(err);
    }

    return handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    ApiException apiException;

    // Log error details for debugging
    if (kDebugMode) {
      print('🔴 DioException: ${err.type}');
      print('   Message: ${err.message}');
      print('   Status Code: ${err.response?.statusCode}');
      print('   Request URL: ${err.requestOptions.uri}');
      if (err.error != null) {
        print('   Error: ${err.error}');
      }
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      apiException = TimeoutException(
        message: err.message ?? 'Délai d\'attente dépassé',
      );
    } else if (err.type == DioExceptionType.cancel) {
      apiException = CancelledException(message: 'Requête annulée');
    } else if (err.type == DioExceptionType.connectionError) {
      apiException = NetworkException(
        message: err.error?.toString() ?? 'Erreur de connexion réseau',
      );
    } else if (err.response != null) {
      final statusCode = err.response!.statusCode;
      final data = err.response!.data;
      final message = _extractErrorMessage(data);

      switch (statusCode) {
        case 401:
          apiException = UnauthorizedException(message: message);
          break;
        case 403:
          apiException = ForbiddenException(message: message);
          break;
        case 404:
          apiException = NotFoundException(message: message);
          break;
        case 422:
          apiException = ValidationException(
            message: message,
            errors: data is Map ? data['errors'] : null,
          );
          break;
        case 500:
          apiException = ServerException(message: message);
          break;
        default:
          apiException = ServerException(message: message);
          break;
      }
    } else {
      apiException = NetworkException(
        message: err.error?.toString() ?? 'Erreur inconnue',
      );
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        type: err.type,
      ),
    );
  }
}

String _extractErrorMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    final error = data['error'];
    if (error is String && error.trim().isNotEmpty) {
      return error;
    }

    final errors = data['errors'];
    if (errors is Map) {
      final firstError = errors.values.firstWhere(
        (value) => value != null,
        orElse: () => null,
      );
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      if (firstError != null) {
        return firstError.toString();
      }
    }
  }

  if (data is String && data.trim().isNotEmpty) {
    return data;
  }

  return 'Erreur serveur';
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('➡️ REQUEST: ${options.method.toUpperCase()} ${options.uri}');
      print('   Headers: ${options.headers}');
      if (options.data != null) {
        print('   Data: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        '⬅️ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      );
      if (response.data != null) {
        print('   Data: ${response.data}');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
