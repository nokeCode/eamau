import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinks extends StatelessWidget {
  final Map<String, String> links;

  const SocialLinks({
    super.key,
    required this.links,
  });

  Future<void> _launch(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget _socialButton({
    required IconData icon,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launch(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF1E4DB7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      alignment: WrapAlignment.center,
      children: [
        _socialButton(
          icon: Icons.facebook,
          url: links["facebook"] ?? "",
        ),
        _socialButton(
          icon: Icons.camera_alt_outlined,
          url: links["instagram"] ?? "",
        ),
        _socialButton(
          icon: Icons.business,
          url: links["linkedin"] ?? "",
        ),
        _socialButton(
          icon: Icons.play_arrow_rounded,
          url: links["youtube"] ?? "",
        ),
        _socialButton(
          icon: Icons.alternate_email,
          url: links["twitter"] ?? "",
        ),
      ],
    );
  }
}