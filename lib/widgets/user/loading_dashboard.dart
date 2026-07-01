import 'package:flutter/material.dart';

class LoadingDashboard extends StatelessWidget {
  const LoadingDashboard({super.key});

  Widget _shimmerBox({
    required double height,
    double? width,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
    );
  }

  Widget _statusCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: 52,
            height: 52,
            borderRadius: BorderRadius.circular(14),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(height: 16, width: 170),
                const SizedBox(height: 12),
                _shimmerBox(height: 26, width: 90),
                const SizedBox(height: 14),
                _shimmerBox(height: 12),
                const SizedBox(height: 8),
                _shimmerBox(height: 12, width: 220),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _shimmerBox(
            width: 46,
            height: 46,
            borderRadius: BorderRadius.circular(12),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(height: 14),
                const SizedBox(height: 8),
                _shimmerBox(height: 12, width: 110),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _shimmerBox(
                      width: 56,
                      height: 56,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(height: 14, width: 80),
                          const SizedBox(height: 10),
                          _shimmerBox(height: 18, width: 180),
                          const SizedBox(height: 10),
                          _shimmerBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _shimmerBox(height: 8),

                const SizedBox(height: 18),

                _shimmerBox(height: 46),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _statusCardSkeleton(),

          const SizedBox(height: 16),

          _statusCardSkeleton(),

          const SizedBox(height: 28),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _shimmerBox(height: 20, width: 150),
            ),
          ),

          const SizedBox(height: 16),

          _notificationSkeleton(),

          const SizedBox(height: 12),

          _notificationSkeleton(),

          const SizedBox(height: 12),

          _notificationSkeleton(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}