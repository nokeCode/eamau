import 'dart:ffi';
import 'package:eamau/core/database/app_database.dart' as adb;
import 'package:eamau/data/local/registration_local_datasource.dart';
import 'package:eamau/data/remote/registration_remote_datasource.dart';
import 'package:eamau/data/repositories/registration_repository.dart';
import 'package:eamau/models/registration/registration_referential_model.dart';
import 'package:eamau/models/registration/registration_submit_outcome.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  try {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  } catch (_) {}

  const MethodChannel pathChannel = MethodChannel('plugins.flutter.io/path_provider');
  const MethodChannel storageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  const MethodChannel connectivityChannel = MethodChannel('dev.fluttercommunity.plus/connectivity');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    pathChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.test_documents';
      }
      return null;
    },
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    storageChannel,
    (MethodCall methodCall) async {
      return null;
    },
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    connectivityChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'check') {
        return 'none';
      }
      return null;
    },
  );

  setUp(() async {
    await adb.AppDatabase.init();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, null);
  });

  test('RegistrationRepository saves and retrieves draft locally', () async {
    final local = RegistrationLocalDatasource();
    final remote = RegistrationRemoteDatasource();
    final repo = RegistrationRepository(local: local, remote: remote);

    const draft = RegistrationDraft(
      firstName: 'Alice',
      lastName: 'Koffi',
      email: 'alice@eamau.tg',
      matricule: 'MAT888',
      alreadyRegistered: true,
      schoolYear: RegistrationOption(id: '5', label: '2026-2027', value: '2026-2027'),
    );

    final draftId = await repo.saveDraftLocally(draft: draft);
    expect(draftId, greaterThan(0));

    final fetched = await repo.getDraft(draftId);
    expect(fetched, isNotNull);
    expect(fetched!.localUuid, isNotEmpty);
    expect(fetched.status, 'draft');

    final outcome = await repo.submitDraft(draftId);
    expect(
      outcome,
      anyOf(
        equals(RegistrationSubmitOutcome.queuedOffline),
        equals(RegistrationSubmitOutcome.queuedAfterError),
      ),
    );
  });
}
