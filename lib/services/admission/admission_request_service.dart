import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

class AdmissionRequestService {
  static const String baseUrl = ApiConfig.fullBaseUrl;
  final TokenStorage _tokenStorage;
  final http.Client _client;
  int? lastStatusCode;
  String? lastErrorMessage;

  AdmissionRequestService({http.Client? client, TokenStorage? tokenStorage})
    : _client = client ?? http.Client(),
      _tokenStorage = tokenStorage ?? TokenStorage();

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
        return jsonDecode(response.body);
      }
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
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
        return AdmissionCampaignDetailModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(response.body)),
        );
      }
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
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
    AdmissionRequestModel model,
  ) async {
    try {
      final response = await _withTimeout(
        () async => _client.post(
          Uri.parse('$baseUrl/admission-campaigns/$campaignId/requests'),
          headers: await _headers(),
          body: jsonEncode(model.toJson()),
        ),
      );
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return AdmissionRequestResponseModel.fromJson(_extractPayload(decoded));
      }
      lastErrorMessage = response.body;
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
    }
    return null;
  }

  Future<bool> uploadDocument(
    int requestId,
    String attachmentType,
    File file,
  ) async {
    try {
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        lastErrorMessage = 'Le fichier est vide ou introuvable.';
        return false;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/admission/requests/$requestId/documents'),
      );

      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['attachmentType'] = attachmentType;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.path.split('/').last,
        ),
      );

      final response = await _withTimeout(() async => request.send());
      final responseBody = await response.stream.bytesToString();
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      lastErrorMessage = responseBody.isNotEmpty
          ? responseBody
          : 'Erreur HTTP ${response.statusCode}.';
      return false;
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
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
    int requestId,
  ) async {
    try {
      final response = await _withTimeout(
        () async => _client.post(
          Uri.parse('$baseUrl/admission/requests/$requestId/submit'),
          headers: await _headers(),
        ),
      );
      lastStatusCode = response.statusCode;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final detail = _extractPayload(decoded);

        if (detail.isEmpty) {
          return null;
        }

        return AdmissionRequestSubmitResponseModel.fromJson(detail);
      }
    } catch (error) {
      lastErrorMessage = error is TimeoutException
          ? error.message?.toString() ??
                'Le serveur met trop de temps à répondre. Veuillez réessayer.'
          : error.toString();
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
