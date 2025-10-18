import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  testWidgets('Form shows validation messages', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: UserRegistrationForm()));

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('Shows success message when valid data is entered',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: UserRegistrationForm()));

    await tester.enterText(find.byType(TextFormField).at(0), 'Alshaimaa');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'Strong@123');
    await tester.enterText(find.byType(TextFormField).at(3), 'Strong@123');

    await tester.tap(find.text('Register'));
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Registration successful!'), findsOneWidget);
  });
}
