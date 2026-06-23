import 'package:flutter/material.dart';

import '../widgets/newDetail/news_category_badge.dart';
import '../widgets/newDetail/news_detail_header.dart';
import '../widgets/newDetail/shar_article_buttom.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key});

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
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: NewsDetailHeader(),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/actualite2.jpg",
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const CategoryBadge(
                            title: "VIE UNIVERSITAIRE",
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            "Atelier internationale Eamau / Paris-Malaquais - PSL",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight:
                              FontWeight.w700,
                              color:
                              Color(0xFF162D6B),
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
                                "07 Avril 2026",
                                style: TextStyle(
                                  color:
                                  Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          const Divider(),

                          const SizedBox(height: 16),

                          const Text(
                            '''
Des figures territoriales et des architectures manifeste.

Une exploration des Métropoles d'Afrique de l'Ouest.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
''',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 40),

                          const ShareArticleButton(),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}