import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mood_quotes_app/main.dart';

void main() {
  testWidgets('Mood buttons are present', (WidgetTester tester) async {
    await tester.pumpWidget(MoodQuotesApp());

    // Check if all mood buttons are visible
    expect(find.text('Happy'), findsOneWidget);
    expect(find.text('Sad'), findsOneWidget);
    expect(find.text('Angry'), findsOneWidget);
    expect(find.text('Anxious'), findsOneWidget);
  });
}
