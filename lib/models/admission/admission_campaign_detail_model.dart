class AdmissionCampaignDetailModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final List<String> conditions;
  final List<String> criteria;
  final List<String> fields;
  final List<String> requiredDocuments;
  final DateTime? deadline;
  final String status;

  const AdmissionCampaignDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.conditions,
    required this.criteria,
    required this.fields,
    required this.requiredDocuments,
    required this.deadline,
    required this.status,
  });

  factory AdmissionCampaignDetailModel.fromJson(Map<String, dynamic> json) {
    return AdmissionCampaignDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? '',
      conditions: List<String>.from(json['conditions'] ?? []),
      criteria: List<String>.from(json['criteria'] ?? []),
      fields: List<String>.from(json['fields'] ?? []),
      requiredDocuments: List<String>.from(json['requiredDocuments'] ?? []),
      deadline: json['deadline'] != null && json['deadline'].toString().isNotEmpty
          ? DateTime.tryParse(json['deadline'])
          : null,
      status: json['status'] ?? '',
    );
  }
}
