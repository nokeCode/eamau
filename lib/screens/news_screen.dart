import 'package:flutter/material.dart';
import '../../services/news/news_service.dart';
import '../models/news/news_model.dart';
import '../widgets/news/custom_bottom_nav.dart';
import '../widgets/news/featured_news_card.dart';
import '../widgets/news/featured_news_carousel.dart';
import '../widgets/news/news_card.dart';
import '../widgets/news/news_header.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _service = NewsService();

  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _service.getNews();
  }

  @override
  Widget build(BuildContext context) {
    final news = [
      FutureBuilder<List<NewsModel>>
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      bottomNavigationBar: const CustomBottomNav(),

      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A84FF),
                  Colors.white,
                ],
                stops: [
                  0.25,
                  0.75,
                ],
              ),
            ),
          ),
          FutureBuilder<List<NewsModel>>(
            future: _newsFuture,
            builder: (context, snapshot) {
              final news = snapshot.data ?? fallbackNews;

              return Column(
                children: [
                  const NewsHeader(),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            FeaturedNewsCarousel(news: news),

                            const SizedBox(height: 25),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Dernière Actualité"),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Voir Tout"),
                                ),
                              ],
                            ),

                            ...news.map((item) => NewsCard(news: item)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
