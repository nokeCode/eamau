import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/news/news_model.dart';
import '../../services/news/news_service.dart';
import '../widgets/newDetail/news_category_badge.dart';
import '../widgets/newDetail/news_detail_header.dart';
import '../widgets/newDetail/shar_article_buttom.dart';

class NewsDetailScreen extends StatefulWidget {
  final String? slug;

  const NewsDetailScreen({super.key, this.slug});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsService _service = NewsService();
  late Future<NewsModel> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _loadArticle();
  }

  Future<NewsModel> _loadArticle() async {
    if (widget.slug == null || widget.slug!.trim().isEmpty) {
      throw Exception('Actualité introuvable');
    }
    return _service.getNewsBySlug(widget.slug!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 90,
              color: const Color(0xFF1976F3),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: NewsDetailHeader(),
              ),
            ),
            Expanded(
              child: FutureBuilder<NewsModel>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildSkeleton();
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          snapshot.error?.toString() ?? 'Actualité introuvable',
                        ),
                      ),
                    );
                  }

                  final article = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.image.isNotEmpty)
                          Image.network(
                            article.image,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: double.infinity,
                              height: 220,
                              color: Colors.grey[200],
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 220,
                            color: Colors.grey[200],
                          ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CategoryBadge(
                                title:
                                    article.category?.name.toUpperCase() ??
                                    'ACTUALITÉ',
                              ),
                              const SizedBox(height: 24),
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF162D6B),
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    article.displayDate.isEmpty
                                        ? article.publishedAt
                                        : article.displayDate,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              Html(data: article.content ?? article.summary),
                              const SizedBox(height: 40),
                              const ShareArticleButton(),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            color: Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 24, color: Colors.grey[200]),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 28,
                  color: Colors.grey[200],
                ),
                const SizedBox(height: 12),
                Container(width: 220, height: 28, color: Colors.grey[200]),
                const SizedBox(height: 24),
                Container(width: 160, height: 18, color: Colors.grey[200]),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey[200],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey[200],
                ),
                const SizedBox(height: 10),
                Container(width: 200, height: 16, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
