import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/home/banner_model.dart';
import '../../services/home/banner_service.dart';
import '../../core/api/api_config.dart';

class AdmissionBanner extends StatefulWidget {
  const AdmissionBanner({super.key});

  @override
  State<AdmissionBanner> createState() => _AdmissionBannerState();
}
class _AdmissionBannerState extends State<AdmissionBanner> {
  final BannerService _service = BannerService();

  List<BannerModel> banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    final result = await _service.getBanners();

    if (mounted) {
      setState(() {
        banners = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (banners.isEmpty) {
      return const SizedBox.shrink();
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

            child: banner.image.isNotEmpty 
                ? Image.network(
                    banner.image.startsWith('http') 
                        ? banner.image 
                        : ApiConfig.imageUrl(banner.image),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFF1682F8),
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