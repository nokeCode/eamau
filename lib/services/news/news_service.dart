import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../models/news/news_category_model.dart';
import '../../models/news/news_model.dart';

class NewsPageResult {
  final List<NewsModel> items;
  final NewsMeta meta;

  const NewsPageResult({required this.items, required this.meta});
}

class NewsService {
  final http.Client? client;

  NewsService({this.client});

  static const String _newsPath = '${ApiConfig.fullBaseUrl}/news';

  Future<NewsPageResult> getNewsPage({
    int page = 1,
    int limit = 10,
    int? categoryId,
  }) async {
    final query = <String, String>{'page': '$page', 'limit': '$limit'};

    if (categoryId != null && categoryId > 0) {
      query['category'] = '$categoryId';
    }

    final uri = Uri.parse(_buildUrl(_newsPath, query));
    final response = await (client ?? http.Client()).get(uri);

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Échec lors du chargement des actualités');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? <dynamic>[];
    final meta = decoded['meta'] is Map<String, dynamic>
        ? decoded['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    return NewsPageResult(
      items: data
          .map((item) => NewsModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      meta: NewsMeta.fromJson(meta),
    );
  }

  Future<NewsPageResult> searchNews(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return getNewsPage(page: page, limit: limit);
    }

    final uri = Uri.parse(
      _buildUrl('$_newsPath/search', {
        'q': query.trim(),
        'page': '$page',
        'limit': '$limit',
      }),
    );
    final response = await (client ?? http.Client()).get(uri);

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Échec lors de la recherche des actualités');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? <dynamic>[];
    final meta = decoded['meta'] is Map<String, dynamic>
        ? decoded['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    return NewsPageResult(
      items: data
          .map((item) => NewsModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      meta: NewsMeta.fromJson(meta),
    );
  }

  Future<List<NewsModel>> getFeaturedNews() async {
    final response = await (client ?? http.Client()).get(
      Uri.parse('$_newsPath/featured'),
    );

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(
        message ?? 'Échec lors du chargement des actualités à la une',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? <dynamic>[];

    return data
        .map((item) => NewsModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<NewsModel> getNewsBySlug(String slug) async {
    final response = await (client ?? http.Client()).get(
      Uri.parse('$_newsPath/$slug'),
    );

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Actualité introuvable');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Actualité introuvable');
    }

    return NewsModel.fromJson(data);
  }

  Future<List<NewsCategoryModel>> getCategories() async {
    final response = await (client ?? http.Client()).get(
      Uri.parse('$_newsPath/categories'),
    );

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Échec lors du chargement des catégories');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? <dynamic>[];
    final categories = data
        .map(
          (item) => NewsCategoryModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    return [const NewsCategoryModel(id: 0, name: 'Toutes'), ...categories];
  }

  Map<String, dynamic>? _tryDecodeBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  String _buildUrl(String path, Map<String, String> query) {
    final buffer = StringBuffer(path);
    final entries = query.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    if (entries.isNotEmpty) {
      buffer.write('?');
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        if (i > 0) {
          buffer.write('&');
        }
        buffer.write('${entry.key}=${Uri.encodeComponent(entry.value)}');
      }
    }

    return buffer.toString();
  }
}
