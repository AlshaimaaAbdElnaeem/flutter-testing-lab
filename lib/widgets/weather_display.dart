// lib/weather_display.dart
import 'package:flutter/material.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _error;
  bool _useFahrenheit = false;
  String _selectedCity = 'New York';

  final List<String> _cities = ['New York', 'London', 'Tokyo', 'Invalid City'];

  // ====== تصحيح معادلات التحويل ======
  double celsiusToFahrenheit(double celsius) {
    return celsius * 9 / 5 + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  // Simulate API call that sometimes returns null or malformed data
  Future<Map<String, dynamic>?> _fetchWeatherData(String city) async {
    await Future.delayed(const Duration(seconds: 2));

    if (city == 'Invalid City') {
      return null;
    }

    // Simulate occasionally only partial data (malformed)
    if (DateTime.now().millisecond % 4 == 0) {
      return {'city': city, 'temperature': 22.5}; // incomplete on purpose
    }

    return {
      'city': city,
      'temperature': city == 'London' ? 15.0 : (city == 'Tokyo' ? 25.0 : 22.5),
      'description': city == 'London'
          ? 'Rainy'
          : (city == 'Tokyo' ? 'Cloudy' : 'Sunny'),
      'humidity': city == 'London' ? 85 : (city == 'Tokyo' ? 70 : 65),
      'windSpeed': city == 'London' ? 8.5 : (city == 'Tokyo' ? 5.2 : 12.3),
      'icon': city == 'London' ? '🌧️' : (city == 'Tokyo' ? '☁️' : '☀️'),
    };
  }

  // ====== تحميل البيانات مع معالجة الأخطاء والـloading بشكل صحيح ======
  Future<void> _loadWeather() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _weatherData = null;
    });

    try {
      final data = await _fetchWeatherData(_selectedCity);

      if (data == null) {
        // API returned null
        if (!mounted) return;
        setState(() {
          _error = 'No data returned from server for "$_selectedCity".';
          _isLoading = false;
        });
        return;
      }

      final parsed = WeatherData.tryParse(data);
      if (parsed == null) {
        // Malformed / incomplete data
        if (!mounted) return;
        setState(() {
          _error = 'Received malformed weather data.';
          _isLoading = false;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _weatherData = parsed;
        _isLoading = false;
      });
    } catch (e, st) {
      // Unexpected error: show message and stop loading
      if (!mounted) return;
      setState(() {
        _error = 'Error loading weather: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // City selection
          Row(
            children: [
              const Text('City: '),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCity,
                  isExpanded: true,
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCity = value;
                      });
                      _loadWeather();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _loadWeather,
                child: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Temperature unit toggle
          Row(
            children: [
              const Text('Temperature Unit:'),
              const SizedBox(width: 10),
              Switch(
                value: _useFahrenheit,
                onChanged: (value) {
                  setState(() {
                    _useFahrenheit = value;
                  });
                },
              ),
              Text(_useFahrenheit ? 'Fahrenheit' : 'Celsius'),
            ],
          ),
          const SizedBox(height: 16),

          // Loading, error, or data
          if (_isLoading && _error == null) ...[
            const Center(child: CircularProgressIndicator())
          ] else if (_error != null) ...[
            // Show error and a retry button
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadWeather,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (_weatherData != null) ...[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _weatherData!.icon,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _weatherData!.city,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _weatherData!.description,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        _useFahrenheit
                            ? '${celsiusToFahrenheit(_weatherData!.temperatureCelsius).toStringAsFixed(1)}°F'
                            : '${_weatherData!.temperatureCelsius.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeatherDetail(
                          'Humidity',
                          '${_weatherData!.humidity}%',
                          Icons.water_drop,
                        ),
                        _buildWeatherDetail(
                          'Wind Speed',
                          '${_weatherData!.windSpeed} km/h',
                          Icons.air,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // neither loading, nor error, nor data (empty state)
            const Center(child: Text('No weather data available.')),
          ],
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class WeatherData {
  final String city;
  final double temperatureCelsius;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;

  WeatherData({
    required this.city,
    required this.temperatureCelsius,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  // Try-parse: ترجع null لو البيانات ناقصة أو غير صحيحة
  static WeatherData? tryParse(Map<String, dynamic>? json) {
    if (json == null) return null;

    try {
      // Required keys
      if (!json.containsKey('city') || !json.containsKey('temperature')) {
        return null;
      }

      final city = json['city']?.toString();
      final tempVal = json['temperature'];
      if (city == null || tempVal == null) return null;

      final double temperature = (tempVal is num) ? tempVal.toDouble() : double.tryParse(tempVal.toString()) ?? double.nan;
      if (temperature.isNaN) return null;

      // Optional with defaults if missing
      final description = json['description']?.toString() ?? 'No description';
      final humidityVal = json['humidity'] ?? 0;
      final humidity = (humidityVal is int) ? humidityVal : int.tryParse(humidityVal.toString()) ?? 0;
      final windVal = json['windSpeed'] ?? 0.0;
      final windSpeed = (windVal is num) ? windVal.toDouble() : double.tryParse(windVal.toString()) ?? 0.0;
      final icon = json['icon']?.toString() ?? '❓';

      return WeatherData(
        city: city,
        temperatureCelsius: temperature,
        description: description,
        humidity: humidity,
        windSpeed: windSpeed,
        icon: icon,
      );
    } catch (_) {
      return null;
    }
  }
}
