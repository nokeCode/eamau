import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FiliereSlider extends StatefulWidget {
  final List<String> images;

  const FiliereSlider({
    super.key,
    required this.images,
  });

  @override
  State<FiliereSlider> createState() => _FiliereSliderState();
}

class _FiliereSliderState extends State<FiliereSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isEmpty
        ? [
      "https://images.unsplash.com/photo-1511818966892-d7d671e672a2"
    ]
        : widget.images;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: Image.network(
                images[index],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _current == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _current == index
                    ? const Color(0xff0D6EFD)
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}