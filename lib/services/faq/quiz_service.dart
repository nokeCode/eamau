import 'package:dio/dio.dart';

import '../../core/api/dio_client.dart';
import '../../models/faq/quiz_model.dart';

class QuizService {
  final DioClient _dioClient = DioClient();

  Future<List<QuizModel>> getFAQs() async {
    try {
      final response = await _dioClient.dio.get(
        '/faq/quiz',
        options: Options(extra: {'skipAuth': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .where((item) => item['enabled'] == true)
              .map((item) => QuizModel.fromJson(item))
              .toList();
        }
        
        if (data is List) {
          return data
              .where((item) => item['enabled'] == true)
              .map((item) => QuizModel.fromJson(item))
              .toList();
        }
        
        return [];
      }
      
      return [];
    } catch (e) {
      print('Error loading FAQs: $e');
      return [];
    }
  }
}
