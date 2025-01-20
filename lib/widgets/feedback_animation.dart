import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackAnimation extends StatefulWidget {
  final bool isCorrect;
  final VoidCallback onComplete;

  const FeedbackAnimation({
    super.key,
    required this.isCorrect,
    required this.onComplete,
  });

  @override
  State<FeedbackAnimation> createState() => _FeedbackAnimationState();
}

class _FeedbackAnimationState extends State<FeedbackAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    });
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
        return Stack(
          children: [
            // Background overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.7 * _fadeAnimation.value,
                child: Container(
                  color: widget.isCorrect ? Colors.green[50] : Colors.red[50],
                ),
              ),
            ),
            // Centered feedback content
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isCorrect
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        size: 80,
                        color: widget.isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.isCorrect ? 'Correct!' : 'Try Again!',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isCorrect
                            ? 'Great job! Keep going!'
                            : 'Don\'t worry, you\'ll get it next time!',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
