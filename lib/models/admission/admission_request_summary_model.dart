class AdmissionRequestDocumentSummaryModel {
  final String uuid;
  final String originalFilename;
  final String attachmentType;
  final bool validated;

  const AdmissionRequestDocumentSummaryModel({
    required this.uuid,
    required this.originalFilename,
    required this.attachmentType,
    required this.validated,
  });

  factory AdmissionRequestDocumentSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final attachmentType = _stringValue(
      json['attachmentType'] ??
          json['attachment_type'] ??
          json['type'] ??
          json['label'] ??
          json['label_text'],
    );
    final fileName = _stringValue(
      json['originalFilename'] ??
          json['original_filename'] ??
          json['originalName'] ??
          json['original_name'] ??
          json['fileName'] ??
          json['filename'] ??
          json['documentName'] ??
          json['document_name'] ??
          json['name'] ??
          json['label'],
    );

    return AdmissionRequestDocumentSummaryModel(
      uuid: _stringValue(json['uuid'] ?? json['id']),
      // Some API versions do not return a file name. The attachment type is
      // still a useful, non-empty label in that case.
      originalFilename: fileName.isNotEmpty ? fileName : attachmentType,
      attachmentType: attachmentType,
      validated: _boolValue(
        json['validated'] ?? json['isValidated'] ?? json['is_validated'],
      ),
    );
  }

  static String _stringValue(dynamic value) => value?.toString() ?? '';

  static bool _boolValue(dynamic value) {
    if (value is bool) return value;
    return value?.toString().toLowerCase() == 'true' || value == 1;
  }
}

class AdmissionRequestSummaryModel {
  final int requestId;
  final String status;
  final Map<String, dynamic> information;
  final List<AdmissionRequestDocumentSummaryModel> documents;
  final List<String> missingDocuments;
  final bool isComplete;

  const AdmissionRequestSummaryModel({
    required this.requestId,
    required this.status,
    required this.information,
    required this.documents,
    required this.missingDocuments,
    required this.isComplete,
  });

  factory AdmissionRequestSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdmissionRequestSummaryModel(
      requestId:
          int.tryParse(
            '${json['requestId'] ?? json['request_id'] ?? json['id'] ?? 0}',
          ) ??
          0,
      status: json['status']?.toString() ?? '',
      information: Map<String, dynamic>.from(json['information'] ?? {}),
      documents: (json['documents'] as List? ?? [])
          .map(
            (item) => AdmissionRequestDocumentSummaryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      missingDocuments: List<String>.from(
        json['missingDocuments'] ?? json['missing_documents'] ?? [],
      ),
      isComplete: AdmissionRequestDocumentSummaryModel._boolValue(
        json['isComplete'] ?? json['is_complete'],
      ),
    );
  }
}
