import 'package:flutter/material.dart';
import 'package:movie_nti_aug/Screen/Spalshscreen.dart';
import 'package:movie_nti_aug/Screen/detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}