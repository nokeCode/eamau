import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api/api_config.dart';
import '../../core/storage/token_storage.dart';
import '../../models/news/news_category_model.dart';
import '../../models/news/news_model.dart';

class PublicationPageResult {
  final List<NewsModel> items;
  final NewsMeta meta;

  const PublicationPageResult({required this.items, required this.meta});
}

class PublicationService {
  final http.Client? client;
  final TokenStorage _tokenStorage = TokenStorage();

  PublicationService({this.client});

  static const String _publicationPath = '${ApiConfig.fullBaseUrl}/publications';

  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    // Pour test: désactiver l'authentification temporairement
    // final token = await _tokenStorage.getAccessToken();
    // if (token != null && token.isNotEmpty) {
    //   headers['Authorization'] = 'Bearer $token';
    // }
    return headers;
  }

  Future<PublicationPageResult> getPublicationsPage({
    int page = 1,
    int limit = 12,
    int? categoryId,
    bool featured = false,
  }) async {
    print('PublicationService: GET /publications page=$page, limit=$limit, categoryId=$categoryId, featured=$featured');
    
    // L'API retourne déjà la première page (12 éléments) lorsque aucun
    // paramètre n'est fourni.  Ne pas envoyer `page` et `limit` dans ce cas :
    // certaines versions du backend échouent en interne avec ces paramètres,
    // alors que GET /publications fonctionne correctement.
    final query = <String, String>{};
    if (page != 1 || limit != 12) {
      query['page'] = '$page';
      query['limit'] = '$limit';
    }

    if (categoryId != null && categoryId > 0) {
      query['category'] = '$categoryId';
    }

    if (featured) {
      query['featured'] = 'true';
    }

    final uri = Uri.parse(_buildUrl(_publicationPath, query));
    print('PublicationService: URL = $uri');
    
    final response = await (client ?? http.Client()).get(uri, headers: await _headers());
    
    print('PublicationService: Response status = ${response.statusCode}');
    print('PublicationService: Response body = ${response.body}');

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Échec lors du chargement des publications: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? <dynamic>[];
    final meta = decoded['meta'] is Map<String, dynamic>
        ? decoded['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    print('PublicationService: Parsed ${data.length} items');

    return PublicationPageResult(
      items: data
          .map((item) => NewsModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      meta: NewsMeta.fromJson(meta),
    );
  }

  Future<PublicationPageResult> searchPublications(
    String query, {
    int page = 1,
    int limit = 12,
    int? categoryId,
  }) async {
    if (query.trim().isEmpty) {
      return getPublicationsPage(page: page, limit: limit, categoryId: categoryId);
    }

    print('PublicationService: SEARCH /publications/search q="$query"');
    
    final queryParams = <String, String>{
      'q': query.trim(),
      'page': '$page',
      'limit': '$limit',
    };
    if (categoryId != null && categoryId > 0) {
      queryParams['category'] = '$categoryId';
    }

    final uri = Uri.parse('$_publicationPath/search');
    print('PublicationService: Search URL = $uri');
    
    // Le contrat public définit une recherche en POST. Envoyer les critères
    // dans le corps JSON plutôt que dans la query string d'une requête GET.
    final response = await (client ?? http.Client()).post(
      uri,
      headers: await _headers(),
      body: jsonEncode(queryParams),
    );
    
    print('PublicationService: Search Response status = ${response.statusCode}');

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Échec lors de la recherche des publications');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? <dynamic>[];
    final meta = decoded['meta'] is Map<String, dynamic>
        ? decoded['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    return PublicationPageResult(
      items: data
          .map((item) => NewsModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      meta: NewsMeta.fromJson(meta),
    );
  }

  Future<List<NewsModel>> getFeaturedPublications() async {
    print('PublicationService: GET /publications?featured=true');
    final result = await getPublicationsPage(page: 1, limit: 10, featured: true);
    return result.items;
  }

  Future<NewsModel> getPublicationBySlug(String slug) async {
    print('PublicationService: GET /publications/$slug');
    final response = await (client ?? http.Client()).get(
      Uri.parse('$_publicationPath/$slug'),
      headers: await _headers(),
    );

    print('PublicationService: BySlug Response status = ${response.statusCode}');

    if (response.statusCode != 200) {
      final decoded = _tryDecodeBody(response.body);
      final message = decoded?['message']?.toString();
      throw Exception(message ?? 'Publication scientifique introuvable');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Publication scientifique introuvable');
    }

    return NewsModel.fromJson(data);
  }

  Future<List<NewsCategoryModel>> getCategories() async {
    print('PublicationService: GET /publications/categories');
    try {
      final response = await (client ?? http.Client()).get(
        Uri.parse('$_publicationPath/categories'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as List? ?? <dynamic>[];
        final categories = data
            .map(
              (item) => NewsCategoryModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        return [const NewsCategoryModel(id: 0, name: 'Toutes'), ...categories];
      }
    } catch (e) {
      print('PublicationService: getCategories error: $e');
    }

    return const [NewsCategoryModel(id: 0, name: 'Toutes')];
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
    final entries = query.entries.where((entry) => entry.value.isNotEmpty).toList();

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
