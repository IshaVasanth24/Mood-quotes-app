import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MoodQuotesApp());
}

class MoodQuotesApp extends StatelessWidget {
  const MoodQuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Quotes',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const MoodSelector(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? selectedMood;
  String? displayedQuote;
  String? author;
  bool isLoading = false;
  String? errorMessage;

  final List<String> moods = ['Happy', 'Sad', 'Angry', 'Anxious'];

  final Map<String, String> moodTags = {
    'Happy': 'happiness',
    'Sad': 'sadness',
    'Angry': 'anger',
    'Anxious': 'fear',
  };

  Future<void> fetchQuote(String mood) async {
    setState(() {
      isLoading = true;
      displayedQuote = null;
      author = null;
      errorMessage = null;
    });

    final tag = moodTags[mood] ?? 'inspirational';
    final url = Uri.parse('https://api.quotable.io/random?tags=$tag');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          selectedMood = mood;
          displayedQuote = data['content'];
          author = data['author'];
        });
      } else {
        setState(() {
          errorMessage = "Error fetching quote.";
        });
      }
    } on TimeoutException {
      setState(() {
        errorMessage = "Request timed out. Please try again.";
      });
    } on http.ClientException catch (e) {
      debugPrint('ClientException: $e');
      setState(() {
        errorMessage = "Connection failed. Check your internet connection.";
      });
    } catch (e) {
      debugPrint('Unexpected error: $e');
      setState(() {
        errorMessage = "An unexpected error occurred.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Quotes'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: moods.map((mood) {
                return ElevatedButton(
                  onPressed: isLoading ? null : () => fetchQuote(mood),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(mood),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (displayedQuote != null && !isLoading)
              Column(
                children: [
                  Text(
                    'Here’s something for your $selectedMood mood:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '"$displayedQuote"',
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '- ${author ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => fetchQuote(selectedMood!),
                    child: const Text('Try Another Quote'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
