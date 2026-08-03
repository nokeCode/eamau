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

  factory AdmissionRequestDocumentSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdmissionRequestDocumentSummaryModel(
      uuid: json['uuid'] ?? '',
      originalFilename: json['originalFilename'] ?? '',
      attachmentType: json['attachmentType'] ?? '',
      validated: json['validated'] ?? false,
    );
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
      requestId: json['requestId'] ?? 0,
      status: json['status'] ?? '',
      information: Map<String, dynamic>.from(json['information'] ?? {}),
      documents: (json['documents'] as List? ?? [])
          .map((item) => AdmissionRequestDocumentSummaryModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList(),
      missingDocuments: List<String>.from(json['missingDocuments'] ?? []),
      isComplete: json['isComplete'] ?? false,
    );
  }
}
