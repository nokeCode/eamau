import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusMap extends StatelessWidget {
  final String mapUrl;

  const CampusMap({
    super.key,
    required this.mapUrl,
  });

  Future<void> _openMap() async {
    if (mapUrl.isEmpty) return;

    final uri = Uri.parse(mapUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: double.infinity,
            height: 140,
            child: Image.network(
              mapUrl.isNotEmpty
                  ? mapUrl
                  : "https://maps.googleapis.com/maps/api/staticmap?center=EAMAU,Lome&zoom=16&size=700x300",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Image.asset(
                  "assets/images/map_placeholder.png",
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: ElevatedButton(
            onPressed: _openMap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E4DB7),
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "voir sur la carte",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}