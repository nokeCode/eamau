import 'package:flutter/material.dart';

class FeaturedNewsCard extends StatelessWidget {
  final String image;

  const FeaturedNewsCard({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [

            Image.asset(
              image,
              fit: BoxFit.cover,
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
                        .withOpacity(0.65),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.all(20),
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

                  const Text(
                    "Inauguration du\nnouveau Campus",
                    style: TextStyle(
                      color:
                      Colors.white,
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Un espace moderne dédié à la recherche et à l'innovation.",
                    style: TextStyle(
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