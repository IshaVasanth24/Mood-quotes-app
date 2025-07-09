// lib/screens/flashcard_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';
import 'add_card_screen.dart';

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Flashcard> flashcards = [];
  List<bool> showAnswers = [];

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void toggleCard(int index) {
    setState(() {
      showAnswers[index] = !showAnswers[index];
    });
  }

  void addFlashcard(Flashcard card) {
    setState(() {
      flashcards.add(card);
      showAnswers.add(false);
    });
    saveFlashcards();
  }

  void deleteFlashcard(int index) {
    setState(() {
      flashcards.removeAt(index);
      showAnswers.removeAt(index);
    });
    saveFlashcards();
  }

  Future<void> saveFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = flashcards
        .map((card) => jsonEncode(card.toJson()))
        .toList();
    await prefs.setStringList('flashcards', jsonList);
  }

  Future<void> loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList('flashcards');
    if (stored != null) {
      final loaded = stored
          .map((s) => Flashcard.fromJson(jsonDecode(s)))
          .toList();
      setState(() {
        flashcards = loaded;
        showAnswers = List<bool>.filled(loaded.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcards')),
      body: flashcards.isEmpty
          ? Center(child: Text('No flashcards yet', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final card = flashcards[index];
                final isFlipped = showAnswers[index];
                return GestureDetector(
                  onTap: () => toggleCard(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isFlipped ? Colors.indigo.shade100 : Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            isFlipped ? card.answer : card.question,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white70),
                            onPressed: () => deleteFlashcard(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Flashcard? newCard = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddCardScreen()),
          );
          if (newCard != null) addFlashcard(newCard);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
