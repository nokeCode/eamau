import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/admission/admission_request_model.dart';

class AdmissionRequestService {

  static const String baseUrl =
      "https://votre-api.com/api/admission";

  static const Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  //------------------------------------------
  // GET Form Data
  //------------------------------------------

  Future<Map<String, dynamic>> getAdmissionForm() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/request"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

    } catch (_) {}

    return fallbackFormData;
  }

  //------------------------------------------
  // POST Admission
  //------------------------------------------

  Future<bool> submitAdmission(
      AdmissionRequestModel model) async {

    try {

      final response = await http.post(
        Uri.parse("$baseUrl/request"),
        headers: headers,
        body: jsonEncode(model.toJson()),
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;

    } catch (_) {

      return false;

    }
  }

  //------------------------------------------
  // Upload Documents
  //------------------------------------------

  Future<bool> uploadDocuments(
      int requestId,
      Map<String, File?> files,
      ) async {

    try {

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "$baseUrl/request/$requestId/upload"),
      );

      files.forEach((key, value) async {

        if (value != null) {

          request.files.add(
            await http.MultipartFile.fromPath(
              key,
              value.path,
            ),
          );

        }

      });

      final response = await request.send();

      return response.statusCode == 200;

    } catch (_) {

      return false;

    }

  }
}
const fallbackFormData = {

  "levels":[
    "L2",
    "L3",
    "L4",
    "L5",
  ],

  "programs":[
    "Architecture",
    "Urbanisme",
    "Gestion Urbaine",
  ],

  "nationalities":[
    "Togolaise",
    "Béninoise",
    "Burkinabè",
    "Ivoirienne",
    "Sénégalaise",
    "Nigérienne",
    "Camerounaise",
  ],

  "countries":[
    "Togo",
    "Bénin",
    "Burkina Faso",
    "Côte d'Ivoire",
    "Sénégal",
    "Niger",
    "Cameroun",
  ],

  "diplomas":[
    "Baccalauréat",
    "BTS",
    "DUT",
    "DEUG",
    "Licence",
    "Master",
  ],

  "documents":[
    "Photo d'identité",
    "Acte de naissance",
    "Diplôme",
    "Relevé de notes",
    "Lettre de motivation",
    "Casier judiciaire",
    "Certificat médical",
  ]
};