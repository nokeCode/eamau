import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/home/banner_model.dart';
import '../../services/home/banner_service.dart';

class AdmissionBanner extends StatefulWidget {
  const AdmissionBanner({super.key});

  @override
  State<AdmissionBanner> createState() => _AdmissionBannerState();
}

class _AdmissionBannerState extends State<AdmissionBanner> {
  final BannerService _service = BannerService();

  List<BannerModel> banners = [];

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    final result = await _service.getBanners();

    setState(() {
      banners = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: banners.length,

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
          banner: banners[index],
        );
      },
    );
  }
}

class _BannerItem extends StatelessWidget {
  final BannerModel banner;

  const _BannerItem({
    required this.banner,
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
              banner.image,
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
                  Color(0xCC173B7A),
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

                Text(
                  banner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight:
                    FontWeight.bold,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  banner.description,
                  style: const TextStyle(
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
                    foregroundColor:
                    Colors.black,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        30,
                      ),
                    ),
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