import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../models/concours/concours_model.dart';
import '../../core/database/app_database.dart';

class ConcoursLocalDatasource {
  final AppDatabase _db = AppDatabase();

  Future<List<ConcoursModel>> getAllConcours() async {
    final List<Concour> rows = await _db.select(_db.concours).get();
    return rows.map(_rowToModel).toList();
  }

  Future<void> saveConcours(List<ConcoursModel> items) async {
    final db = AppDatabase();
    for (final c in items) {
      try {
        if (c.id.isEmpty) {
          // An empty/missing remote id would make every such item collide
          // onto the same lookup below (upsert-by-remoteId), silently
          // overwriting one concours with another instead of inserting a
          // second row. Logged loudly rather than silently merging them.
          debugPrint('[CONCOURS][ERROR] id manquant pour "${c.slug}" -> '
              'risque de collision avec un autre concours, item ignoré');
          continue;
        }
        final existing = await (db.select(db.concours)..where((t) => t.remoteId.equals(c.id))).getSingleOrNull();

        final now = DateTime.now();
        if (existing != null) {
          final existingId = existing.id;
          await (db.update(db.concours)..where((t) => t.id.equals(existingId))).write(
            ConcoursCompanion(
              remoteId: Value(c.id),
              titre: Value(c.titre),
              slug: Value(c.slug),
              description: Value(c.description),
              image: Value(c.image),
              statut: Value(c.statut),
              startingAt: Value(c.startingAt),
              endingAt: Value(c.endingAt),
              updatedAt: Value(now),
            ),
          );
          debugPrint('[CONCOURS] Détail mis à jour dans SQLite : ${c.slug} (id=${c.id})');
        } else {
          final companion = ConcoursCompanion(
            remoteId: Value(c.id),
            titre: Value(c.titre),
            slug: Value(c.slug),
            description: Value(c.description),
            image: Value(c.image),
            statut: Value(c.statut),
            startingAt: Value(c.startingAt),
            endingAt: Value(c.endingAt),
            createdAt: Value(now),
            updatedAt: Value(now),
          );
          await db.into(db.concours).insert(companion);
          debugPrint('[CONCOURS] Nouvel item inséré dans SQLite : ${c.slug} (id=${c.id})');
        }
      } catch (e) {
        debugPrint('[CONCOURS] Erreur saveConcours ${c.slug}: $e');
      }
    }
  }

  Future<ConcoursModel?> getConcoursDetail(String slug) async {
    final Concour? row = await (_db.select(_db.concours)..where((t) => t.slug.equals(slug))).getSingleOrNull();
    return row == null ? null : _rowToModel(row);
  }

  Future<void> deleteConcoursNotIn(List<String> remoteIds) async {
    final db = AppDatabase();
    try {
      if (remoteIds.isEmpty) {
        await (db.delete(db.concours)..where((t) => t.remoteId.isNotNull())).go();
        debugPrint('[CONCOURS] Suppression locale: aucune remoteId trouvé sur le serveur');
        return;
      }

      await (db.delete(db.concours)..where((t) => t.remoteId.isNotIn(remoteIds) & t.remoteId.isNotNull())).go();
      debugPrint('[CONCOURS] Suppression locale: items absents du serveur supprimés');
    } catch (e) {
      debugPrint('[CONCOURS] Erreur deleteConcoursNotIn: $e');
    }
  }

  ConcoursModel _rowToModel(Concour row) {
    return ConcoursModel(
      id: row.remoteId ?? row.id.toString(),
      titre: row.titre,
      slug: row.slug,
      year: '',
      description: row.description ?? '',
      image: row.image ?? '',
      statut: row.statut,
      startingAt: row.startingAt ?? '',
      endingAt: row.endingAt ?? '',
    );
  }
}
