import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts(); // Create an instance of FlutterTts

// Function to give audio feedback using TTS
Future<void> speak(String message) async {
  await flutterTts.setLanguage("en-US"); // Set language
  await flutterTts.setPitch(1.0); // Set pitch (default is 1.0)
  await flutterTts.speak(message);
  // Speak the message
}
