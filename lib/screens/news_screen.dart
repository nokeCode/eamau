import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/feature_news_card.dart';
import '../widgets/featured_news_card.dart';
import '../widgets/featured_news_carousel.dart';
import '../widgets/news_card.dart';
import '../widgets/news_header.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final news = [

      NewsModel(
        title: "Atelier internationale",
        description:
        "Des figures territoriales et des architectures manifeste.",
        image:
        "assets/images/actualite1.jpg",
        date: "07 avril 2026",
      ),

      NewsModel(
        title: "Concours d'entrée",
        description:
        "Concours d'entrée au titre de l'année académique.",
        image:
        "assets/images/actualite2.jpg",
        date: "12 mai 2026",
      ),

      NewsModel(
        title:
        "Installation du Comité d'organisation",
        description:
        "Réunion d'installation du Comité.",
        image:
        "assets/images/actualite3.jpg",
        date: "27 février 2026",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,

      bottomNavigationBar:
      const CustomBottomNav(),

      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A84FF),
                  Colors.white,
                ],
                stops: [
                  0.45,
                  0.55,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const NewsHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [

                          const SizedBox(height: 10),

                          const FeaturedNewsCarousel(),

                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Dernière Actualité",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Voir Tout",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          ...news.map(
                                (item) => NewsCard(
                              news: item,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}