import 'package:eamau/models/notification/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationModel.fromJson', () {
    test('maps backend notification payload to UI model fields', () {
      final model = NotificationModel.fromJson({
        'id': 12,
        'title': 'Nouvelle publication',
        'body': 'Une nouvelle publication est disponible.',
        'type': 'PUBLICATION',
        'route': '/publications/123',
        'entityId': '123',
        'payload': {'source': 'fixtures'},
        'status': 'READ',
        'createdAt': '2026-08-04T10:00:00+00:00',
        'readAt': '2026-08-04T10:05:00+00:00',
        'sentAt': '2026-08-04T10:00:01+00:00',
      });

      expect(model.id, 12);
      expect(model.title, 'Nouvelle publication');
      expect(model.message, 'Une nouvelle publication est disponible.');
      expect(model.icon, 'document');
      expect(model.isRead, isTrue);
      expect(model.createdAt, DateTime.parse('2026-08-04T10:00:00+00:00'));
    });
  });
}
