import 'package:intl/intl.dart';

import '../../core/api/api_config.dart';
import 'news_category_model.dart';

class NewsMeta {
  final int page;
  final int perPage;
  final int total;
  final int lastPage;

  const NewsMeta({
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory NewsMeta.fromJson(Map<String, dynamic> json) {
    final pageValue = json['page'] ?? json['currentPage'] ?? json['current_page'];
    final perPageValue = json['perPage'] ?? json['limit'];
    final lastPageValue = json['lastPage'] ?? json['pages'] ?? json['last_page'];

    return NewsMeta(
      page: int.tryParse('$pageValue') ?? 1,
      perPage: int.tryParse('$perPageValue') ?? 10,
      total: int.tryParse('${json['total']}') ?? 0,
      lastPage: int.tryParse('$lastPageValue') ?? 1,
    );
  }
}

class NewsModel {
  final int id;
  final String title;
  final String summary;
  final String slug;
  final String image;
  final String publishedAt;
  final String? content;
  final String? video;
  final bool featured;
  final NewsCategoryModel? category;
  final String type;
  final String categoryName;
  final List<String> authors;
  final String affiliation;
  final String journal;
  final String doi;
  final String isbn;
  final String issn;
  final String pdfUrl;
  final String documentSize;
  final List<String> keywords;
  final String volume;
  final String issue;
  final String pages;
  final String language;
  final bool peerReviewed;
  final int? citationsCount;
  final int? downloadsCount;
  final int? viewsCount;

  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.slug,
    required this.image,
    required this.publishedAt,
    this.content,
    this.video,
    this.featured = false,
    this.category,
    this.type = '',
    this.categoryName = '',
    this.authors = const [],
    this.affiliation = '',
    this.journal = '',
    this.doi = '',
    this.isbn = '',
    this.issn = '',
    this.pdfUrl = '',
    this.documentSize = '',
    this.keywords = const [],
    this.volume = '',
    this.issue = '',
    this.pages = '',
    this.language = 'Français',
    this.peerReviewed = false,
    this.citationsCount,
    this.downloadsCount,
    this.viewsCount,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'];
    String typeText = '';

    if (typeValue is Map<String, dynamic>) {
      typeText = typeValue['name']?.toString() ?? typeValue['code']?.toString() ?? '';
    } else if (typeValue != null) {
      typeText = typeValue.toString();
    }

    final categoryValue = json['category'];
    NewsCategoryModel? category;
    String categoryName = '';

    if (categoryValue is Map<String, dynamic>) {
      category = NewsCategoryModel.fromJson(Map<String, dynamic>.from(categoryValue));
      categoryName = category.name;
    } else if (categoryValue is String) {
      categoryName = categoryValue;
    }

    return NewsModel(
      id: int.tryParse('${json['id']}') ?? 0,
      title: '${json['title'] ?? ''}',
      summary: '${json['summary'] ?? json['abstract'] ?? json['description'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      // Les deux API utilisent plusieurs formats selon le type de contenu :
      // `image` peut être une URL, un objet média, ou l'image peut se trouver
      // dans `media` / `files`. Toujours convertir un chemin relatif en URL
      // absolue afin que Image.network puisse l'afficher dans les cartes et
      // le carrousel.
      image: _resolveImageUrl(json),
      publishedAt: '${json['publishedAt'] ?? json['publicationDate'] ?? json['date'] ?? ''}',
      content: json['content']?.toString(),
      video: json['video']?.toString(),
      featured: json['featured'] == true || json['featured'] == 1,
      category: category,
      type: typeText.isNotEmpty
          ? typeText
          : json['publication_type']?.toString() ?? '',
      categoryName: categoryName.isNotEmpty
          ? categoryName
          : json['category_name']?.toString() ?? json['categoryName']?.toString() ?? '',
      authors: _parseAuthors(json),
      affiliation: json['affiliation']?.toString() ??
          json['institution']?.toString() ??
          json['lab']?.toString() ??
          json['laboratoire']?.toString() ??
          json['departement']?.toString() ??
          json['department']?.toString() ??
          '',
      journal: json['journal']?.toString() ??
          json['revue']?.toString() ??
          json['publisher']?.toString() ??
          json['editeur']?.toString() ??
          json['conference']?.toString() ??
          json['source']?.toString() ??
          '',
      doi: json['doi']?.toString() ?? json['DOI']?.toString() ?? '',
      isbn: json['isbn']?.toString() ?? json['ISBN']?.toString() ?? '',
      issn: json['issn']?.toString() ?? json['ISSN']?.toString() ?? '',
      pdfUrl: _resolvePdfUrl(json),
      documentSize: json['file_size']?.toString() ??
          json['fileSize']?.toString() ??
          json['size']?.toString() ??
          '',
      keywords: _parseKeywords(json),
      volume: json['volume']?.toString() ?? json['vol']?.toString() ?? '',
      issue: json['issue']?.toString() ?? json['numero']?.toString() ?? json['num']?.toString() ?? '',
      pages: json['pages']?.toString() ??
          json['page_count']?.toString() ??
          json['pageRange']?.toString() ??
          json['page_range']?.toString() ??
          '',
      language: json['language']?.toString() ??
          json['langue']?.toString() ??
          json['lang']?.toString() ??
          'Français',
      peerReviewed: json['peer_reviewed'] == true ||
          json['peerReviewed'] == true ||
          json['is_peer_reviewed'] == true ||
          json['comite_lecture'] == true ||
          json['valide'] == true,
      citationsCount: int.tryParse(
          '${json['citationsCount'] ?? json['citations_count'] ?? json['citations'] ?? ''}'),
      downloadsCount: int.tryParse(
          '${json['downloadsCount'] ?? json['downloads_count'] ?? json['downloads'] ?? ''}'),
      viewsCount: int.tryParse(
          '${json['viewsCount'] ?? json['views_count'] ?? json['views'] ?? ''}'),
    );
  }

  static List<String> _parseAuthors(Map<String, dynamic> json) {
    final raw = json['authors'] ??
        json['author'] ??
        json['auteurs'] ??
        json['auteur'] ??
        json['researchers'] ??
        json['chercheurs'] ??
        json['contributors'];

    if (raw == null) {
      return const [];
    }

    if (raw is List) {
      final list = <String>[];
      for (final item in raw) {
        if (item is String) {
          final trimmed = item.trim();
          if (trimmed.isNotEmpty) list.add(trimmed);
        } else if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          final fullName = map['name'] ??
              map['nom'] ??
              map['fullName'] ??
              map['full_name'] ??
              '${map['firstName'] ?? map['first_name'] ?? ''} ${map['lastName'] ?? map['last_name'] ?? ''}'
                  .trim();
          if (fullName.isNotEmpty) {
            list.add(fullName.toString().trim());
          }
        }
      }
      return list;
    }

    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) return const [];
      if (trimmed.contains(';') || trimmed.contains(',')) {
        final separator = trimmed.contains(';') ? ';' : ',';
        return trimmed
            .split(separator)
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [trimmed];
    }

