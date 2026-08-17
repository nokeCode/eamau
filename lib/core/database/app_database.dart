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

class Publications extends Table {
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

class Concours extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get titre => text().withLength(min: 0, max: 512)();
  TextColumn get slug => text().withLength(min: 0, max: 256)();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
  TextColumn get statut => text().withDefault(const Constant('Ouvert'))();
  TextColumn get startingAt => text().nullable()();
  TextColumn get endingAt => text().nullable()();
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

class AdmissionForms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dataJson => text()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class AdmissionCampaigns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get dataJson => text()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class RegistrationDrafts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localUuid => text().withLength(min: 1, max: 64)();
  IntColumn get remoteId => integer().nullable()();
  TextColumn get dataJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class RegistrationDocuments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftId => integer().nullable().references(RegistrationDrafts, #id)();
  TextColumn get localPath => text()();
  TextColumn get fileName => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get size => integer().nullable()();
  TextColumn get uploadStatus => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

class PostulationDrafts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localUuid => text().withLength(min: 1, max: 64)();
  TextColumn get remoteId => text().nullable()();
  TextColumn get reference => text().nullable()();
  TextColumn get concoursSlug => text().withLength(min: 0, max: 256)();
  TextColumn get dataJson => text()();
  TextColumn get postulationToken => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class PostulationDocuments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get draftId => integer().nullable().references(PostulationDrafts, #id)();
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

@DriftDatabase(
    tables: [
    News,
    Publications,
  Concours,
    Filiere,
    Parcours,
    AppNotifications,
    AdmissionDrafts,
    Documents,
    RegistrationDrafts,
    RegistrationDocuments,
    PostulationDrafts,
    PostulationDocuments,
    SyncOperations,
    AdmissionForms,
    AdmissionCampaigns,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

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
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Create Publications table when upgrading from schemaVersion 1 -> 2
            await m.createTable(publications);
          }
            if (from < 3) {
            // Create Concours table when upgrading to schemaVersion 3
            await m.createTable(concours);
          }
            if (from < 4) {
              // Create Postulation tables when upgrading to schemaVersion 4
              await m.createTable(postulationDrafts);
              await m.createTable(postulationDocuments);
            }
            if (from < 5) {
              // Create AdmissionForms and AdmissionCampaigns tables when upgrading to schemaVersion 5
              await m.createTable(admissionForms);
              await m.createTable(admissionCampaigns);
            }
        },
      );

    @override
    int get schemaVersion => 5;
}

