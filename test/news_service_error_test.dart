import 'dart:convert';

import 'package:eamau/services/news/news_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'surfaces backend message when news endpoint returns an error',
    () async {
      final service = NewsService(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({
              'success': false,
              'message': 'Une erreur interne est survenue.',
            }),
            500,
          );
        }),
      );

      await expectLater(
        service.getNewsPage(),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('Une erreur interne est survenue.'),
          ),
        ),
      );
    },
  );
}
