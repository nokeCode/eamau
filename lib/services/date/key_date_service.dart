import 'package:dio/dio.dart';

import '../../core/api/dio_client.dart';
import '../../models/date/key_date_model.dart';

class KeyDateService {
  final DioClient _dioClient = DioClient();

  Future<List<KeyDateModel>> getKeyDates() async {
    try {
      final response = await _dioClient.dio.get(
        '/front/key-dates',
        options: Options(extra: {'skipAuth': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .where((item) => item['enabled'] == true)
              .map((item) => KeyDateModel.fromJson(item))
              .toList();
        }
        
        if (data is List) {
          return data
              .where((item) => item['enabled'] == true)
              .map((item) => KeyDateModel.fromJson(item))
              .toList();
        }
        
        return [];
      }
      
      return [];
    } catch (e) {
      print('Error loading key dates: $e');
      return [];
    }
  }

}
