import 'package:flutter/material.dart';

class ConcoursSearchFilter extends StatelessWidget {
  final TextEditingController controller;
  final String selectedFilter;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilterChanged;

  const ConcoursSearchFilter({
    super.key,
    required this.controller,
    required this.selectedFilter,
    required this.onSearch,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: const InputDecoration(
              hintText: "Rechercher un concours",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildChip("Tous"),
              const SizedBox(width: 12),
              _buildChip("Ouvertes"),
              const SizedBox(width: 12),
              _buildChip("Clôturés"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String value) {
    final selected = value == selectedFilter;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => onFilterChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff1E63F1) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xff1E63F1),
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xff1E63F1),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}