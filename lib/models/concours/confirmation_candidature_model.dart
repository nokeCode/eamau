class ConfirmationCandidatureModel {
  final String numeroCandidature;
  final String message;
  final String attestationUrl;
  final String statut;

  const ConfirmationCandidatureModel({
    required this.numeroCandidature,
    required this.message,
    required this.attestationUrl,
    required this.statut,
  });

  factory ConfirmationCandidatureModel.fromJson(
      Map<String, dynamic> json) {
    return ConfirmationCandidatureModel(
      numeroCandidature:
      json['numero_candidature'] ?? '',
      message: json['message'] ?? '',
      attestationUrl:
      json['attestation_url'] ?? '',
      statut: json['statut'] ?? '',
    );
  }
}