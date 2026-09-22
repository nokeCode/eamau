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

  test('RegistrationDraft preserves all local fields including semesters across serialization', () {
    const draft = RegistrationDraft(
      firstName: 'Germain',
      lastName: 'Kouassi',
      email: 'germain@eamau.tg',
      phone: '+22890000000',
      matricule: 'MAT1234',
      alreadyRegistered: true,
      schoolYear: RegistrationOption(id: '5', label: '2026-2027', value: '2026-2027'),
      filiere: RegistrationOption(id: '1', label: 'Architecture', value: 'Architecture'),
      grade: RegistrationOption(id: '2', label: 'Licence 2', value: 'Licence 2'),
      group: RegistrationOption(id: '3', label: 'Groupe A', value: 'Groupe A'),
      semesters: [
        RegistrationSemesterEntry(
          semester: RegistrationOption(id: '3', label: 'Semestre 3', value: 'Semestre 3'),
          status: RegistrationOption(id: '1', label: 'Validé', value: 'Validé'),
        ),
      ],
    );

    final localMap = draft.toLocalMap();
    final restored = RegistrationDraft.fromJson(localMap);

    expect(restored.firstName, 'Germain');
    expect(restored.lastName, 'Kouassi');
    expect(restored.email, 'germain@eamau.tg');
    expect(restored.matricule, 'MAT1234');
    expect(restored.alreadyRegistered, isTrue);
    expect(restored.schoolYear?.id, '5');
    expect(restored.filiere?.label, 'Architecture');
    expect(restored.grade?.label, 'Licence 2');
    expect(restored.group?.label, 'Groupe A');
    expect(restored.semesters, hasLength(1));
    expect(restored.semesters.first.semester?.label, 'Semestre 3');
    expect(restored.semesters.first.status?.label, 'Validé');

    final apiJson = draft.toApiJson();
    expect(apiJson['anneeScolaireId'], '5');
    expect(apiJson['filiereId'], '1');
    expect(apiJson['gradeId'], '2');
    expect(apiJson['groupeId'], '3');
    expect(apiJson['matricule'], 'MAT1234');
    expect(apiJson['oldStudent'], isTrue);
  });
}
