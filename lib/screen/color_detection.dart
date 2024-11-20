import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hci/components/speak.dart';
import 'package:image/image.dart' as img;
import 'package:palette_generator/palette_generator.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/services.dart';

Future<String> getDominantColor(img.Image image) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
    MemoryImage(Uint8List.fromList(img.encodeJpg(image))),
  );
  final dominantColor = paletteGenerator.dominantColor?.color;
  final colorName = ColorNames.guess(dominantColor!);
  speak('The most dominant color is $colorName');
  return 'The most dominant color is $colorName';
}

class ColorDetection extends StatefulWidget {
  final String imagePath;

  const ColorDetection({
    super.key,
    required this.imagePath,
  });

  @override
  State<ColorDetection> createState() => _ColorDetectionState();
}

class _ColorDetectionState extends State<ColorDetection> {
  late Future<String> _resultFuture;

  @override
  void initState() {
    super.initState();
    _resultFuture = handleImage(widget.imagePath);
  }

  Future<String> handleImage(String imagePath) async {
    final imageFile = File(imagePath);
    final image = img.decodeImage(await imageFile.readAsBytes())!;
    final color = await getDominantColor(image);
    speak(color);
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _resultFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250, // Set a fixed height for the image
                    child: Transform.rotate(
                      angle: 0 * 3.14159 / 2, // Rotate 90 degrees to the left
                      child: Image.file(File(widget.imagePath)),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    snapshot.data!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
