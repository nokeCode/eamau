import 'package:flutter/material.dart';

class ShareArticleButton extends StatelessWidget {
  const ShareArticleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.share_outlined),
        label: const Text(
          "Partager cet article",
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF162D6B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}