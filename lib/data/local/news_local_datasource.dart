import 'package:drift/drift.dart';
import '../../models/news/news_model.dart';
import '../../core/database/app_database.dart';

/// Local datasource for news (Drift-backed)
class NewsLocalDatasource {
  final AppDatabase _db = AppDatabase();

  Future<List<NewsModel>> getAllNews() async {
    final rows = await _db.select(_db.news).get();
    return rows.map(_rowToModel).toList();
  }

  Future<void> saveNews(List<NewsModel> news) async {
    final batch = _db.batch();
    for (final n in news) {
      final companion = NewsCompanion(
        remoteId: Value(n.id),
        title: Value(n.title),
        slug: Value(n.slug),
        summary: Value(n.summary),
        content: Value(n.content),
        image: Value(n.image),
        publishedAt: Value(_parseDateTime(n.publishedAt)),
        featured: Value(n.featured),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );
      batch.insertOnConflictUpdate(_db.news, companion);
    }
    await batch.commit(noResult: true);
  }

  Future<NewsModel?> getNewsDetail(String slug) async {
    final row = await (_db.select(_db.news)..where((t) => t.slug.equals(slug))).getSingleOrNull();
    return row == null ? null : _rowToModel(row);
  }

  NewsModel _rowToModel(New row) {
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

