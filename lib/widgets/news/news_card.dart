import 'package:flutter/material.dart';
import '../../models/news/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({
    super.key,
    required this.news,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [

          ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: Image.network(
              news.image,
              width: 95,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Image.asset(
                'assets/images/actualite1.jpg',
                width: 95,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  news.title,
                  style: const TextStyle(
                    color: Color(0xFF0066FF),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 5),

                Text(
                  news.description,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    const Icon(
                      Icons.calendar_month,
                      size: 14,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      news.date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}