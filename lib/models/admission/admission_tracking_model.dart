class AdmissionTrackingModel {

  final String reference;

  final String submissionDate;

  final String status;

  final List<TrackingStepModel> steps;

  const AdmissionTrackingModel({

    required this.reference,

    required this.submissionDate,

    required this.status,

    required this.steps,

  });

  factory AdmissionTrackingModel.fromJson(
      Map<String, dynamic> json) {

    return AdmissionTrackingModel(

      reference: json["reference"] ?? "",

      submissionDate:
      json["submission_date"] ?? "",

      status: json["status"] ?? "",

      steps: (json["steps"] as List)
          .map(
            (e) =>
            TrackingStepModel.fromJson(e),
      )
          .toList(),
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

  factory TrackingStepModel.fromJson(
      Map<String, dynamic> json) {

    return TrackingStepModel(

      title: json["title"] ?? "",

      description:
      json["description"] ?? "",

      date: json["date"] ?? "",

      completed:
      json["completed"] ?? false,
    );
  }
}