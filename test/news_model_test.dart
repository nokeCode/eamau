import 'package:eamau/core/api/api_config.dart';
import 'package:eamau/models/news/news_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewsModel parsing', () {
    test('parses API payload fields for list and detail responses', () {
      final json = {
        'id': '12',
        'title': 'Titre de l’actualité',
        'summary': 'Résumé limité à 200 caractères',
        'slug': 'titre-de-l-actualite',
        'image': 'http://example.com/image.jpg',
        'publishedAt': '2026-07-30T10:00:00+00:00',
        'content': '<p>Contenu HTML</p>',
        'video': 'http://example.com/video.mp4',
        'category': {'id': '2', 'name': 'Évènements'},
      };

      final article = NewsModel.fromJson(json);

      expect(article.id, 12);
      expect(article.title, 'Titre de l’actualité');
      expect(article.summary, 'Résumé limité à 200 caractères');
      expect(article.slug, 'titre-de-l-actualite');
      expect(article.image, 'http://example.com/image.jpg');
      expect(article.publishedAt, '2026-07-30T10:00:00+00:00');
      expect(article.content, '<p>Contenu HTML</p>');
      expect(article.video, 'http://example.com/video.mp4');
      expect(article.category?.id, 2);
      expect(article.category?.name, 'Évènements');
    });

    test('parses pagination metadata from API envelope', () {
      final meta = NewsMeta.fromJson({
        'page': 1,
        'perPage': 10,
        'total': 34,
        'lastPage': 4,
      });

      expect(meta.page, 1);
      expect(meta.perPage, 10);
      expect(meta.total, 34);
      expect(meta.lastPage, 4);
    });

    test('resolves relative media paths for news and publications', () {
      final article = NewsModel.fromJson({
        'id': 1,
        'title': 'Actualité',
        'image': 'uploads/news/image.jpg',
      });
      final publication = NewsModel.fromJson({
        'id': 2,
        'title': 'Publication',
        'files': [
          {
            'fileName': 'couverture.jpg',
            'mimeType': 'image/jpeg',
          },
        ],
      });

      expect(article.image, ApiConfig.imageUrl('uploads/news/image.jpg'));
      expect(
        publication.image,
        ApiConfig.imageUrl('uploads/couverture.jpg'),
      );
    });
  });
}
