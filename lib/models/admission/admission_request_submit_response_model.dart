class AdmissionRequestSubmitResponseModel {
  final bool success;
  final String status;
  final String submittedAt;

  const AdmissionRequestSubmitResponseModel({
    required this.success,
    required this.status,
    required this.submittedAt,
  });

  factory AdmissionRequestSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return AdmissionRequestSubmitResponseModel(
      success: payload['success'] ?? json['success'] ?? false,
      status: payload['status'] ?? json['status'] ?? '',
      submittedAt: payload['submittedAt'] ?? json['submittedAt'] ?? '',
    );
  }
}
