import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/news/news_model.dart';
import 'featured_news_card.dart';

class FeaturedNewsCarousel extends StatefulWidget {
  final List<NewsModel> news;
  final ValueChanged<NewsModel>? onNewsTapped;

  const FeaturedNewsCarousel({
    super.key,
    required this.news,
    this.onNewsTapped,
  });

  @override
  State<FeaturedNewsCarousel> createState() => _FeaturedNewsCarouselState();
}

class _FeaturedNewsCarouselState extends State<FeaturedNewsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  late Timer _timer;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients) {
        _controller.animateToPage(
          currentPage + 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredNews = widget.news.where((news) => news.featured).toList();
    final items = featuredNews.isNotEmpty ? featuredNews : widget.news;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = items[index % items.length];
              return FeaturedNewsCard(
                news: item,
                onTap: () => widget.onNewsTapped?.call(item),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (index) {
            final selected = currentPage % items.length == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: selected ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0A84FF)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
