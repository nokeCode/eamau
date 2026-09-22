/// One item of the authenticated user's own registrations ("inscriptions"),
/// as returned by `GET /inscriptions`. Field names are parsed defensively
/// (a couple of plausible spellings each) since this list endpoint's exact
/// per-item shape hasn't been confirmed against a live sample yet — only
/// `id` and `anneeScolaireId`/`annee_scolaire_id` are known-safe, from the
/// existing `_findExistingRegistrationId` filtering logic in
/// RegistrationService.
class RegistrationSummaryModel {
  final int? id;
  final String? status;
  final String? schoolYear;
  final String? createdAt;
  final String? submittedAt;

  const RegistrationSummaryModel({
    this.id,
    this.status,
    this.schoolYear,
    this.createdAt,
    this.submittedAt,
  });

  factory RegistrationSummaryModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'] ?? json['inscriptionId'] ?? json['registrationId'];
    final schoolYearValue = json['anneeScolaire'] ??
        json['annee_scolaire'] ??
        json['schoolYear'] ??
        json['anneeScolaireId'] ??
        json['annee_scolaire_id'];

    return RegistrationSummaryModel(
      id: idValue is int ? idValue : int.tryParse(idValue?.toString() ?? ''),
      status: json['status']?.toString() ?? json['statut']?.toString(),
      schoolYear: schoolYearValue?.toString(),
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      submittedAt: json['submittedAt']?.toString() ?? json['submitted_at']?.toString(),
    );
  }
}
