
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];
  int currentQuestion = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  void fetchQuiz() async {
    final snapshot = await FirebaseFirestore.instance.collection('quizzes').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        questions = List.from(snapshot.docs.first['questions'] ?? []);
      });
    }
  }

  void answerQuestion(int index) {
    if (index == questions[currentQuestion]['answerIndex']) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Complete"),
          content: Text("Your score: $score/${questions.length}"),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q['question'], style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ...List.generate((q['options'] as List).length, (index) => ElevatedButton(
              onPressed: () => answerQuestion(index),
              child: Text(q['options'][index]),
            ))
          ],
        ),
      ),
    );
  }
}
