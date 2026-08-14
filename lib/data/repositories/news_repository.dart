import '../../models/news/news_model.dart';
import '../local/news_local_datasource.dart';
import '../remote/news_remote_datasource.dart';

/// Repository: local-first strategy for news
class NewsRepository {
  final NewsLocalDatasource local;
  final NewsRemoteDatasource remote;

  NewsRepository({required this.local, required this.remote});

  Future<List<NewsModel>> getNewsList() async {
    final localData = await local.getAllNews();
    // return local data immediately
    if (localData.isNotEmpty) return localData;

    // otherwise fetch remote and persist locally
    final remoteData = await remote.fetchNewsPage(1, 20);
    await local.saveNews(remoteData);
    return remoteData;
  }
}
