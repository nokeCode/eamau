import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth/auth_service.dart';

class ApiClient {
  // Configuration centralisée
  static const String baseUrl = 'http://localhost:9090/api/v1';
  static const String apiVersion = 'v1';

  final AuthService _authService = AuthService();

  // Méthode pour obtenir les headers avec authentification
  Future<Map<String, String>> _getHeaders({
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await _authService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  // GET request
  Future<dynamic> get(
    String endpoint, {
    bool requireAuth = false,
    Map<String, String>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint')
          .replace(queryParameters: queryParams);

      final headers = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: customHeaders,
      );

      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: customHeaders,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: customHeaders,
      );

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<dynamic> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: customHeaders,
      );

      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(
    String endpoint, {
    bool requireAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(
        requireAuth: requireAuth,
        customHeaders: customHeaders,
      );

      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Traitement de la réponse
  dynamic _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Succès
        return decodedResponse;
      } else if (response.statusCode == 401) {
        // Non authentifié
        throw UnauthorizedException('Veuillez vous reconnecter');
      } else if (response.statusCode == 403) {
        // Accès refusé
        throw ForbiddenException('Accès refusé');
      } else if (response.statusCode == 404) {
        // Non trouvé
        throw NotFoundException(
          decodedResponse['message'] ?? 'Ressource non trouvée',
        );
      } else if (response.statusCode == 422) {
        // Validation error
        throw ValidationException(
          decodedResponse['message'] ?? 'Erreur de validation',
          errors: decodedResponse['errors'],
        );
      } else {
        throw ApiException(
          decodedResponse['message'] ?? 'Erreur serveur',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Erreur lors du traitement de la réponse: $e');
    }
  }

  // Traitement des erreurs
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return ApiException('Erreur réseau: $error');
  }
}

// Exception classes
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, statusCode: 403);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException(
    String message, {
    this.errors,
  }) : super(message, statusCode: 422);
}

