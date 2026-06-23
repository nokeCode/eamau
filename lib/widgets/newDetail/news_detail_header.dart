import 'package:flutter/material.dart';

class NewsDetailHeader extends StatelessWidget {
  const NewsDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        const Expanded(
          child: Text(
            "Actualité",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.ios_share),
        ),
      ],
    );
  }
}