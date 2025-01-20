import 'package:flutter/material.dart';
import 'package:quiz_app/screens/start_screen.dart';
import 'package:quiz_app/theme/app_theme.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz App',
      theme: AppTheme.lightTheme,
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}