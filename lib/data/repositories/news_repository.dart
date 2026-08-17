import 'package:flutter/foundation.dart';

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
      debugPrint('[NEWS] Liste chargée depuis SQLite');
      // trigger background refresh
      remote.fetchNewsPage(1, 20).then((remoteData) async {
        try {
          if (remoteData.isNotEmpty) {
            debugPrint('[NEWS] Liste chargée depuis API');
            await local.saveNews(remoteData);
            debugPrint('[NEWS] Liste sauvegardée dans SQLite');
          }
        } catch (_) {}
      }).catchError((_) {});
      return localData;
    }

    // no local data: fetch remote and persist then return
    final remoteData = await remote.fetchNewsPage(1, 20);
    debugPrint('[NEWS] Liste chargée depuis API');
    await local.saveNews(remoteData);
    debugPrint('[NEWS] Liste sauvegardée dans SQLite');
    return remoteData;
  }

  Future<NewsModel?> getNewsDetail(String slug) async {
    final localItem = await local.getNewsDetail(slug);
    if (localItem != null) {
      debugPrint('[NEWS] Détail chargé depuis SQLite : $slug');
      return localItem;
    }
    debugPrint('[NEWS] Aucun détail en cache pour : $slug');
    final remoteModel = await remote.fetchNewsDetail(slug);
    if (remoteModel != null) {
      debugPrint('[NEWS] Détail chargé depuis API : $slug');
      await local.saveNews([remoteModel]);
      debugPrint('[NEWS] Détail sauvegardé dans SQLite : $slug');
    }
    return remoteModel;
  }

  /// Perform a full synchronization: fetch all pages from the remote API,
  /// upsert into local DB and remove local rows whose remoteId is not present
  /// on the server. This reconciles deletes performed server-side.
  Future<void> fullSyncNews({int page = 1, int limit = 50}) async {
    try {
      final allItems = <NewsModel>[];
      int currentPage = page;
      NewsMeta? meta;

      do {
        final result = await remote.service.getNewsPage(page: currentPage, limit: limit);
        allItems.addAll(result.items);
        meta = result.meta;
        currentPage++;
      } while (meta != null && currentPage <= meta.lastPage);

      if (allItems.isNotEmpty) {
        await local.saveNews(allItems);
        final remoteIds = allItems.map((e) => e.id).where((id) => id != 0).toSet().toList();
        await local.deleteNewsNotIn(remoteIds);
        debugPrint('[NEWS] fullSyncNews: synchronization complète terminée (${allItems.length} articles)');
      } else {
        // Nothing returned: ensure local entries with remoteId are removed
        await local.deleteNewsNotIn([]);
        debugPrint('[NEWS] fullSyncNews: aucun article distant, suppression locale effectuée');
      }
    } catch (e) {
      debugPrint('[NEWS] Erreur fullSyncNews: $e');
    }
  }
}
