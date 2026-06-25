import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class AdmissionBanner extends StatelessWidget {
  const AdmissionBanner({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> images = [
      'assets/images/building.jpg',
      'assets/images/building2.jpg',
      'assets/images/building3.jpg',
    ];

    return CarouselSlider.builder(
      itemCount: images.length,

      options: CarouselOptions(
        height: 280,

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


class _BannerItem extends StatelessWidget {

  final String imagePath;

  const _BannerItem({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),

      child: Stack(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,

                colors: [
                  Color(0xFF173B7A),
                  Color(0xAA173B7A),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: const Text(
                    'ADMISSIONS 2025-2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Construisez\nvotre avenir\navec EAMAU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Excellence académique,\nleadership de demain.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {},

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.white,
                  ),

                  child: const Text(
                    'En savoir plus',
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
