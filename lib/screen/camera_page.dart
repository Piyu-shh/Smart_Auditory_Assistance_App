import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hci/screen/color_detection.dart';
import 'package:hci/screen/object_detection_page.dart';
import 'package:hci/screen/ocr_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameras = cameras;
        cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
        );
      });

      await cameraController?.initialize();
      await cameraController
          ?.lockCaptureOrientation(DeviceOrientation.portraitUp);

      setState(() {});
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage(BuildContext context, int num) async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile image = await cameraController!.takePicture();
      if (num == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColorDetection(imagePath: image.path),
          ),
        );
      }
      if (num == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OcrPage(imagePath: image.path),
          ),
        );
      }
      if (num == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObjectDetectionPage(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => _captureImage(context, 1),
        onDoubleTap: () => _captureImage(context, 2),
        onLongPress: () => _captureImage(context, 3),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(cameraController!),
        ),
      ),
    );
  }
}
