/// One item of the authenticated user's own admission requests, as returned
/// by `GET /admission/requests` (`AdmissionService::listRequestsForCurrentUser`).
/// Distinct from [AdmissionRequestSummaryModel], which describes a single
/// request's document checklist, not a list entry.
class MyAdmissionRequestModel {
  final int id;
  final String uuid;
  final String status;
  final int? campaignId;
  final String campaign;
  final String? createdAt;
  final String? submittedAt;

  const MyAdmissionRequestModel({
    required this.id,
    required this.uuid,
    required this.status,
    this.campaignId,
    required this.campaign,
    this.createdAt,
    this.submittedAt,
  });

  bool get isSubmitted => (submittedAt ?? '').isNotEmpty;

  factory MyAdmissionRequestModel.fromJson(Map<String, dynamic> json) {
    return MyAdmissionRequestModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      uuid: json['uuid']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      campaignId: int.tryParse(json['campaignId']?.toString() ?? ''),
      campaign: json['campaign']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
      submittedAt: json['submittedAt']?.toString(),
    );
  }
}
