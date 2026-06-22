import 'package:flutter/material.dart';

class FeaturedNewsCard extends StatelessWidget {
  const FeaturedNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              "assets/images/campus.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [

                  Colors.transparent,

                  Colors.black.withOpacity(.15),

                  const Color(
                    0xFF003D99,
                  ).withOpacity(.85),
                ],
                stops: const [
                  0.25,
                  0.55,
                  1,
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "À LA UNE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),

                const Spacer(),

                const Text(
                  "Inauguration du\nnouveau Campus\ndes Sciences",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Un espace innovant dédié à la recherche,\nà l’apprentissage et à la collaboration.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [

                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white70,
                      size: 18,
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      "24 mai 2024",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed: () {},
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF004AAD),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Lire l'article",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}