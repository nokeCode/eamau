import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/admission/admission_tracking_model.dart';

class AdmissionTrackingService {

  static const String baseUrl =
      "https://votre-api.com/api/admission";

  static const Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<AdmissionTrackingModel> getTracking() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/tracking"),
        headers: headers,
      );

      if (response.statusCode == 200) {

        return AdmissionTrackingModel.fromJson(
          jsonDecode(response.body),
        );

      }

    } catch (_) {}

    return AdmissionTrackingModel.fromJson(
      fallbackTrackingData,
    );
  }

  Future<bool> refreshTracking() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/tracking/refresh"),
        headers: headers,
      );

      return response.statusCode == 200;

    } catch (_) {

      return false;

    }

  }

  Future<bool> cancelAdmission() async {

    try {

      final response = await http.delete(
        Uri.parse("$baseUrl/request"),
        headers: headers,
      );

      return response.statusCode == 200;

    } catch (_) {

      return false;

    }

  }
}

const Map<String, dynamic> fallbackTrackingData = {

  "reference":"EAMAU-2024-0258",

  "submission_date":"15 mai 2024",

  "status":"En cours d'étude",

  "steps":[

    {

      "title":"Demande reçue",

      "description":
      "Votre candidature a été reçue avec succès.",

      "date":"12 mai 2025",

      "completed":true

    },

    {

      "title":"Étude de dossier",

      "description":
      "Votre dossier est actuellement en cours d'examen par notre comité pédagogique.",

      "date":"14 mai 2025",

      "completed":true

    },

    {

      "title":"Décision",

      "description":
      "La décision sera communiquée par email dans les prochains jours.",

      "date":"",

      "completed":false

    }

  ]

};