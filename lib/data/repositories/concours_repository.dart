import 'package:flutter/foundation.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../models/concours/concours_model.dart';
import '../../models/concours/concours_detail_model.dart';
import '../local/concours_local_datasource.dart';
import '../remote/concours_remote_datasource.dart';

class ConcoursRepository {
  final ConcoursLocalDatasource local;
  final ConcoursRemoteDatasource remote;

  ConcoursRepository({required this.local, required this.remote});

  /// Online: always the network's current truth, saved into SQLite so the
  /// OFFLINE fallback below reflects it too — no local-cache-first paint
  /// here, on purpose. That's what used to let an unpublished concours
  /// keep showing: the SQLite row lived on until some later background
  /// sync happened to prune it, and whoever was already looking at the
  /// screen never found out. Being online means there's no reason to trust
  /// anything but the backend's current answer.
  ///
  /// Offline: no way to ask the backend anything, so SQLite (whatever the
  /// last successful sync left there) is the only option — accepted as
  /// possibly stale, which is the actual tradeoff of being offline rather
  /// than a bug.
  Future<List<ConcoursModel>> getConcours({int page = 1, int limit = 10, String? query}) async {
    final online = await ConnectivityService().isOnline();

    if (online) {
      try {
        final remoteData = await remote.fetchConcours(page: page, limit: limit, query: query);
        debugPrint('[CONCOURS] Liste chargée depuis le réseau (en ligne)');
        await local.saveConcours(remoteData);
        if (query == null || query.trim().isEmpty) {
          final remoteIds = remoteData.map((e) => e.id).where((id) => id.isNotEmpty).toSet().toList();
          await local.deleteConcoursNotIn(remoteIds);
        }
        return remoteData;
      } catch (e) {
        // Reported online but the call itself failed (server down,
        // timeout...) — fall back to the last known-good snapshot instead
        // of an empty/error screen.
        debugPrint('[CONCOURS] Échec réseau malgré une connexion active, repli sur SQLite: $e');
        return local.getAllConcours();
      }
    }

    debugPrint('[CONCOURS] Hors-ligne -> liste chargée depuis SQLite (dernière synchronisation)');
    return local.getAllConcours();
  }

  /// Same online/offline principle as [getConcours]: online always asks the
  /// backend directly (a concours unpublished moments ago must not keep
  /// showing its old detail just because SQLite still has it); SQLite is
  /// only consulted as a fallback — when offline, or when a call reported
  /// online still fails outright (server down, timeout...).
  Future<ConcoursDetailModel> getConcoursDetail(String slug) async {
    final online = await ConnectivityService().isOnline();

    if (online) {
      try {
        final remoteDetail = await remote.fetchDetail(slug);
        debugPrint('[CONCOURS] Détail chargé depuis le réseau (en ligne) : $slug');
        await local.saveConcours([_toSummaryModel(remoteDetail)]);
        return remoteDetail;
      } catch (e) {
        debugPrint('[CONCOURS] Échec réseau détail malgré une connexion active, '
            'repli sur SQLite : $slug ($e)');
        final localItem = await local.getConcoursDetail(slug);
        if (localItem != null) {
          return ConcoursDetailModel.fromJson(localItem.toJson());
        }
        rethrow;
      }
    }

    debugPrint('[CONCOURS] Hors-ligne -> détail chargé depuis SQLite : $slug');
    final localItem = await local.getConcoursDetail(slug);
    if (localItem != null) {
      return ConcoursDetailModel.fromJson(localItem.toJson());
    }
    throw Exception('Ce concours n’est pas disponible hors-ligne.');
  }

  ConcoursModel _toSummaryModel(ConcoursDetailModel detail) {
    return ConcoursModel(
      id: detail.id,
      titre: detail.titre,
      slug: detail.slug,
      year: '',
      description: detail.description,
      image: detail.image,
      statut: detail.active ? 'Actif' : 'Inactif',
      startingAt: detail.periodeInscription,
      endingAt: detail.dateExamen,
    );
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
