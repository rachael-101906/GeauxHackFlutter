import 'package:flutter/material.dart';
import 'package:animated_quiz_widget/models/quiz_models.dart';
import 'package:animated_quiz_widget/widgets/quiz_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AnimatedQuizSection extends StatefulWidget {
  const AnimatedQuizSection({super.key});

  @override
  State<AnimatedQuizSection> createState() => _AnimatedQuizSectionState();
}

class _AnimatedQuizSectionState extends State<AnimatedQuizSection> {
  List<QuizQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    final questions = await QuizHelper.loadOrganismQuiz();
    setState(() {
      _questions = questions;
    });
  }

  void _showQuizResults(BuildContext context, List<QuizQuestion> questions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Here are your answers:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...questions.map((q) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(q.question, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                'Answer: ${q.selectedAnswer ?? "Not answered"}'
                '${q.selectedAnswer != null ? (q.isCorrect ? " ✅" : " ❌") : ""}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(16),
      child: QuizWidget(
        questions: _questions,
        config: const QuizConfig(
          backgroundColor: Color.fromARGB(255, 81, 118, 89),
          cornerRadius: 16,
          padding: EdgeInsets.all(24),
          showProgressIndicator: true,
          requireAnswerToProgress: true,
          allowBackwardNavigation: true,
          enableAutoNavigation: true,
          autoNavigationDelay: Duration(milliseconds: 1000),
          useGradientBackground: true,
          gradientColors: [
            Color(0xFFD9EFDE),
            Color(0xFF232E26),
            Colors.white,
          ],
        ),
        onAnswerChanged: (question, answer) {
          debugPrint('Question ${question.id}: $answer');
        },
        onQuizCompleted: (questions) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showQuizResults(context, questions);
          });
        },
      ),
    );
  }
}

class QuizHelper {
  static Future<List<QuizQuestion>> loadOrganismQuiz() async {
    final String jsonString =
        await rootBundle.loadString('assets/databases/organismsList.json');
    final List<dynamic> data = json.decode(jsonString);

    // Shuffle for randomization
    data.shuffle();

    // Only take first 5 organisms
    final List<dynamic> selectedOrganisms = data.take(5).toList();

    // Pre-extract all scientific names for generating wrong answers
    final List<String> allScientificNames = data
        .map((o) => o['scientific_name'].toString())
        .toList();

    // Generate questions
    List<QuizQuestion> questions = selectedOrganisms.map((organism) {
      final String correctAnswer = organism['scientific_name']?.toString() ?? 'Unknown';

      // Generate 3 wrong options
      List<String> wrongOptions = allScientificNames
          .where((name) => name != correctAnswer)
          .toList()
        ..shuffle();
      wrongOptions = wrongOptions.take(3).toList();

      // Combine correct answer with wrong ones
      final List<String> options = [correctAnswer, ...wrongOptions]..shuffle();

      return QuizQuestion(
        id: 'org_${organism['id'] ?? organism['common_name']}',
        question: organism['common_name']?.toString() ?? 'Unknown',
        options: options,
        correctAnswer: correctAnswer,
      );
    }).toList();

    return questions;
  }
}