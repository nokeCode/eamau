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
    );
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
    return type.isNotEmpty ? type.toUpperCase() : '';
  }

  String get displayDate {
    if (publishedAt.isEmpty) {
      return '';
    }

    try {
      final parsed = DateTime.parse(publishedAt);
      return DateFormat('d MMM yyyy', 'fr_FR').format(parsed);
    } catch (_) {
      return publishedAt;
    }
  }
}
