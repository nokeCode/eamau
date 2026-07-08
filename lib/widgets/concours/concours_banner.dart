import 'package:flutter/material.dart';

class ConcoursBanner extends StatelessWidget {
  final String image;
  final String titre;
  final String description;
  final VoidCallback? onBack;

  const ConcoursBanner({
    super.key,
    required this.image,
    required this.titre,
    required this.description,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(
        top: statusBar + 10,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
              ),
            ),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              image,
              height: 175,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 175,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 50),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            titre,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}