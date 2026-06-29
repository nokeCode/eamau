import 'package:flutter/material.dart';
import '../../models/news/news_category_model.dart';
import 'news_category_tabs.dart';

class NewsHeader extends StatelessWidget {
  final List<NewsCategoryModel>
  categories;

  final int selectedCategory;

  final Function(int)
  onCategorySelected;
  const NewsHeader({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 24,
        right: 24,
        bottom: 20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/logos/eamau_logo.gif",
                height: 45,
              ),

              const SizedBox(width: 12),

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

              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          NewsCategoryTabs(
            categories: categories,
            selectedCategory:
            selectedCategory,
            onCategorySelected:
            onCategorySelected,
          ),

        ],
      ),
    );
  }
}