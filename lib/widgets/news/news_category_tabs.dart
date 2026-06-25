import 'package:flutter/material.dart';
import '../../models/news/news_category_model.dart';

class NewsCategoryTabs extends StatelessWidget {
  final List<NewsCategoryModel>
  categories;

  final int selectedCategory;

  final Function(int)
  onCategorySelected;
  const NewsCategoryTabs({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final selected =
              category.id ==
                  selectedCategory;

          return GestureDetector(
            onTap: () {
              onCategorySelected(
                category.id,
              );
            },
            child: Padding(
              padding:
              const EdgeInsets.only(
                right: 24,
              ),
              child: Column(
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 300,
                    ),
                    width:
                    selected ? 45 : 0,
                    height: 3,
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}