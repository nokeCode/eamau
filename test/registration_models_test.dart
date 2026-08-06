import 'package:eamau/models/registration/registration_referential_model.dart';
import 'package:eamau/models/registration/registration_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RegistrationReferentialCollection parses API payload', () {
    final payload = {
      'data': {
        'schoolYears': [
          {'id': 1, 'label': '2024-2025'},
        ],
        'statuses': [
          {'id': 2, 'label': 'Nouveau'},
        ],
        'filieres': [
          {'id': 3, 'label': 'Informatique'},
        ],
        'grades': [
          {'id': 4, 'label': 'Licence'},
        ],
        'groups': [
          {'id': 5, 'label': 'G1'},
        ],
        'semesters': [
          {'id': 6, 'label': 'Semestre 1'},
        ],
        'documentTypes': [
          {'id': 7, 'label': 'CNI'},
        ],
      },
    };

    final collection = RegistrationReferentialCollection.fromJson(payload);

    expect(collection.schoolYears, hasLength(1));
    expect(collection.schoolYears.first.label, '2024-2025');
    expect(collection.documentTypes.first.label, 'CNI');
  });

  test('RegistrationOption creates a fallback label from map', () {
    final option = RegistrationOption.fromJson({
      'value': 'ABC',
      'title': 'Option',
    });

    expect(option.label, 'Option');
  });

  test('RegistrationStatus parses API payload', () {
    final payload = {
      'data': {
        'open': true,
        'canCreate': true,
        'activeSchoolYear': {'id': 3, 'label': '2026-2027'},
        'message': 'Les demandes d’inscriptions sont ouvertes.',
      },
    };

    final status = RegistrationStatus.fromJson(payload['data']);

    expect(status.open, isTrue);
    expect(status.canCreate, isTrue);
    expect(status.activeSchoolYear?.label, '2026-2027');
    expect(status.message, 'Les demandes d’inscriptions sont ouvertes.');
  });

  test('RegistrationOption uses name from API payload as label', () {
    final option = RegistrationOption.fromJson({
      'id': 1,
      'name': 'Certificat Médical',
      'required': false,
      'type': 'administratif',
    });

    expect(option.id, '1');
    expect(option.label, 'Certificat Médical');
    expect(option.value, 'Certificat Médical');
  });
}
