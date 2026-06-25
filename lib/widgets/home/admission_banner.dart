import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdmissionBanner extends StatelessWidget {
  const AdmissionBanner({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> images = [
      'assets/images/building1.jpg',
      'assets/images/building2.jpg',
      'assets/images/building3.jpg',
    ];

    return CarouselSlider.builder(
      itemCount: images.length,

      options: CarouselOptions(
        height: 250,

        viewportFraction: 1,

        autoPlay: true,

        autoPlayInterval: const Duration(seconds: 4),

        autoPlayAnimationDuration:
        const Duration(milliseconds: 800),

        enlargeCenterPage: false,

        enableInfiniteScroll: true,
      ),

      itemBuilder: (
          context,
          index,
          realIndex,
          ) {
        return _BannerItem(
          imagePath: images[index],
        );
      },
    );
  }
}