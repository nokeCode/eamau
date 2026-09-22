import '../../models/home/banner_model.dart';
import '../slide/slide_service.dart';

class BannerService {
  final SlideService _slideService = SlideService();

  Future<List<BannerModel>> getBanners() async {
    try {
      final slides = await _slideService.getEnabledSlides();

      if (slides.isNotEmpty) {
        return slides.map((slide) => BannerModel(
          title: slide.titre,
          description: slide.contenu ?? '',
          image: slide.imageUrl ?? slide.imageName ?? '',
        )).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> hasActiveBanners() async {
    try {
      final slides = await _slideService.getEnabledSlides();
      return slides.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}