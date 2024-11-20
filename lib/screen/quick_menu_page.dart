import 'package:flutter/material.dart';
import 'package:hci/components/speak.dart';
import 'package:hci/screen/contacts_page.dart';
import 'package:hci/screen/weather_page.dart';

class QuickMenuPage extends StatefulWidget {
  const QuickMenuPage({super.key});

  @override
  State<QuickMenuPage> createState() => _QuickMenuPageState();
}

class _QuickMenuPageState extends State<QuickMenuPage> {
  Future<void> onTap_battery() async {
    // Simulated battery level for demonstration
    int batteryLevel = 10;
    speak("Battery level is $batteryLevel percent.");
  }

  void onTap_time() {
    final DateTime now = DateTime.now();
    String formattedTime =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    String announcement = 'the time is $formattedTime.';
    speak(announcement);
  }

  void onTap_date() {
    final DateTime now = DateTime.now();

    String formattedDate = '${now.day}-${now.month}-${now.year}';

    String announcement = 'The current date is $formattedDate';
    speak(announcement);
  }

  void onTap_weather() {
    speak("Double Tap to proceed to Weather Page");
  }

  void doubleTap_weather() {
    speak("Weather Page");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const WeatherPage()), // Navigate to WeatherPage
    );
  }

  void onTap_contacts() {
    speak("Double Tap to proceed to Contacts");
  }

  void doubleTap_contacts() {
    speak("Contacts");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactsPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    speak("Quick Menu Page");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap_battery,
                  child: Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'Battery Percentage %',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTap_weather,
                  onDoubleTap: doubleTap_weather,
                  child: Container(
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'Weather',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap_time,
                  onDoubleTap: onTap_date,
                  child: Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        'Time and Date',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTap_contacts,
                  onDoubleTap: doubleTap_contacts,
                  child: Container(
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        'Contacts',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
