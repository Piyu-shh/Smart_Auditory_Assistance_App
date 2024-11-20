import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:hci/components/speak.dart'; // Assuming you have a speak function in this file.

class OcrPage extends StatefulWidget {
  final String imagePath;
  const OcrPage({super.key, required this.imagePath});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  late FlutterTts flutterTts;
  String extractedText = "";
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    processImage();
  }

  Future<void> processImage() async {
    setState(() {
      isProcessing = true;
    });

    try {
      // Send image to the FastAPI backend for OCR processing
      var uri =
          Uri.parse('https://c2a7-36-255-16-56.ngrok-free.app/analyze-image');
      // Replace with your backend URL
      var request = http.MultipartRequest('POST', uri);

      request.fields['mode'] = 'OCR'; // Set the mode as OCR
      request.files
          .add(await http.MultipartFile.fromPath('image', widget.imagePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseBody);
        String text = data['text'] ?? "No text detected.";

        setState(() {
          extractedText = text;
          isProcessing = false;
        });
        speak(extractedText); // Call the speak function to read text aloud
      } else {
        setState(() {
          extractedText = "Error processing image.";
          isProcessing = false;
        });
        speak(extractedText); // Speak error message
      }
    } catch (e) {
      setState(() {
        extractedText = "Error processing image.";
        isProcessing = false;
      });
      print("Error processing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (extractedText.isNotEmpty) {
              speak("Detected Text");
              speak(extractedText);
            } else {
              speak("No objects detected");
            }
          },
          child: isProcessing
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        child: Transform.rotate(
                          angle: 0,
                          child: Image.file(File(widget.imagePath)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          extractedText,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
