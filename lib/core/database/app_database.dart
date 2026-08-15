import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Drift table definitions
class News extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get title => text().withLength(min: 0, max: 512)();
  TextColumn get slug => text().withLength(min: 0, max: 256)();
  TextColumn get summary => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get image => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  BoolColumn get featured => boolean().withDefault(const Constant(false))();
  IntColumn get categoryId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class Filiere extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get nom => text().withLength(min: 0, max: 256)();
  TextColumn get slug => text().withLength(min: 0, max: 256)();
  TextColumn get niveau => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
  IntColumn get parcoursCount => integer().withDefault(const Constant(0))();
}

class Parcours extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get filiereId => integer().references(Filiere, #id)();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get nom => text().withLength(min: 0, max: 256)();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
}

class AppNotifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get title => text()();
  TextColumn get message => text().nullable()();
  TextColumn get icon => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class AdmissionDrafts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localUuid => text().withLength(min: 1, max: 64)();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get dataJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftId => integer().nullable().references(AdmissionDrafts, #id)();
  TextColumn get localPath => text()();
  TextColumn get fileName => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get size => integer().nullable()();
  TextColumn get uploadStatus => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

class SyncOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientOperationId => text().withLength(min: 1, max: 64)();
  TextColumn get type => text()();
  TextColumn get payload => text()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [News, Filiere, Parcours, AppNotifications, AdmissionDrafts, Documents, SyncOperations])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(QueryExecutor e) : super(e);

  static AppDatabase? _instance;

  factory AppDatabase() => _instance ?? (throw StateError('Call AppDatabase.init() first'));

  static Future<void> init() async {
    if (_instance != null) return;
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'eamau.sqlite'));
    final executor = NativeDatabase(file);
    _instance = AppDatabase._(executor);
  }

  @override
  int get schemaVersion => 1;
}

