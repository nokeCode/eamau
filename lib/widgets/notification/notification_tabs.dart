import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';

class NotificationTabs extends StatelessWidget {
  const NotificationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TabButton(
                  title: 'Toutes',
                  selected: !provider.showUnreadOnly,
                  onTap: provider.showAll,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _TabButton(
                  title: 'Non lues',
                  selected: provider.showUnreadOnly,
                  onTap: provider.showUnread,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF1E88E5)
                    : Colors.grey.shade700,
              ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }
}