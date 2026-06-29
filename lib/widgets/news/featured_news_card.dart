import 'package:flutter/material.dart';
import '../../models/news/news_model.dart';

class FeaturedNewsCard extends StatelessWidget {
  final NewsModel news;

  const FeaturedNewsCard({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [

            Image.network(
              news.image,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) =>
                  Image.asset(
                    "assets/images/building.jpg",
                    fit: BoxFit.cover,
                  ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:
                  Alignment.topCenter,
                  end:
                  Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black
                        .withOpacity(
                      0.65,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white24,
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: const Text(
                      "À LA UNE",
                      style: TextStyle(
                        color:
                        Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    news.title,
                    maxLines: 2,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                      fontSize: 24,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    news.description,
                    maxLines: 2,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}