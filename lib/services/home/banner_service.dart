

import '../../models/home/banner_model.dart';

class BannerService {

  Future<List<BannerModel>> getBanners() async {

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return [

      BannerModel(
        title: 'Construisez votre avenir avec EAMAU',
        description:
        'Excellence académique, leadership de demain.',
        image:
        'assets/images/building1.jpg',
      ),

      BannerModel(
        title: 'Rejoignez une école d’excellence',
        description:
        'Une formation adaptée aux métiers de demain.',
        image:
        'assets/images/building2.jpg',
      ),
    ];
  }
}