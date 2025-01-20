import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;

  const AnimatedProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo,
                    Colors.indigo.shade400,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
