import 'package:flutter/material.dart';
import 'package:hci/components/speak.dart';
import 'package:hci/screen/camera_page.dart';
import 'package:hci/screen/quick_menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = "Hi this is the home page";
  final PageController _pageController = PageController(initialPage: 1);

  void _handleOnTap() {
    speak("Swipe Right to Access Camera Page and Left to Access Quick Menu");
  }

  void _announcePage(int page) {
    switch (page) {
      case 0:
        speak("Camera Page");
        break;
      case 1:
        speak("Home Page");
        break;
      case 2:
        speak("Quick Menu Page");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          _announcePage(page);
        },
        children: [
          const CameraPage(),
          GestureDetector(
            onTap: _handleOnTap,
            child: Container(
                child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'images/vit.png', 
                    height: 300, 
                    fit: BoxFit.fitWidth, 
                  ),
                  const Text.rich(
                    TextSpan(
                      text:
                          "Human Computer Interaction Project\n\n", 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold, 
                        fontFamily: 'Arial', 
                      ),
                      children: [
                        TextSpan(
                          text: "Submitted by:\n\n",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w600, 
                          ),
                        ),
                        TextSpan(
                          text: "Piyush Kumar Patro (22MIS0041)\n",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic, 
                            color: Colors.blueAccent, 
                          ),
                        ),
                        TextSpan(
                          text: "Ssri Harini A K (22MIS0341)\n",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors
                                .blueAccent, 
                          ),
                        ),
                        TextSpan(
                          text: "Kaviya G (22MIS0375)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueAccent, 
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center, 
                  ),
                ],
              ),
            )),
          ),
          const QuickMenuPage(),
        ],
      ),
    );
  }
}
