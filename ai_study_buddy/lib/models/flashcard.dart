// lib/models/flashcard.dart

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
  };

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}
