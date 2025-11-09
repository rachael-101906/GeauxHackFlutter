import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/quiz_widget2.dart';

class QuizView extends StatefulWidget {
  const QuizView({Key? key}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  void _showQuizModal() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3CBB2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Endangered Species Quiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF232D25),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        color: const Color(0xFF232D25),
                      ),
                    ],
                  ),
                ),

                const Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: AnimatedQuizSection(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz View'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: QuizUI(onQuizButtonPressed: _showQuizModal),
    );
  }
}

class QuizUI extends StatelessWidget {
  final VoidCallback onQuizButtonPressed;

  const QuizUI({super.key, required this.onQuizButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: const Color(0xFFB3CBB2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Want to see how much you know about endangered species and their scientific names?',
              textAlign: TextAlign.center,
              style: TextStyle(
               fontSize: 36,
               fontWeight: FontWeight.w700,
               height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onQuizButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9EFDE),
              foregroundColor: const Color(0xFF232E26),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(
                  width: 3,
                  color: Color(0xFF232D25),
                ),
              ),
            ),
            child: const Text(
              'Start Quiz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}