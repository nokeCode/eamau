import '../../models/news/news_model.dart';

/// Remote datasource for news - delegates to existing NewsService
class NewsRemoteDatasource {
  // TODO: inject NewsService (or Dio client)
  Future<List<NewsModel>> fetchNewsPage(int page, int limit, {int? categoryId}) async {
    // call API and return mapped models
    return [];
  }

  Future<NewsModel?> fetchNewsDetail(String slug) async {
    return null;
  }
}
