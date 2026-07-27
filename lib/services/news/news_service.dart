import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/news/news_model.dart';
import '../../models/news/news_category_model.dart';
import '../api_client.dart';

class NewsService {
  final ApiClient _apiClient = ApiClient();

  // Récupérer la liste des actualités
  Future<List<NewsModel>> getNews({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
      };

      final response = await _apiClient.get(
        '/news',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data.map((e) => NewsModel.fromJson(e)).toList();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List)
              .map((e) => NewsModel.fromJson(e))
              .toList();
        }
      }

      return fallbackNews;
    } catch (_) {
      return fallbackNews;
    }
  }

  // Récupérer les actualités en avant
  Future<List<NewsModel>> getFeaturedNews() async {
    try {
      final response = await _apiClient.get('/news/featured');

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data.map((e) => NewsModel.fromJson(e)).toList();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List)
              .map((e) => NewsModel.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  // Récupérer les catégories
  Future<List<NewsCategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get('/news/categories');

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data.map((e) => NewsCategoryModel.fromJson(e)).toList();
        } else if (data is Map && data['categories'] is List) {
          return (data['categories'] as List)
              .map((e) => NewsCategoryModel.fromJson(e))
              .toList();
        }
      }

      return fallbackCategories;
    } catch (_) {
      return fallbackCategories;
    }
  }

  // Rechercher les actualités
  Future<List<NewsModel>> searchNews({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiClient.get(
        '/news/search',
        queryParams: queryParams,
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data.map((e) => NewsModel.fromJson(e)).toList();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List)
              .map((e) => NewsModel.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  // Récupérer un détail d'actualité par slug
  Future<NewsModel?> getNewsBySlug(String slug) async {
    try {
      final response = await _apiClient.get('/news/$slug');

      if (response['success'] == true && response['data'] != null) {
        return NewsModel.fromJson(response['data']);
      }
    } catch (_) {}

    return null;
  }

  // Récupérer les actualités par catégorie
  Future<List<NewsModel>> getNewsByCategory(int categoryId) async {
    try {
      final response = await _apiClient.get(
        '/news',
        queryParams: {'category': categoryId.toString()},
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is List) {
          return data.map((e) => NewsModel.fromJson(e)).toList();
        } else if (data is Map && data['items'] is List) {
          return (data['items'] as List)
              .map((e) => NewsModel.fromJson(e))
              .toList();
        }
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
