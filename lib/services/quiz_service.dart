import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class QuizService {
  static const String _apiUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<List<Map<String, dynamic>>> fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final questions = List<Map<String, dynamic>>.from(data['questions']);

        // Shuffle the questions to ensure random order
        questions.shuffle();

        // Transform the data structure to match our needs
        return List.generate(questions.length, (index) {
          // Get current question
          final question = questions[index];

          // Get other questions for incorrect answers, excluding current question
          final otherQuestions = questions
              .where((q) => q['description'] != question['description'])
              .toList();
          otherQuestions.shuffle(); // Shuffle to get random incorrect answers

          // Take only 3 incorrect answers
          final incorrectAnswers = otherQuestions
              .take(3)
              .map((q) => q['description'] as String)
              .toList();

          return {
            'question_text': 'What is this element?',
            'description': question['description'],
            'incorrect_answers': incorrectAnswers,
          };
        });
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      throw Exception('Error fetching quiz data: $e');
    }
  }
}
