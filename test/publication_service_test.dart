import 'dart:convert';

import 'package:eamau/services/publication/publication_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final response = jsonEncode({
    'success': true,
    'data': [],
    'meta': {'page': 1, 'limit': 12, 'total': 0, 'pages': 1},
  });

  test('loads the default publication list without query parameters', () async {
    final service = PublicationService(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/publications');
        expect(request.url.query, isEmpty);
        return http.Response(response, 200);
      }),
    );

    await service.getPublicationsPage();
  });

  test('searches publications with POST and a JSON body', () async {
    final service = PublicationService(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/publications/search');
        expect(request.url.query, isEmpty);
        expect(jsonDecode(request.body), {
          'q': 'urbanisme',
          'page': '1',
          'limit': '12',
        });
        return http.Response(response, 200);
      }),
    );

    await service.searchPublications('urbanisme', limit: 12);
  });
}
