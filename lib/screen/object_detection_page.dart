import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hci/components/speak.dart';
import 'package:http/http.dart' as http;

class ObjectDetectionPage extends StatefulWidget {
  final String imagePath;
  const ObjectDetectionPage({super.key, required this.imagePath});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  String apiUrl = "https://od-ocr-fastapi.onrender.com/analyze-image";
  String mode = "OD";
  List<String> detectedObjects = [];
  bool isLoading = true;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    analyzeImage();
  }

  Future<void> analyzeImage() async {
    try {
      final file = File(widget.imagePath);
      final imageBytes = file.readAsBytesSync();

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['mode'] = mode
        ..files.add(http.MultipartFile.fromBytes('image', imageBytes,
            filename: widget.imagePath.split('/').last));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);

        setState(() {
          detectedObjects = List<String>.from(decodedData['detected_objects']);
          isLoading = false;
        });

        speak(detectedObjects.join(', '));
      } else {
        setState(() {
          isLoading = false;
        });
        print("Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Object Detection"),
      ),
      body: GestureDetector(
        onTap: () {
          if (detectedObjects.isNotEmpty) {
            speak("Detected Objects are:");
            speak(detectedObjects.join(', '));
          } else {
            speak("No objects detected");
          }
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 250, 
                      child: Transform.rotate(
                        angle: 0 * 3.14159 / 2, 
                        child: Image.file(File(widget.imagePath)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    detectedObjects.isEmpty
                        ? const Text("No objects detected.")
                        : ListView.builder(
                            shrinkWrap: true, 
                            physics:
                                NeverScrollableScrollPhysics(), 
                            itemCount: detectedObjects.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.circle),
                                title: Text(
                                  detectedObjects[index].toUpperCase(),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
