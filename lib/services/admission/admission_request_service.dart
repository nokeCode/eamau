import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';
import '../../models/admission/admission_campaign_detail_model.dart';
import '../../models/admission/admission_request_model.dart';
import '../../models/admission/admission_request_response_model.dart';
import '../../models/admission/admission_request_submit_response_model.dart';
import '../../models/admission/admission_request_summary_model.dart';
import '../../models/admission/my_admission_request_model.dart';
import '../../data/local/admission_local_datasource.dart';

class AdmissionRequestService {
  static const String baseUrl = ApiConfig.fullBaseUrl;

  // `SyncEngine` and `AdmissionRequestScreen` each create a fresh
  // `AdmissionRequestService()` per call/screen, and nothing ever called
  // `http.Client.close()` on it. Every retry of a queued operation therefore
  // leaked its own `http.Client` (its own underlying socket/connection pool)
  // instead of reusing one. Sharing a single client by default keeps
  // connections bounded across retries; callers can still inject their own
  // client (e.g. in tests).
  static final http.Client _sharedClient = http.Client();

  final TokenStorage _tokenStorage;
  final http.Client _client;
  int? lastStatusCode;
  String? lastErrorMessage;

  AdmissionRequestService({http.Client? client, TokenStorage? tokenStorage})
    : _client = client ?? _sharedClient,
      _tokenStorage = tokenStorage ?? TokenStorage();

  final AdmissionLocalDatasource _local = AdmissionLocalDatasource();

