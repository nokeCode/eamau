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
    if (localData.isNotEmpty) {
      // trigger background refresh
      remote.fetchNewsPage(1, 20).then((remoteData) async {
        if (remoteData.isNotEmpty) {
          await local.saveNews(remoteData);
        }
      }).catchError((_) {});
      return localData;
    }

    // no local data: fetch remote and persist then return
    final remoteData = await remote.fetchNewsPage(1, 20);
    await local.saveNews(remoteData);
    return remoteData;
  }

  Future<NewsModel?> getNewsDetail(String slug) async {
    final localItem = await local.getNewsDetail(slug);
    if (localItem != null) return localItem;
    final remoteModel = await remote.fetchNewsDetail(slug);
    if (remoteModel != null) await local.saveNews([remoteModel]);
    return remoteModel;
  }
}
