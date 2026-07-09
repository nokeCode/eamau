import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/concours/candidature_model.dart';

class CandidatureService {
  static const String endpoint =
      'api/eamau/concours/candidature';

  Future<bool> submitCandidature(
      CandidatureModel candidature,
      ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoint),
      );

      request.fields.addAll(candidature.toJson());

      await _addFile(
        request,
        'photo_identite',
        candidature.photoIdentite,
      );

      await _addFile(
        request,
        'acte_naissance',
        candidature.acteNaissance,
      );

      await _addFile(
        request,
        'diplome',
        candidature.diplome,
      );

      await _addFile(
        request,
        'releve_notes',
        candidature.releveNotes,
      );

      await _addFile(
        request,
        'carte_identite',
        candidature.carteIdentite,
      );

      final response = await request.send();

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<void> _addFile(
      http.MultipartRequest request,
      String field,
      File? file,
      ) async {
    if (file == null) return;

    request.files.add(
      await http.MultipartFile.fromPath(
        field,
        file.path,
      ),
    );
  }

  Future<Map<String, dynamic>?> getConfirmation(
      int candidatureId) async {
    try {
      final response = await http.get(
        Uri.parse('$endpoint/$candidatureId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {}

    return null;
  }
}