  Future<Map<String, String>> _headers({bool includeJson = true}) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (includeJson) {
      headers['Content-Type'] = 'application/json';
    }
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<T> _withTimeout<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(const Duration(seconds: 30));
    } on TimeoutException {
      lastErrorMessage =
          'Le serveur met trop de temps à répondre. Veuillez réessayer.';
      throw TimeoutException(
        'Le serveur met trop de temps à répondre. Veuillez réessayer.',
      );
    }
  }

  Future<Map<String, dynamic>> getAdmissionForm() async {
    try {
      final response = await _withTimeout(
        () async => _client.get(
          Uri.parse('$baseUrl/admission/form'),
          headers: await _headers(),
        ),
      );
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Cache the fetched form
        try {
          await _local.cacheAdmissionForm(jsonEncode(decoded));
        } catch (_) {}
        return decoded;
      }
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
    // On error, try to return cached form first
    try {
      final cached = await _local.getCachedAdmissionForm();
      if (cached != null && cached.isNotEmpty) {
        return jsonDecode(cached) as Map<String, dynamic>;
      }
    } catch (_) {}
    return fallbackFormData;
  }

  Future<AdmissionCampaignDetailModel?> getCampaignDetail(
    int campaignId,
  ) async {
    try {
      final response = await _withTimeout(
        () async => _client.get(
          Uri.parse('$baseUrl/admission-campaigns/$campaignId'),
          headers: await _headers(),
        ),
      );
      if (response.statusCode == 200) {
        final decoded = Map<String, dynamic>.from(jsonDecode(response.body));
        // Cache campaign detail
        try {
          await _local.cacheCampaignDetail(campaignId, jsonEncode(decoded));
        } catch (_) {}
        return AdmissionCampaignDetailModel.fromJson(decoded);
      }
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
    // On error, try to return cached campaign detail
    try {
      final cached = await _local.getCachedCampaignDetail(campaignId);
      if (cached != null && cached.isNotEmpty) {
        return AdmissionCampaignDetailModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(cached)),
        );
      }
    } catch (_) {}
    return null;
  }

  Map<String, dynamic> _extractPayload(dynamic decoded) {
    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);
      if (map['data'] is Map) {
        return Map<String, dynamic>.from(map['data'] as Map);
      }
      if (map['result'] is Map) {
        return Map<String, dynamic>.from(map['result'] as Map);
      }
      return map;
    }
    return {};
  }

  List<dynamic> _extractListPayload(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);
      if (map['data'] is List) return map['data'] as List<dynamic>;
      if (map['data'] is Map) {
        final inner = Map<String, dynamic>.from(map['data'] as Map);
        if (inner['items'] is List) return inner['items'] as List<dynamic>;
        if (inner['requests'] is List) return inner['requests'] as List<dynamic>;
      }
      if (map['items'] is List) return map['items'] as List<dynamic>;
    }
    return const [];
  }

  /// The authenticated user's own admission requests, across every
  /// campaign — `GET /admission/requests` (`AdmissionService::
  /// listRequestsForCurrentUser`). Returns an empty list on any failure
  /// (offline, unauthenticated, server error) rather than throwing: callers
  /// treat "no requests known" and "couldn't check" the same way.
  Future<List<MyAdmissionRequestModel>> listMyRequests() async {
    final url = '$baseUrl/admission/requests';
    try {
      final response = await _withTimeout(
        () async => _client.get(Uri.parse(url), headers: await _headers()),
      );
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _extractListPayload(decoded)
            .whereType<Map>()
            .map((e) => MyAdmissionRequestModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      lastErrorMessage = response.body;
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
    return [];
  }

  static String normalizeAttachmentTypeCode(String label) {
    const mapping = {
      'Photo d\'identité': 'PHOTO',
      'CNI ou Passeport': 'ID_CARD',
      'Acte de naissance': 'BIRTH_CERTIFICATE',
      'Diplôme': 'DIPLOMA',
      'Relevé de notes': 'TRANSCRIPT',
      'Lettre de motivation': 'MOTIVATION_LETTER',
      'Casier judiciaire': 'CRIMINAL_RECORD',
      'Certificat médical': 'MEDICAL_CERTIFICATE',
      'CV': 'CV',
    };
    return mapping[label] ?? 'OTHER';
  }

  Future<AdmissionRequestResponseModel?> createAdmissionRequest(
    int campaignId,
    AdmissionRequestModel model, {
    String? idempotencyKey,
  }) async {
    final url = '$baseUrl/admission-campaigns/$campaignId/requests';
    try {
      final headers = await _headers();
      if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
        headers['Idempotency-Key'] = idempotencyKey;
      }
      debugPrint('[ADMISSION][HTTP] POST $url idempotencyKey=$idempotencyKey');
      final response = await _withTimeout(
        () async => _client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(model.toJson()),
        ),
      );
      lastStatusCode = response.statusCode;
      debugPrint('[ADMISSION][HTTP] status=${response.statusCode} url=$url');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return AdmissionRequestResponseModel.fromJson(_extractPayload(decoded));
      }
      lastErrorMessage = response.body;
      debugPrint('[ADMISSION][HTTP] body=${response.body}');
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
      debugPrint('[ADMISSION][HTTP][ERROR] url=$url exceptionType=${error.runtimeType} error=$error');
    }
    return null;
  }

  Future<bool> uploadDocument(
    int requestId,
    String attachmentType,
    File file, {
    String? idempotencyKey,
  }) async {
    final url = '$baseUrl/admission/requests/$requestId/documents';
    try {
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        lastErrorMessage = 'Le fichier est vide ou introuvable.';
        debugPrint('[ADMISSION][HTTP][ERROR] fichier vide ou introuvable path=${file.path}');
        return false;
      }

      final request = http.MultipartRequest('POST', Uri.parse(url));

      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
        request.headers['Idempotency-Key'] = idempotencyKey;
      }

      request.fields['attachmentType'] = attachmentType;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.path.split('/').last,
        ),
      );

      final sizeKb = (bytes.length / 1024).toStringAsFixed(1);
      debugPrint('[ADMISSION][HTTP] POST $url attachmentType=$attachmentType '
          'fileSizeKB=$sizeKb idempotencyKey=$idempotencyKey');
      final stopwatch = Stopwatch()..start();
      final response = await _withTimeout(() async => request.send());
      final responseBody = await response.stream.bytesToString();
      stopwatch.stop();
      lastStatusCode = response.statusCode;
      debugPrint('[ADMISSION][HTTP] status=${response.statusCode} url=$url '
          'fileSizeKB=$sizeKb durationMs=${stopwatch.elapsedMilliseconds}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      lastErrorMessage = responseBody.isNotEmpty
          ? responseBody
          : 'Erreur HTTP ${response.statusCode}.';
      debugPrint('[ADMISSION][HTTP] body=$responseBody');
      return false;
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
      debugPrint('[ADMISSION][HTTP][ERROR] url=$url exceptionType=${error.runtimeType} error=$error');
      return false;
    }
  }

  Future<AdmissionRequestSummaryModel?> getAdmissionSummary(
    int requestId,
  ) async {
    try {
      final response = await _withTimeout(
        () async => _client.get(
          Uri.parse('$baseUrl/admission/requests/$requestId/summary'),
          headers: await _headers(),
        ),
      );
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final detail = _extractPayload(decoded);

        if (detail.isEmpty) {
          return null;
        }

        return AdmissionRequestSummaryModel.fromJson(detail);
      }
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
    return null;
  }

  Future<AdmissionRequestSubmitResponseModel?> submitAdmissionRequest(
    int requestId, {
    String? idempotencyKey,
  }) async {
    final url = '$baseUrl/admission/requests/$requestId/submit';
    try {
      final headers = await _headers();
      if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
        headers['Idempotency-Key'] = idempotencyKey;
      }
      debugPrint('[ADMISSION][HTTP] POST $url idempotencyKey=$idempotencyKey');
      final response = await _withTimeout(
        () async => _client.post(
          Uri.parse(url),
          headers: headers,
        ),
      );
      lastStatusCode = response.statusCode;
      debugPrint('[ADMISSION][HTTP] status=${response.statusCode} url=$url');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final detail = _extractPayload(decoded);

        if (detail.isEmpty) {
          lastErrorMessage = response.body;
          debugPrint('[ADMISSION][HTTP][ERROR] réponse ${response.statusCode} sans payload exploitable '
              'body=${response.body}');
          return null;
        }

        return AdmissionRequestSubmitResponseModel.fromJson(detail);
      }

      // Bug fixé : cette branche ne renseignait pas lastErrorMessage, ce qui
      // faisait apparaître "body=null" dans les logs même sur une vraie
      // réponse 400/422/500 du backend.
      lastErrorMessage = response.body;
      debugPrint('[ADMISSION][HTTP] body=${response.body}');
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
      debugPrint('[ADMISSION][HTTP][ERROR] url=$url exceptionType=${error.runtimeType} error=$error');
    }
    return null;
  }

  Future<File> prepareFileForUpload(File sourceFile, String label) async {
    final isImage = _isImageFile(sourceFile.path);
    if (!isImage) {
      return _renameFile(sourceFile, label, sourceFile.path.split('.').last);
    }

    final pdf = pw.Document();
    final image = pw.MemoryImage(await sourceFile.readAsBytes());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Center(child: pw.Image(image)),
      ),
    );

    final outputPath =
        '${Directory.systemTemp.path}/${_safePdfBaseName(label)}.pdf';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(await pdf.save());
    return _renameFile(outputFile, label, 'pdf');
  }

  bool _isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp');
  }

  File _renameFile(File file, String label, String extension) {
    final baseName = _safePdfBaseName(label);
    final newPath = '${file.parent.path}/$baseName.$extension';
    if (file.absolute.path == File(newPath).absolute.path) {
      return file;
    }
    return file.copySync(newPath);
  }

  String _safePdfBaseName(String title) {
    final cleaned = title
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return cleaned.isEmpty ? 'document' : cleaned;
  }
}

const fallbackFormData = {
  'levels': ['L2', 'L3', 'L4', 'L5'],
  'programs': ['Architecture', 'Urbanisme', 'Gestion Urbaine'],
  'nationalities': [
    'Togolaise',
    'Béninoise',
    'Burkinabè',
    'Ivoirienne',
    'Sénégalaise',
    'Nigérienne',
    'Camerounaise',
  ],
  'countries': [
    'Togo',
    'Bénin',
    'Burkina Faso',
    'Côte d\'Ivoire',
    'Sénégal',
    'Niger',
    'Cameroun',
  ],
  'diplomas': ['Baccalauréat', 'BTS', 'DUT', 'DEUG', 'Licence', 'Master'],
  'documents': [
    'Photo d\'identité',
    'CNI ou Passeport',
    'Acte de naissance',
    'Diplôme',
    'Relevé de notes',
    'Lettre de motivation',
    'Casier judiciaire',
    'Certificat médical',
    'CV',
  ],
};
