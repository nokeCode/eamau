import 'package:eamau/core/database/app_database.dart';
import 'package:eamau/providers/admission_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.test_documents';
      }
      return null;
    },
  );

  setUp(() async {
    await AppDatabase.init();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('AdmissionProvider saves a draft locally and exposes it in memory', () async {
    final provider = AdmissionProvider();

    final draftId = await provider.saveDraft({
      'firstName': 'Marie',
      'lastName': 'Dupont',
      'email': 'marie@example.com',
      'requestedLevel': 'Licence 1',
    });

    expect(draftId, greaterThan(0));
    expect(provider.drafts, isNotEmpty);
    expect(provider.status, AdmissionFlowStatus.idle);
  });
}
