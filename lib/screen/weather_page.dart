import 'package:flutter/material.dart';
import 'package:hci/components/speak.dart';
import 'package:hci/components/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService();
  String currentWeather = '';
  String dailyWeather = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentWeather();
    fetchDailyWeather();
  }

  Future<void> fetchCurrentWeather() async {
    try {
      var weatherData = await weatherService.fetchWeather('Chennai');
      setState(() {
        currentWeather =
            '${weatherData['weather'][0]['description']}, ${weatherData['main']['temp']}°C';
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchDailyWeather() async {
    try {
      var weatherData = await weatherService.fetchDailyWeather('Chennai');
      StringBuffer sb = StringBuffer();

      DateTime now = DateTime.now();
      DateTime sixHoursFromNow = now.add(const Duration(hours: 18));

      for (var item in weatherData['list']) {
        DateTime forecastTime = DateTime.parse(item['dt_txt']);

        if (forecastTime.isAfter(now) &&
            forecastTime.isBefore(sixHoursFromNow)) {
          String time =
              '${forecastTime.hour}:${forecastTime.minute.toString().padLeft(2, '0')}';

          double tempCelsius = item['main']['temp'];

          String description = item['weather'][0]['description'];

          sb.write(
              '$time: ${(tempCelsius).toStringAsFixed(1)}°C, $description\n');
        }
      }

      setState(() {
        dailyWeather = sb.toString();
      });
    } catch (e) {
      print(e);
      speak("An error occurred while fetching the weather data.");
    }
  }

  void onTapCurrentWeather() {
    speak("Current weather is $currentWeather");
  }

  void onTapDailyWeather() {
    speak("Today's weather is as follows: $dailyWeather");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTapCurrentWeather,
              child: Container(
                color: Colors.lightBlueAccent,
                child: Center(
                  child: Text(
                    currentWeather.isNotEmpty ? currentWeather : 'Loading...',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTapDailyWeather,
              child: Container(
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    dailyWeather.isNotEmpty
                        ? "Tap for Daily Weather"
                        : 'Loading...',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
