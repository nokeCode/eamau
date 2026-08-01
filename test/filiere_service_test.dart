import 'dart:convert';

import 'package:eamau/models/filiere/filiere_model.dart';
import 'package:eamau/services/filiere/filiere_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('Filiere API parsing', () {
    test('parses list payload from filiere API', () {
      final json = {
        'id': 1,
        'name': 'Architecture',
        'slug': 'architecture',
        'image': 'http://example.com/image.jpg',
        'description': 'Description de la filière',
        'parcoursCount': 2,
      };

      final filiere = Filiere.fromJson(json);

      expect(filiere.id, 1);
      expect(filiere.nom, 'Architecture');
      expect(filiere.slug, 'architecture');
      expect(filiere.image, 'http://example.com/image.jpg');
      expect(filiere.description, 'Description de la filière');
      expect(filiere.parcoursCount, 2);
    });

    test('loads paginated filiere list from API envelope', () async {
      final service = FiliereService(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': [
                {
                  'id': 1,
                  'name': 'Architecture',
                  'slug': 'architecture',
                  'image': 'http://example.com/image.jpg',
                  'description': 'Description de la filière',
                  'parcoursCount': 2,
                }
              ],
              'meta': {'page': 1, 'perPage': 10, 'total': 1, 'lastPage': 1},
            }),
            200,
          );
        }),
      );

      final result = await service.getFilieresPage(page: 1, perPage: 10);

      expect(result.items.length, 1);
      expect(result.meta.lastPage, 1);
      expect(result.items.first.slug, 'architecture');
    });
  });
}
