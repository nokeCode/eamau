class AdmissionTrackingModel {
  final int requestId;
  final String reference;
  final String submissionDate;
  final String status;
  final List<TrackingStepModel> steps;
  final Map<String, dynamic> information;
  final List<AdmissionDocumentSummaryModel> documents;
  final List<String> missingDocuments;
  final bool isComplete;
  final List<TrackingStepModel> timeline;

  const AdmissionTrackingModel({
    required this.requestId,
    required this.reference,
    required this.submissionDate,
    required this.status,
    required this.steps,
    required this.information,
    required this.documents,
    required this.missingDocuments,
    required this.isComplete,
    required this.timeline,
  });

  factory AdmissionTrackingModel.fromJson(Map<String, dynamic> json) {
    final timelineData = json['timeline'] as List? ?? [];
    final stepsData = json['steps'] as List? ?? [];
    final parsedTimeline = timelineData
        .map((item) => TrackingStepModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
    final parsedSteps = stepsData
        .map((item) => TrackingStepModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();

    return AdmissionTrackingModel(
      requestId: json['requestId'] ?? json['id'] ?? 0,
      reference: json['reference']?.toString() ??
          json['uuid']?.toString() ??
          (json['requestId']?.toString() ?? ''),
      submissionDate: json['submissionDate']?.toString() ??
          json['submission_date']?.toString() ??
          json['createdAt']?.toString() ??
          '',
      status: json['status'] ?? '',
      steps: parsedSteps.isNotEmpty ? parsedSteps : parsedTimeline,
      information: Map<String, dynamic>.from(json['information'] ?? {}),
      documents: (json['documents'] as List? ?? [])
          .map((item) => AdmissionDocumentSummaryModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList(),
      missingDocuments: List<String>.from(json['missingDocuments'] ?? []),
      isComplete: json['isComplete'] ?? false,
      timeline: parsedTimeline.isNotEmpty ? parsedTimeline : parsedSteps,
    );
  }
}

class AdmissionDocumentSummaryModel {
  final String uuid;
  final String originalFilename;
  final String attachmentType;
  final bool validated;

  const AdmissionDocumentSummaryModel({
    required this.uuid,
    required this.originalFilename,
    required this.attachmentType,
    required this.validated,
  });

  factory AdmissionDocumentSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdmissionDocumentSummaryModel(
      uuid: json['uuid'] ?? '',
      originalFilename: json['originalFilename'] ?? '',
      attachmentType: json['attachmentType'] ?? '',
      validated: json['validated'] ?? false,
    );
  }
}

class TrackingStepModel {
  final String title;
  final String description;
  final String date;
  final bool completed;

  const TrackingStepModel({
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
  });

  factory TrackingStepModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString().toUpperCase() ?? '';
    return TrackingStepModel(
      title: json['label'] ?? json['step'] ?? json['title'] ?? '',
      description: status.isNotEmpty ? status : (json['description'] ?? ''),
      date: json['date'] ?? '',
      completed: status != 'BROUILLON' && status != 'DOCUMENT_INCOMPLET',
    );
  }
}