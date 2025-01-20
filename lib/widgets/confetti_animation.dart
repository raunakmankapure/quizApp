import 'package:flutter/material.dart';
import 'dart:math';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({super.key});

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Confetti> confetti = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    for (int i = 0; i < 50; i++) {
      confetti.add(Confetti(random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: ConfettiPainter(confetti, _controller.value),
        );
      },
    );
  }
}

class Confetti {
  late double x;
  late double y;
  late Color color;
  late double size;
  late double speed;

  Confetti(Random random) {
    x = random.nextDouble();
    y = random.nextDouble() * -1;
    color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    size = random.nextDouble() * 8 + 2;
    speed = random.nextDouble() * 2 + 1;
  }
}

class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter(this.confetti, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in confetti) {
      double y = (particle.y + progress * particle.speed) % 1;
      paint.color = particle.color;
      canvas.drawCircle(
        Offset(particle.x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}