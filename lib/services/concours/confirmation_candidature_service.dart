import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/concours/confirmation_candidature_model.dart';

class ConfirmationCandidatureService {
  static const endpoint =
      "api/eamau/concours/confirmation";

  Future<ConfirmationCandidatureModel>
  getConfirmation(int id) async {
    try {
      final response = await http.get(
        Uri.parse("$endpoint/$id"),
      );

      if (response.statusCode == 200) {
        return ConfirmationCandidatureModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (_) {}

    return fallbackConfirmation;
  }
}

const fallbackConfirmation =
ConfirmationCandidatureModel(
  numeroCandidature: "EAMAU-2025-000154",
  message:
  "Votre candidature a été enregistrée avec succès.",
  attestationUrl:
  "https://www.eamau.org/attestation.pdf",
  statut: "Soumise",
);