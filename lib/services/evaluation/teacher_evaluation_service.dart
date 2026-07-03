import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/evaluation/teacher_evaluation_model.dart';

class TeacherEvaluationService {
  static const String baseUrl = 'https://ton-api.com';

  Future<TeacherEvaluationModel> getEvaluation() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/eamau/evalue/ens'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return TeacherEvaluationModel.fromJson(json);
      }
    } catch (_) {}

    return TeacherEvaluationModel.fallback();
  }

  Future<bool> submitEvaluation({
    required int courseId,
    required int teacherId,
    required Map<String, int> ratings,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/eamau/evalue/ens'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'course_id': courseId,
          'teacher_id': teacherId,
          'ratings': ratings,
          'comment': comment,
        }),
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}