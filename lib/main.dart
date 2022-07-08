import 'package:chess_ai/View/Board_UI.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Chess"),
          ),
          backgroundColor: Colors.black,
          body: const Center(
            child: BoardUI(),
      ),
    ));
  }
}
