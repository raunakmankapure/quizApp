import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/widgets/animated_progress_bar.dart';
import 'package:quiz_app/widgets/feedback_animation.dart';
import 'package:quiz_app/widgets/option_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final QuizService _quizService = QuizService();
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  String error = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? selectedAnswer;
  bool showFeedback = false;
  bool? isAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    fetchQuizData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchQuizData() async {
    try {
      final result = await _quizService.fetchQuizData();
      if (mounted) {
        setState(() {
          questions = result;
          isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  void answerQuestion(String answer) {
    if (showFeedback) return;

    final isCorrect = answer == questions[currentQuestionIndex]['description'];

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;
      isAnswerCorrect = isCorrect;
    });
  }

  void onFeedbackComplete() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        if (isAnswerCorrect!) {
          score += 10;
        }
        currentQuestionIndex++;
        selectedAnswer = null;
        showFeedback = false;
        isAnswerCorrect = null;
      });
    } else {
      if (isAnswerCorrect!) {
        score += 10;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
          ),
        ),
      );
    }
  }

  Color getOptionColor(String option) {
    if (!showFeedback || selectedAnswer != option) return Colors.white;

    return option == questions[currentQuestionIndex]['description']
        ? Colors.green.shade100
        : Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.indigo,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Questions...',
                style: GoogleFonts.outfit(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error,
                style: GoogleFonts.outfit(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    error = '';
                  });
                  fetchQuizData();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                'No questions available',
                style: GoogleFonts.outfit(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];
    final List<String> options = [
      question['description'] as String,
      ...(question['incorrect_answers'] as List<String>),
    ]..shuffle();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 142, 183, 252),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 116, 116),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: AnimatedProgressBar(
            value: (currentQuestionIndex + 1) / questions.length,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: const BoxDecoration(
                    color: const Color.fromARGB(255, 250, 116, 116),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${currentQuestionIndex + 1} of ${questions.length}',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question['question_text'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: OptionCard(
                          option: option,
                          index: index,
                          onTap: () => answerQuestion(option),
                          backgroundColor: getOptionColor(option),
                          isSelected: selectedAnswer == option,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (showFeedback && isAnswerCorrect != null)
            Positioned.fill(
              child: FeedbackAnimation(
                isCorrect: isAnswerCorrect!,
                onComplete: onFeedbackComplete,
              ),
            ),
        ],
      ),
    );
  }
}
