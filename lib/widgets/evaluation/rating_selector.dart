import 'package:flutter/material.dart';

class RatingSelector extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int> onChanged;

  const RatingSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(
        5,
            (index) {
          final value = index + 1;
          final selected = value == selectedValue;

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => onChanged(value),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? const Color(0xff174A97)
                      : Colors.white,
                  border: Border.all(
                    color: const Color(0xff174A97),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$value',
                    style: TextStyle(
                      color:
                      selected ? Colors.white : const Color(0xff174A97),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}