import 'package:flutter/material.dart';
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:hci/components/speak.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<String> names = ["Manmohan", "HCI Prof", "ABC", "XYZ"];
  List<String> numbers = ["+919760921614", "+919790914537", "333", "444"];

  void onTap(int index) {
    speak("You selected ${names[index]}");
  }

  void doubleTap(int index) async {
    String phoneNumber = numbers[index];
    //await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    final call = Uri.parse('tel:$phoneNumber');
    UrlLauncher.launchUrl(call);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(0),
                    onDoubleTap: () => doubleTap(0),
                    child: Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          "Manmohan",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(1),
                    onDoubleTap: () => doubleTap(1),
                    child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'HCI Prof',
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
                    onTap: () => onTap(2),
                    onDoubleTap: () => doubleTap(2),
                    child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'ABC',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(3),
                    onDoubleTap: () => doubleTap(3),
                    child: Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'XYZ',
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
      ),
    );
  }
}
