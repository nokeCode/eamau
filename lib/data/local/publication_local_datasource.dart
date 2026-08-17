import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../models/news/news_model.dart';
import '../../core/database/app_database.dart';

/// Local datasource for publications (Drift-backed)
class PublicationLocalDatasource {
  final AppDatabase _db = AppDatabase();

  Future<List<NewsModel>> getAllPublications() async {
    final List<Publication> rows = await _db.select(_db.publications).get();
    return rows.map(_rowToModel).toList();
  }

  Future<void> savePublications(List<NewsModel> items) async {
    final db = AppDatabase();
    for (final n in items) {
      try {
        Publication? existing;
        if (n.id != 0) {
          existing = await (db.select(db.publications)..where((t) => t.remoteId.equals(n.id))).getSingleOrNull();
        }

        if (existing == null && n.slug.isNotEmpty) {
          existing = await (db.select(db.publications)..where((t) => t.slug.equals(n.slug))).getSingleOrNull();
        }

        final now = DateTime.now();
        if (existing != null) {
          final existingId = existing.id;
          await (db.update(db.publications)..where((t) => t.id.equals(existingId))).write(
            PublicationsCompanion(
              remoteId: Value(n.id),
              title: Value(n.title),
              slug: Value(n.slug),
              summary: Value(n.summary),
              content: Value(n.content),
              image: Value(n.image),
              publishedAt: Value(_parseDateTime(n.publishedAt)),
              featured: Value(n.featured),
              updatedAt: Value(now),
            ),
          );
          debugPrint('[PUBLICATIONS] Détail mis à jour dans SQLite : ${n.slug}');
        } else {
          final companion = PublicationsCompanion(
            remoteId: Value(n.id),
            title: Value(n.title),
            slug: Value(n.slug),
            summary: Value(n.summary),
            content: Value(n.content),
            image: Value(n.image),
            publishedAt: Value(_parseDateTime(n.publishedAt)),
            featured: Value(n.featured),
            createdAt: Value(now),
            updatedAt: Value(now),
          );
          await db.into(db.publications).insert(companion);
          debugPrint('[PUBLICATIONS] Nouvel item inséré dans SQLite : ${n.slug}');
        }
      } catch (e) {
        debugPrint('[PUBLICATIONS] Erreur lors de savePublications pour ${n.slug}: $e');
      }
    }
  }

  Future<NewsModel?> getPublicationDetail(String slug) async {
    final row = await (_db.select(_db.publications)..where((t) => t.slug.equals(slug))).getSingleOrNull();
    return row == null ? null : _rowToModel(row);
  }

  Future<void> deletePublicationsNotIn(List<int> remoteIds) async {
    final db = AppDatabase();
    try {
      if (remoteIds.isEmpty) {
        await (db.delete(db.publications)..where((t) => t.remoteId.isNotNull())).go();
        debugPrint('[PUBLICATIONS] Suppression locale: aucune remoteId trouvé sur le serveur');
        return;
      }

      await (db.delete(db.publications)..where((t) => t.remoteId.isNotIn(remoteIds) & t.remoteId.isNotNull())).go();
      debugPrint('[PUBLICATIONS] Suppression locale: items absents du serveur supprimés');
    } catch (e) {
      debugPrint('[PUBLICATIONS] Erreur lors de deletePublicationsNotIn: $e');
    }
  }

  NewsModel _rowToModel(Publication row) {
    return NewsModel(
      id: row.remoteId ?? row.id,
      title: row.title,
      summary: row.summary ?? '',
      slug: row.slug,
      image: row.image ?? '',
      publishedAt: row.publishedAt?.toIso8601String() ?? '',
      content: row.content,
      featured: row.featured,
      category: null,
      type: '',
      categoryName: '',
    );
  }

  DateTime? _parseDateTime(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }
}
