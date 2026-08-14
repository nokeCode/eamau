import 'dart:convert';

import 'package:eamau/services/concours/suivi_candidature_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads tracking data from the API envelope', () async {
    final service = SuiviCandidatureService(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/postulations/EAMAUTG015CI/tracking');
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'reference': 'EAMAUTG015CI',
              'status': 'Verification',
              'candidateFullName': 'Jean Dupont',
              'program': 'Architecture',
              'examDate': '2026-09-10T00:00:00+00:00',
              'submittedAt': '2026-08-05T14:30:00+00:00',
              'timeline': [
                {
                  'label': 'Pré-inscription',
                  'date': '2026-08-01T10:15:00+00:00',
                },
              ],
            },
            'meta': [],
          }),
          200,
        );
      }),
    );

    final suivi = await service.getSuivi('EAMAUTG015CI');

    expect(suivi.reference, 'EAMAUTG015CI');
    expect(suivi.nomComplet, 'Jean Dupont');
    expect(suivi.programme, 'Architecture');
    expect(suivi.dateExamen, '2026-09-10T00:00:00+00:00');
    expect(suivi.statutActuel, 'Dossier en vérification');
    expect(suivi.etapes, hasLength(1));
    expect(suivi.etapes.single.completed, isTrue);
  });

  test('throws the API message rather than returning fallback data', () async {
    final service = SuiviCandidatureService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'Candidature introuvable.'}),
          404,
        ),
      ),
    );

    await expectLater(
      service.getSuivi('INCONNUE'),
      throwsA(
        isA<Exception>().having(
          (error) => error.toString(),
          'message',
          contains('Candidature introuvable.'),
        ),
      ),
    );
  });
}
