import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/news/news_model.dart';

class NewsService {
  static const String endpoint =
      'api/endpoint/news';

  Future<List<NewsModel>> getNews() async {
    try {
      final response =
      await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data =
        jsonDecode(response.body);

        return data
            .map(
              (e) => NewsModel.fromJson(e),
        )
            .toList();
      }

      return fallbackNews;
    } catch (_) {
      return fallbackNews;
    }
  }
}

const List<NewsModel> fallbackNews = [
  NewsModel(
    id: 1,
    title: 'Atelier internationale',
    description:
    "Des figures territoriales et des architectures manifeste.",
    image:
    'assets/images/actualite1.jpg',
    date: '07 avril 2026',
    featured: false,
  ),
  NewsModel(
    id: 2,
    title: "Concours d'entrée",
    description:
    "Concours d'entrée au titre de l'année académique.",
    image:
    'assets/images/actualite2.jpg',
    date: '12 mai 2026',
    featured: false,
  ),
  NewsModel(
    id: 3,
    title:
    "Installation du Comité d'organisation",
    description:
    "Réunion d'installation du Comité.",
    image:
    'assets/images/actualite3.jpg',
    date: '27 février 2026',
    featured: false,
  ),
];