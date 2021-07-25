import 'package:audify/views/screens/home_screen.dart';
import 'package:flutter/material.dart';

// The main function runs the whole application
void main() {
  runApp(Audify());
}

// This class encompasses the entire app. ie. It's the starting point of the app. It's w started by the main function
class Audify extends StatefulWidget {
  const Audify({Key? key}) : super(key: key);

  @override
  _AudifyState createState() => _AudifyState();
}

class _AudifyState extends State<Audify> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This sets the screen to show when the app is opened
      home: HomeScreen(),
    );
  }
}
