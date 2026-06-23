import 'package:flutter/material.dart';
import 'feature_news_card.dart';
import 'featured_news_card.dart';
import 'dart:async';

class FeaturedNewsCarousel extends StatefulWidget {
  const FeaturedNewsCarousel({super.key});

  @override
  State<FeaturedNewsCarousel> createState() => _FeaturedNewsCarouselState();
}

class _FeaturedNewsCarouselState extends State<FeaturedNewsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);

  late Timer _timer;

  final int totalPages = 3;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
          (_) {
        if (_controller.hasClients) {
          currentPage++;

          _controller.animateToPage(
            currentPage,
            duration: const Duration(
              milliseconds: 500,
            ),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              final images = [
                "assets/images/actualite1.jpg",
                "assets/images/actualite2.jpg",
                "assets/images/actualite3.jpg",
              ];

              return FeaturedNewsCard(
                image: images[
                index % images.length],
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
                (index) {
              final selected =
                  currentPage % totalPages ==
                      index;

              return AnimatedContainer(
                duration:
                const Duration(milliseconds: 300),
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                width: selected ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0A84FF)
                      : Colors.grey.shade300,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
