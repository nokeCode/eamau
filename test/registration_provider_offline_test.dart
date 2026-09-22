import 'dart:ffi';

import 'package:eamau/core/database/app_database.dart';
import 'package:eamau/models/registration/registration_referential_model.dart';
import 'package:eamau/models/registration/registration_submit_outcome.dart';
import 'package:eamau/providers/registration/registration_provider.dart';
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
    await AppDatabase.init();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, null);
  });

  test('RegistrationProvider loads referentials offline and submits locally', () async {
    final provider = RegistrationProvider();

    await provider.loadReferentials();
    expect(provider.referentials, isNotNull);
    expect(provider.referentials!.documentTypes, isNotEmpty);

    provider.updateField('firstName', 'Jean');
    provider.updateField('lastName', 'Kouassi');
    provider.updateField('email', 'jean@eamau.tg');
    provider.updateField('matricule', 'MAT999');
    provider.toggleAlreadyRegistered(true);

    final outcome = await provider.submitRegistration();
    expect(
      outcome,
      anyOf(
        equals(RegistrationSubmitOutcome.queuedOffline),
        equals(RegistrationSubmitOutcome.queuedAfterError),
      ),
    );
    expect(provider.localDraftId, isNotNull);
    expect(provider.localDraftId!, greaterThan(0));

    // Test resuming draft
    final newProvider = RegistrationProvider();
    await newProvider.resumeDraft(provider.localDraftId!);
    expect(newProvider.draft.firstName, 'Jean');
    expect(newProvider.draft.lastName, 'Kouassi');
    expect(newProvider.draft.email, 'jean@eamau.tg');
    expect(newProvider.draft.matricule, 'MAT999');
    expect(newProvider.draft.alreadyRegistered, isTrue);
  });
}
