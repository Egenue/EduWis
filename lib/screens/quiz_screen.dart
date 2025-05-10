import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int answerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] as String,
      options: List<String>.from(map['options']),
      answerIndex: map['answerIndex'] as int,
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> questions = [];
  int currentQuestion = 0;
  int score = 0;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  void fetchQuiz() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .limit(1)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw FirebaseException(
              plugin: 'firestore',
              message: 'Connection timeout',
            ),
          );

      if (snapshot.docs.isEmpty) {
        setState(() {
          error = 'No quiz available';
          isLoading = false;
        });
        return;
      }

      final questionsList = List.from(snapshot.docs.first['questions'] ?? []);
      setState(() {
        questions = questionsList.map((q) => QuizQuestion.fromMap(q)).toList();
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = 'Firebase error: ${e.message}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading quiz: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void answerQuestion(int index) {
    if (index == questions[currentQuestion].answerIndex) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Complete"),
          content: Text("Your score: $score/${questions.length}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)));
    }

    if (questions.isEmpty) {
      return const Center(child: Text('No questions available'));
    }

    final question = questions[currentQuestion];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${currentQuestion + 1}/${questions.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          question.question,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        ...question.options.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () => answerQuestion(entry.key),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(entry.value),
              ),
            )),
      ],
    );
  }
}
