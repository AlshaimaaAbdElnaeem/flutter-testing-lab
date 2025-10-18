// test/weather_data_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature conversion', () {
    test('Celsius to Fahrenheit', () {
      final state = _DummyState();
      expect(state.celsiusToFahrenheit(0), 32); // 0°C => 32°F
      expect(state.celsiusToFahrenheit(100), closeTo(212, 0.0001)); // boiling
      expect(state.celsiusToFahrenheit(-40), closeTo(-40, 0.0001)); // same point
    });

    test('Fahrenheit to Celsius', () {
      final state = _DummyState();
      expect(state.fahrenheitToCelsius(32), closeTo(0, 0.0001));
      expect(state.fahrenheitToCelsius(212), closeTo(100, 0.0001));
      expect(state.fahrenheitToCelsius(-40), closeTo(-40, 0.0001));
    });
  });

  group('WeatherData parsing', () {
    test('Valid complete data', () {
      final json = {
        'city': 'TestCity',
        'temperature': 20,
        'description': 'Sunny',
        'humidity': 50,
        'windSpeed': 5.5,
        'icon': '☀️',
      };
      final parsed = WeatherData.tryParse(json);
      expect(parsed, isNotNull);
      expect(parsed!.city, 'TestCity');
      expect(parsed.temperatureCelsius, 20.0);
      expect(parsed.description, 'Sunny');
      expect(parsed.humidity, 50);
      expect(parsed.windSpeed, 5.5);
      expect(parsed.icon, '☀️');
    });

    test('Missing required fields returns null', () {
      final json = {'city': 'TestCity'}; // no temperature
      final parsed = WeatherData.tryParse(json);
      expect(parsed, isNull);
    });

    test('Malformed types handled gracefully', () {
      final json = {'city': 'X', 'temperature': '25.5', 'humidity': '70', 'windSpeed': '3.2'};
      final parsed = WeatherData.tryParse(json);
      expect(parsed, isNotNull);
      expect(parsed!.temperatureCelsius, 25.5);
      expect(parsed.humidity, 70);
      expect(parsed.windSpeed, 3.2);
    });
  });
}

// helper class to access conversion methods (we reuse the same methods from the State)
class _DummyState {
  double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;
  double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;
}
