import '../../models/news/news_model.dart';
import '../../services/news/news_service.dart';

/// Remote datasource for news - wraps `NewsService`.
class NewsRemoteDatasource {
  final NewsService service;

  NewsRemoteDatasource({required this.service});

  Future<List<NewsModel>> fetchNewsPage(int page, int limit, {int? categoryId}) async {
    final result = await service.getNewsPage(page: page, limit: limit, categoryId: categoryId);
    return result.items;
  }

  Future<NewsModel?> fetchNewsDetail(String slug) async {
    try {
      final model = await service.getNewsBySlug(slug);
      return model;
    } catch (_) {
      return null;
    }
  }
}

