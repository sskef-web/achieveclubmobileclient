import 'package:flutter/material.dart';

class CustomDotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final double dotSize;
  final double dotSpacing;
  final Function(int) onDotTapped;

  const CustomDotIndicator({
    required this.itemCount,
    required this.currentIndex,
    this.dotSize = 8.0,
    this.dotSpacing = 8.0,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return GestureDetector(
          onTap: () => onDotTapped(index),
          child: Container(
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.symmetric(horizontal: dotSpacing / 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex ? Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}
