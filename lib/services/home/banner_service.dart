import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/home/banner_model.dart';

class BannerService {

  static const String endpoint =
      'https://api.eamau.tg/banners';

  Future<List<BannerModel>> getBanners() async {

    try {

      final response = await http.get(
        Uri.parse(endpoint),
      );

      if (response.statusCode == 200) {

        final List<dynamic> data =
        jsonDecode(response.body);

        return data.map((item) {

          return BannerModel(
            title: item['title'],
            description: item['description'],
            image: item['image'],
          );

        }).toList();
      }

      return _fallbackBanners();

    } catch (e) {

      return _fallbackBanners();
    }
  }

  List<BannerModel> _fallbackBanners() {

    return [

      BannerModel(
        title: 'Construisez votre avenir avec EAMAU',
        description:
        'Excellence académique, leadership de demain.',
        image: 'assets/images/building.jpg',
      ),

      BannerModel(
        title: 'Rejoignez une école d’excellence',
        description:
        'Une formation adaptée aux métiers du futur.',
        image: 'assets/images/building2.jpg',
      ),

      BannerModel(
        title: 'Architecture et Urbanisme',
        description:
        'Formez-vous aux métiers de demain.',
        image: 'assets/images/building3.jpg',
      ),
    ];
  }
}