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

    test('parses scientific publication fields and formats citations', () {
      final json = {
        'id': 42,
        'title': 'Modélisation du confort thermique dans les habitats vernaculaires en Afrique de l\'Ouest',
        'summary': 'Cette étude analyse les propriétés thermiques des matériaux locaux dans l\'architecture sahélienne.',
        'slug': 'modelisation-confort-thermique-habitat-afrique-ouest',
        'publishedAt': '2024-06-15T00:00:00Z',
        'authors': ['Dr. Koffi Mensah', 'Prof. Amadou Diallo'],
        'affiliation': 'EAMAU - Département d\'Architecture et Développement Durable',
        'journal': 'Revue Africaine d\'Architecture et d\'Urbanisme',
        'volume': '18',
        'issue': '2',
        'pages': '45-62',
        'doi': '10.1234/eamau.2024.18.2.45',
        'pdfUrl': 'uploads/publications/confort_thermique.pdf',
        'keywords': ['Confort thermique', 'Habitat vernaculaire', 'Matériaux locaux', 'Sahel'],
        'peer_reviewed': true,
        'language': 'Français',
        'type': 'Article de recherche',
      };

      final pub = NewsModel.fromJson(json);

      expect(pub.id, 42);
      expect(pub.authors.length, 2);
      expect(pub.formattedAuthors, 'Dr. Koffi Mensah, Prof. Amadou Diallo');
      expect(pub.affiliation, 'EAMAU - Département d\'Architecture et Développement Durable');
      expect(pub.journal, 'Revue Africaine d\'Architecture et d\'Urbanisme');
      expect(pub.volume, '18');
      expect(pub.issue, '2');
      expect(pub.pages, '45-62');
      expect(pub.hasDoi, true);
      expect(pub.cleanDoi, '10.1234/eamau.2024.18.2.45');
      expect(pub.hasPdf, true);
      expect(pub.keywords, contains('Confort thermique'));
      expect(pub.peerReviewed, true);
      expect(pub.publicationYear, '2024');

      // Citations
      expect(pub.apaCitation, contains('Dr. Koffi Mensah, Prof. Amadou Diallo (2024).'));
      expect(pub.apaCitation, contains('https://doi.org/10.1234/eamau.2024.18.2.45'));
      expect(pub.bibtexCitation, contains('@article{eamau_42_2024'));
      expect(pub.bibtexCitation, contains('author = {Dr. Koffi Mensah and Prof. Amadou Diallo}'));
      expect(pub.ieeeCitation, contains('vol. 18, no. 2, pp. 45-62, 2024'));
    });
  });
}
