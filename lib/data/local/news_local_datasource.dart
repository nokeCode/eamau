import '../../models/news/news_model.dart';

/// Local datasource for news (Drift-backed) - skeleton
class NewsLocalDatasource {
  // TODO: inject AppDatabase and implement CRUD + queries

  Future<List<NewsModel>> getAllNews() async {
    // read from local DB
    return [];
  }

  Future<void> saveNews(List<NewsModel> news) async {
    // write to local DB
  }

  Future<NewsModel?> getNewsDetail(String slug) async {
    return null;
  }
}
