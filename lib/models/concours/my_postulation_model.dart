/// One item of the authenticated user's own postulations, as returned by
/// `GET /postulations` (`PostulationService::listForCurrentUser`, route
/// `api_postulation_list_mine`). Confirmed against a live sample response:
///
/// ```json
/// {
///   "id": "019fe0e7-ea66-7e60-9f74-69ddec81aa16",
///   "reference": "002",
///   "concoursSlug": "coucours-2026",
///   "status": "submitted",
///   "submittedAt": "2026-08-08T10:32:17+00:00"
/// }
/// ```
///
/// `status` is the *raw* value stored on `Postulation`
/// (`Constants::POSTULATION_STATUS_*` — e.g. `initiated`, `submitted`,
/// `accepted`, `rejected`), not normalized like the admission side's
/// `toMobileApiStatus()`.
class MyPostulationModel {
  final String id;
  final String reference;
  final String concoursSlug;
  final String status;
  final String? submittedAt;

  const MyPostulationModel({
    required this.id,
    required this.reference,
    required this.concoursSlug,
    required this.status,
    this.submittedAt,
  });

  /// True once the postulation has actually been submitted — as opposed to
  /// still sitting at `initiated` — mirroring how the admission side uses
  /// `submittedAt` to tell a real submission apart from a draft (`BROUILLON`).
  bool get isSubmitted => (submittedAt ?? '').isNotEmpty;

  factory MyPostulationModel.fromJson(Map<String, dynamic> json) {
    return MyPostulationModel(
      id: json['id']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      concoursSlug: json['concoursSlug']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString(),
    );
  }
}
