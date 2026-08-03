class AdmissionRequestResponseModel {
  final int id;
  final String uuid;

  const AdmissionRequestResponseModel({
    required this.id,
    required this.uuid,
  });

  factory AdmissionRequestResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final requestPayload = payload['request'] is Map
        ? Map<String, dynamic>.from(payload['request'] as Map)
        : payload;

    return AdmissionRequestResponseModel(
      id: requestPayload['id'] ?? payload['id'] ?? json['requestId'] ?? json['request_id'] ?? 0,
      uuid: requestPayload['uuid'] ?? payload['uuid'] ?? json['uuid'] ?? '',
    );
  }
}
