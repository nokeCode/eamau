import 'package:flutter/material.dart';


import '../../models/student/menu_item_model.dart';
import 'dashboard_menu_card.dart';

class DashboardMenu extends StatelessWidget {
  final List<MenuItemModel> menu;
  final void Function(MenuItemModel item)? onItemTap;

  const DashboardMenu({
    super.key,
    required this.menu,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Accès rapide',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            itemCount: menu.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (context, index) {
              final item = menu[index];

              return DashboardMenuCard(
                item: item,
                onTap: () => onItemTap?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}