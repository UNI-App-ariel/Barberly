import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function() onTap;
  const MyChip(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}