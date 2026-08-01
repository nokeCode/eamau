import 'package:intl/intl.dart';

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
    return NewsMeta(
      page: int.tryParse('${json['page']}') ?? 1,
      perPage: int.tryParse('${json['perPage']}') ?? 10,
      total: int.tryParse('${json['total']}') ?? 0,
      lastPage: int.tryParse('${json['lastPage']}') ?? 1,
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
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: int.tryParse('${json['id']}') ?? 0,
      title: '${json['title'] ?? ''}',
      summary: '${json['summary'] ?? json['description'] ?? ''}',
      slug: '${json['slug'] ?? ''}',
      image: '${json['image'] ?? ''}',
      publishedAt: '${json['publishedAt'] ?? json['date'] ?? ''}',
      content: json['content']?.toString(),
      video: json['video']?.toString(),
      featured: json['featured'] == true,
      category: json['category'] != null
          ? NewsCategoryModel.fromJson(
              Map<String, dynamic>.from(json['category']),
            )
          : null,
    );
  }

  String get description => summary;

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
