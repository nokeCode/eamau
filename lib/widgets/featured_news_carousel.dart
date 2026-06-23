import 'package:flutter/material.dart';
import 'feature_news_card.dart';
import 'featured_news_card.dart';

class FeaturedNewsCarousel extends StatefulWidget {
  const FeaturedNewsCarousel({super.key});

  @override
  State<FeaturedNewsCarousel> createState() => _FeaturedNewsCarouselState();
}

class _FeaturedNewsCarouselState extends State<FeaturedNewsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: const [
              FeaturedNewsCard(image: "assets/images/actualite1.jpg"),

              FeaturedNewsCard(image: "assets/images/actualite2.jpg"),

              FeaturedNewsCard(image: "assets/images/actualite3.jpg"),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? const Color(0xFF0A84FF)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
