import 'package:flutter/material.dart';
import 'package:quiz_app/screens/start_screen.dart';
import 'package:quiz_app/widgets/confetti_animation.dart';
import 'package:quiz_app/widgets/gradient_button.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  String _getFeedback(int percentage) {
    if (percentage >= 80) {
      return 'Outstanding! You\'re a Quiz Master! 🏆';
    } else if (percentage >= 60) {
      return 'Great job! Keep it up! 🌟';
    } else if (percentage >= 40) {
      return 'Good effort! Room for improvement! 💪';
    } else {
      return 'Keep practicing! You can do better! 📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (score / (totalQuestions * 10) * 100).round();
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (percentage >= 60) const ConfettiAnimation(),
                    Container(
                      padding: const EdgeInsets.all(32),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            percentage >= 60 ? Icons.emoji_events : Icons.stars,
                            size: 80,
                            color: percentage >= 60 ? Colors.amber : Colors.blue,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Quiz Completed!',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your Score: $score/${totalQuestions * 10}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$percentage% Correct',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: percentage >= 60 ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getFeedback(percentage),
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          GradientButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      const StartScreen(),
                                  transitionsBuilder:
                                      (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                                (route) => false,
                              );
                            },
                            text: 'Try Again',
                          ),
                        ],
                      ),
                    ),
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