import 'package:flutter/material.dart';
import 'package:player/PlayerScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayerScreen(
          songPaths: const ['sounds/1.mp3', 'sounds/2.mp3', 'sounds/3.mp3']),
    );
  }
}
