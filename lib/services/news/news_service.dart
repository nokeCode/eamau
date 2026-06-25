import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/news/news_model.dart';
import '../../models/news/news_category_model.dart';

class NewsService {
  static const String endpoint = 'api/endpoint/news';
  static const String categoriesEndpoint = 'api/endpoint/news/categories';

  Future<List<NewsModel>> getNews() async {
    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((e) => NewsModel.fromJson(e)).toList();
      }

      return fallbackNews;
    } catch (_) {
      return fallbackNews;
    }
  }

  Future<List<NewsCategoryModel>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(categoriesEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((e) => NewsCategoryModel.fromJson(e)).toList();
      }

      return fallbackCategories;
    } catch (_) {
      return fallbackCategories;
    }
  }

  Future<List<NewsModel>> getNewsByCategory(
      int categoryId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'api/endpoint/news/category/$categoryId',
        ),
      );

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
    description: "Des figures territoriales et des architectures manifeste.",
    image: 'assets/images/actualite1.jpg',
    date: '07 avril 2026',
    featured: false,
  ),
  NewsModel(
    id: 2,
    title: "Concours d'entrée",
    description: "Concours d'entrée au titre de l'année académique.",
    image: 'assets/images/actualite2.jpg',
    date: '12 mai 2026',
    featured: false,
  ),
  NewsModel(
    id: 3,
    title: "Installation du Comité d'organisation",
    description: "Réunion d'installation du Comité.",
    image: 'assets/images/actualite3.jpg',
    date: '27 février 2026',
    featured: false,
  ),
];

const List<NewsCategoryModel>
fallbackCategories = [
  NewsCategoryModel(
    id: 0,
    name: 'Toutes',
  ),
  NewsCategoryModel(
    id: 1,
    name: 'Université',
  ),
  NewsCategoryModel(
    id: 2,
    name: 'Recherche',
  ),
  NewsCategoryModel(
    id: 3,
    name: 'Étudiant',
  ),
  NewsCategoryModel(
    id: 4,
    name: 'Évènement',
  ),
];
