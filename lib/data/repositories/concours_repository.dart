import 'package:flutter/foundation.dart';

import '../../models/concours/concours_model.dart';
import '../../models/concours/concours_detail_model.dart';
import '../local/concours_local_datasource.dart';
import '../remote/concours_remote_datasource.dart';

class ConcoursRepository {
  final ConcoursLocalDatasource local;
  final ConcoursRemoteDatasource remote;

  ConcoursRepository({required this.local, required this.remote});

  Future<List<ConcoursModel>> getConcours({int page = 1, int limit = 10, String? query}) async {
    final localData = await local.getAllConcours();
    if (localData.isNotEmpty && (query == null || query.trim().isEmpty)) {
      debugPrint('[CONCOURS] Liste chargée depuis SQLite');
      // refresh in background
      remote.fetchConcours(page: 1, limit: 50).then((remoteList) async {
        try {
          if (remoteList.isNotEmpty) {
            await local.saveConcours(remoteList);
            final remoteIds = remoteList.map((e) => e.id).where((id) => id.isNotEmpty).toSet().toList();
            await local.deleteConcoursNotIn(remoteIds);
            debugPrint('[CONCOURS] Liste sauvegardée dans SQLite');
          }
        } catch (_) {}
      }).catchError((_) {});

      return localData;
    }

    final remoteData = await remote.fetchConcours(page: page, limit: limit, query: query);
    if (remoteData.isNotEmpty) {
      await local.saveConcours(remoteData);
    }
    return remoteData;
  }

  Future<ConcoursDetailModel> getConcoursDetail(String slug) async {
    final localItem = await local.getConcoursDetail(slug);
    if (localItem != null) {
      debugPrint('[CONCOURS] Détail chargé depuis SQLite : $slug');
      try {
        final remoteDetail = await remote.fetchDetail(slug);
        await local.saveConcours([
          ConcoursModel(
            id: remoteDetail.id,
            titre: remoteDetail.titre,
            slug: remoteDetail.slug,
            year: '',
            description: remoteDetail.description,
            image: remoteDetail.image,
            statut: remoteDetail.active ? 'Actif' : 'Inactif',
            startingAt: remoteDetail.periodeInscription,
            endingAt: remoteDetail.dateExamen,
          )
        ]);
      } catch (_) {}
      return ConcoursDetailModel.fromJson(localItem.toJson());
    }

    final remoteDetail = await remote.fetchDetail(slug);
    // persist summary
    await local.saveConcours([
      ConcoursModel(
        id: remoteDetail.id,
        titre: remoteDetail.titre,
        slug: remoteDetail.slug,
        year: '',
        description: remoteDetail.description,
        image: remoteDetail.image,
        statut: remoteDetail.active ? 'Actif' : 'Inactif',
        startingAt: remoteDetail.periodeInscription,
        endingAt: remoteDetail.dateExamen,
      )
    ]);
    return remoteDetail;
  }

  Future<void> fullSyncConcours({int page = 1, int limit = 12}) async {
    try {
      final allItems = <ConcoursModel>[];
      int currentPage = page;
      List<ConcoursModel> result;

      do {
        result = await remote.fetchConcours(page: currentPage, limit: limit);
        allItems.addAll(result);
        currentPage++;
      } while (result.isNotEmpty);

      if (allItems.isNotEmpty) {
        await local.saveConcours(allItems);
        final remoteIds = allItems.map((e) => e.id).where((id) => id.isNotEmpty).toSet().toList();
        await local.deleteConcoursNotIn(remoteIds);
        debugPrint('[CONCOURS] fullSyncConcours: synchronization complète terminée (${allItems.length} items)');
      }
    } catch (e) {
      debugPrint('[CONCOURS] Erreur fullSyncConcours: $e');
    }
  }
}