    return const [];
  }

  static List<String> _parseKeywords(Map<String, dynamic> json) {
    final raw = json['keywords'] ??
        json['mots_cles'] ??
        json['motsCles'] ??
        json['tags'] ??
        json['thematiques'];

    if (raw == null) {
      return const [];
    }

    if (raw is List) {
      return raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) return const [];
      final separator = trimmed.contains(';')
          ? ';'
          : (trimmed.contains(',') ? ',' : ' ');
      return trimmed
          .split(separator)
          .map((e) => e.trim().replaceAll(RegExp(r'^#'), ''))
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return const [];
  }

  static String _resolvePdfUrl(Map<String, dynamic> json) {
    final directPdf = _pdfPathFromValue(
      json['pdf'] ??
          json['pdfUrl'] ??
          json['pdf_url'] ??
          json['document'] ??
          json['documentUrl'] ??
          json['document_url'] ??
          json['file'] ??
          json['fileUrl'] ??
          json['file_url'] ??
          json['downloadUrl'] ??
          json['download_url'],
    );
    if (directPdf.isNotEmpty) {
      return ApiConfig.imageUrl(directPdf);
    }

    for (final key in ['files', 'media', 'documents', 'attachments']) {
      final values = json[key];
      if (values is! List) {
        continue;
      }

      for (final value in values) {
        if (value is! Map) {
          continue;
        }
        final item = Map<String, dynamic>.from(value);
        final mimeType = item['mimeType']?.toString().toLowerCase() ??
            item['mime_type']?.toString().toLowerCase() ??
            '';
        final fileName = item['fileName']?.toString().toLowerCase() ??
            item['file_name']?.toString().toLowerCase() ??
            item['url']?.toString().toLowerCase() ??
            '';
        if (mimeType.contains('pdf') || fileName.endsWith('.pdf')) {
          final pdfPath = _pdfPathFromValue(item);
          if (pdfPath.isNotEmpty) {
            return ApiConfig.imageUrl(pdfPath);
          }
        }
      }
    }

    return '';
  }

  static String _pdfPathFromValue(dynamic value) {
    if (value is String) {
      return value.trim();
    }
    if (value is! Map) {
      return '';
    }

    final map = Map<String, dynamic>.from(value);
    for (final key in [
      'url',
      'path',
      'fileUrl',
      'file_url',
      'pdfUrl',
      'pdf_url',
      'downloadUrl',
      'download_url',
    ]) {
      final path = map[key]?.toString().trim() ?? '';
      if (path.isNotEmpty) {
        return path;
      }
    }

    final fileName = map['fileName']?.toString().trim() ??
        map['file_name']?.toString().trim() ??
        '';
    if (fileName.isEmpty) {
      return '';
    }

    return fileName.contains('/') ? fileName : 'uploads/$fileName';
  }

  static String _resolveImageUrl(Map<String, dynamic> json) {
    final directImage = _imagePathFromValue(
      json['image'] ??
          json['imageUrl'] ??
          json['image_url'] ??
          json['thumbnail'] ??
          json['coverImage'] ??
          json['cover_image'],
    );
    if (directImage.isNotEmpty) {
      return ApiConfig.imageUrl(directImage);
    }

    for (final key in ['media', 'files']) {
      final values = json[key];
      if (values is! List) {
        continue;
      }

      for (final value in values) {
        if (value is! Map) {
          continue;
        }
        final media = Map<String, dynamic>.from(value);
        final mimeType = media['mimeType']?.toString() ??
            media['mime_type']?.toString() ??
            '';
        if (mimeType.isNotEmpty && !mimeType.startsWith('image/')) {
          continue;
        }

        final imagePath = _imagePathFromValue(media);
        if (imagePath.isNotEmpty) {
          return ApiConfig.imageUrl(imagePath);
        }
      }
    }

    return '';
  }

  static String _imagePathFromValue(dynamic value) {
    if (value is String) {
      return value.trim();
    }
    if (value is! Map) {
      return '';
    }

    final map = Map<String, dynamic>.from(value);
    for (final key in [
      'url',
      'path',
      'fileUrl',
      'file_url',
      'imageUrl',
      'image_url',
    ]) {
      final path = map[key]?.toString().trim() ?? '';
      if (path.isNotEmpty) {
        return path;
      }
    }

    final fileName = map['fileName']?.toString().trim() ??
        map['file_name']?.toString().trim() ??
        '';
    if (fileName.isEmpty) {
      return '';
    }

    // Les fichiers téléversés qui ne contiennent que leur nom sont exposés
    // par le serveur dans le dossier public `uploads`.
    return fileName.contains('/') ? fileName : 'uploads/$fileName';
  }

  String get description => summary;

  String get categoryLabel {
    final name = category?.name.isNotEmpty == true
        ? category!.name
        : categoryName;
    return name.isNotEmpty ? name.toUpperCase() : 'ACTUALITÉ';
  }

  String get displayType {
    if (type.isNotEmpty) return type.toUpperCase();
    return 'ARTICLE SCIENTIFIQUE';
  }

  String get formattedAuthors {
    if (authors.isNotEmpty) {
      return authors.join(', ');
    }
    return '';
  }

  bool get hasPdf => pdfUrl.isNotEmpty;

  bool get hasDoi => doi.trim().isNotEmpty;

  String get cleanDoi {
    return doi.replaceAll(RegExp(r'^https?://(dx\.)?doi\.org/'), '').trim();
  }

  String get doiUrl {
    if (doi.isEmpty) return '';
    if (doi.startsWith('http://') || doi.startsWith('https://')) {
      return doi;
    }
    return 'https://doi.org/$cleanDoi';
  }

  String get publicationYear {
    if (publishedAt.isNotEmpty) {
      try {
        final parsed = DateTime.parse(publishedAt);
        return '${parsed.year}';
      } catch (_) {
        final match = RegExp(r'\b(19|20)\d{2}\b').firstMatch(publishedAt);
        if (match != null) return match.group(0)!;
      }
    }
    return '${DateTime.now().year}';
  }

  String get displayDate {
    if (publishedAt.isEmpty) {
      return '';
    }

    try {
      final parsed = DateTime.parse(publishedAt);
      return DateFormat('d MMMM yyyy', 'fr_FR').format(parsed);
    } catch (_) {
      return publishedAt;
    }
  }

  /// Format citation: APA 7th Edition
  String get apaCitation {
    final authorStr = formattedAuthors.isNotEmpty ? formattedAuthors : 'EAMAU Recherche';
    final journalStr = journal.isNotEmpty ? journal : "Revue Scientifique de l'EAMAU";
    final volStr = volume.isNotEmpty ? ', $volume' : '';
    final issStr = issue.isNotEmpty ? '($issue)' : '';
    final pgStr = pages.isNotEmpty ? ', $pages' : '';
    final doiStr = hasDoi ? ' https://doi.org/$cleanDoi' : '';
    return '$authorStr ($publicationYear). $title. $journalStr$volStr$issStr$pgStr.$doiStr';
  }

  /// Format citation: BibTeX
  String get bibtexCitation {
    final key = 'eamau_${id != 0 ? id : slug.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_$publicationYear';
    final authorStr = authors.isNotEmpty ? authors.join(' and ') : 'EAMAU';
    final journalStr = journal.isNotEmpty ? journal : "Revue Scientifique de l'EAMAU";
    return '''@article{$key,
  title = {$title},
  author = {$authorStr},
  journal = {$journalStr},
  year = {$publicationYear}${volume.isNotEmpty ? ',\n  volume = {$volume}' : ''}${issue.isNotEmpty ? ',\n  number = {$issue}' : ''}${pages.isNotEmpty ? ',\n  pages = {$pages}' : ''}${hasDoi ? ',\n  doi = {$cleanDoi}' : ''}
}''';
  }

  /// Format citation: IEEE
  String get ieeeCitation {
    final authorStr = formattedAuthors.isNotEmpty ? formattedAuthors : 'EAMAU';
    final journalStr = journal.isNotEmpty ? journal : "Revue Scientifique de l'EAMAU";
    final volStr = volume.isNotEmpty ? 'vol. $volume, ' : '';
    final issStr = issue.isNotEmpty ? 'no. $issue, ' : '';
    final pgStr = pages.isNotEmpty ? 'pp. $pages, ' : '';
    final doiStr = hasDoi ? ', doi: $cleanDoi' : '';
    return '$authorStr, "$title," $journalStr, $volStr$issStr$pgStr$publicationYear$doiStr.';
  }

  /// Format citation: Chicago 17th Edition
  String get chicagoCitation {
    final authorStr = formattedAuthors.isNotEmpty ? formattedAuthors : 'EAMAU';
    final journalStr = journal.isNotEmpty ? journal : "Revue Scientifique de l'EAMAU";
    final volStr = volume.isNotEmpty ? ' $volume' : '';
    final issStr = issue.isNotEmpty ? ', no. $issue' : '';
    final pgStr = pages.isNotEmpty ? ': $pages' : '';
    return '$authorStr. "$title." $journalStr$volStr$issStr ($publicationYear)$pgStr.';
  }
}
