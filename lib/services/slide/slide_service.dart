import 'package:dio/dio.dart';

import '../../core/api/api_endpoints.dart';
import '../../core/api/dio_client.dart';
import '../../models/slide/slide_model.dart';

class SlideService {
  final DioClient _dioClient = DioClient();

  Future<List<SlideModel>> getSlides() async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.slides,
        options: Options(extra: {'skipAuth': true}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        return data
            .where((item) => item['enabled'] == true)
            .map((item) => SlideModel.fromJson(item))
            .toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<SlideModel>> getEnabledSlides() async {
    final slides = await getSlides();
    return slides.where((slide) => slide.enabled).toList();
  }
}
