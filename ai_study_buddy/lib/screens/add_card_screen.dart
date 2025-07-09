// lib/screens/add_card_screen.dart

import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  void saveCard() {
    final q = questionController.text.trim();
    final a = answerController.text.trim();
    if (q.isNotEmpty && a.isNotEmpty) {
      Navigator.pop(context, Flashcard(question: q, answer: a));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Both fields are required.')),
      );
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flashcard')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: saveCard, child: Text('Save Card')),
          ],
        ),
      ),
    );
  }
}
