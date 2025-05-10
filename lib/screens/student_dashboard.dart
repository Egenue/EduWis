
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
          child: const Text("Take a Quiz"),
        ),
      ),
    );
  }
}
