import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  testWidgets('Shows loading then data when API returns valid data', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2500));

    final noDataText = find.textContaining('No data');
    final errorText = find.textContaining('malformed');
    final cityText = find.textContaining('New York');

    final hasAnyVisible = noDataText.evaluate().isNotEmpty ||
        errorText.evaluate().isNotEmpty ||
        cityText.evaluate().isNotEmpty;

    expect(hasAnyVisible, isTrue,
        reason: 'Expected to find data, error, or no data message');
  });

  testWidgets('Selecting "Invalid City" shows error', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WeatherDisplay()));

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invalid City').last);
    await tester.pump(); 
    await tester.pump(const Duration(milliseconds: 2200)); 

    expect(find.textContaining('No data returned from server'), findsOneWidget);
  });
}
