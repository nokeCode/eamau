import 'package:flutter/foundation.dart';
import '../../models/news/news_model.dart';
import '../../models/news/news_category_model.dart';
import '../../services/publication/publication_service.dart';
import '../local/publication_local_datasource.dart';
import '../remote/publication_remote_datasource.dart';

class PublicationRepository {
  final PublicationLocalDatasource local;
  final PublicationRemoteDatasource remote;

  PublicationRepository({required this.local, required this.remote});

  /// Local-first for publications pages
  Future<PublicationPageResult> getPublicationsPage({int page = 1, int limit = 12, int? categoryId, bool featured = false}) async {
    final localData = await local.getAllPublications();
    if (localData.isNotEmpty) {
      debugPrint('[PUBLICATIONS] Liste chargée depuis SQLite');
      // trigger background refresh
      remote.fetchPublicationsPage(page: 1, limit: 50).then((remoteResult) async {
        try {
          if (remoteResult.items.isNotEmpty) {
            await local.savePublications(remoteResult.items);
            final remoteIds = remoteResult.items.map((e) => e.id).where((id) => id != 0).toSet().toList();
            await local.deletePublicationsNotIn(remoteIds);
            debugPrint('[PUBLICATIONS] Liste sauvegardée dans SQLite');
          }
        } catch (_) {}
      }).catchError((_) {});

      // Return local data wrapped in a PublicationPageResult with basic meta
      final meta = NewsMeta(page: 1, perPage: localData.length, lastPage: 1, total: localData.length);
      return PublicationPageResult(items: localData, meta: meta);
    }

    final remoteData = await remote.fetchPublicationsPage(page: page, limit: limit, categoryId: categoryId, featured: featured);
    debugPrint('[PUBLICATIONS] Liste chargée depuis API');
    await local.savePublications(remoteData.items);
    debugPrint('[PUBLICATIONS] Liste sauvegardée dans SQLite');
    return remoteData;
  }

  Future<PublicationPageResult> searchPublications(String query, {int page = 1, int limit = 12, int? categoryId}) async {
    // Attempt local search first
    final localData = await local.getAllPublications();
    final filtered = localData.where((p) => p.title.toLowerCase().contains(query.toLowerCase()) || p.summary.toLowerCase().contains(query.toLowerCase())).toList();
    if (filtered.isNotEmpty) {
      final meta = NewsMeta(page: 1, perPage: filtered.length, lastPage: 1, total: filtered.length);
      return PublicationPageResult(items: filtered, meta: meta);
    }

    // Fallback to remote
    final remoteResult = await remote.searchPublications(query, page: page, limit: limit, categoryId: categoryId);
    // Persist remote results
    if (remoteResult.items.isNotEmpty) {
      await local.savePublications(remoteResult.items);
    }
    return remoteResult;
  }

  Future<List<NewsModel>> getFeaturedPublications() async {
    final result = await getPublicationsPage(page: 1, limit: 10, categoryId: null, featured: true);
    return result.items;
  }

  Future<List<NewsCategoryModel>> getCategories() async {
    try {
      return await remote.fetchCategories();
    } catch (_) {
      return const [NewsCategoryModel(id: 0, name: 'Toutes')];
    }
  }

  Future<NewsModel> getPublicationBySlug(String slug) async {
    final localItem = await local.getPublicationDetail(slug);
    if (localItem != null) {
      debugPrint('[PUBLICATIONS] Détail chargé depuis SQLite : $slug');
      return localItem;
    }
    debugPrint('[PUBLICATIONS] Aucun détail en cache pour : $slug');
    final remoteModel = await remote.fetchBySlug(slug);
    debugPrint('[PUBLICATIONS] Détail chargé depuis API : $slug');
    await local.savePublications([remoteModel]);
    debugPrint('[PUBLICATIONS] Détail sauvegardé dans SQLite : $slug');
    return remoteModel;
  }

  /// Full synchronization (fetch all pages and reconcile)
  Future<void> fullSyncPublications({int page = 1, int limit = 12}) async {
    // Use conservative page size by default to avoid backend errors when
    // page/limit parameters are rejected by some server versions.
    try {
      final allItems = <NewsModel>[];
      int currentPage = page;
      NewsMeta? meta;

      do {
        try {
          final result = await remote.fetchPublicationsPage(page: currentPage, limit: limit);
          allItems.addAll(result.items);
          meta = result.meta;
          currentPage++;
        } catch (e) {
          debugPrint('[PUBLICATIONS] fetch page=$currentPage limit=$limit failed: $e');
          // If we used a larger-than-default limit, retry the failing page with the safe default (12).
          if (limit != 12) {
            try {
              debugPrint('[PUBLICATIONS] Retrying page $currentPage with limit=12');
              final retry = await remote.fetchPublicationsPage(page: currentPage, limit: 12);
              allItems.addAll(retry.items);
              meta = retry.meta;
              currentPage++;
              // reduce the working limit going forward
              limit = 12;
              continue;
            } catch (e2) {
              debugPrint('[PUBLICATIONS] Retry also failed for page $currentPage: $e2');
              rethrow;
            }
          }
          rethrow;
        }
      } while (meta != null && currentPage <= meta.lastPage);

      if (allItems.isNotEmpty) {
        await local.savePublications(allItems);
        final remoteIds = allItems.map((e) => e.id).where((id) => id != 0).toSet().toList();
        await local.deletePublicationsNotIn(remoteIds);
        debugPrint('[PUBLICATIONS] fullSyncPublications: synchronization complète terminée (${allItems.length} items)');
      } else {
        await local.deletePublicationsNotIn([]);
        debugPrint('[PUBLICATIONS] fullSyncPublications: aucun item distant, suppression locale effectuée');
      }
    } catch (e) {
      debugPrint('[PUBLICATIONS] Erreur fullSyncPublications: $e');
    }
  }
}
