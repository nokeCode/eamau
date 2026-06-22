import 'package:flutter/material.dart';
import 'news_category_tabs.dart';

class NewsHeader extends StatelessWidget {
  const NewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B7EFF),
      padding: const EdgeInsets.fromLTRB(
        24,
        20,
        24,
        20,
      ),
      child: Column(
        children: [

          Row(
            children: [

              Image.asset(
                "assets/logos/eamau_logo.gif",
                height: 42,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Université\nd'excellence",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black54,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const NewsCategoryTabs(),
        ],
      ),
    );
  }
}