import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const AgeCalcApp());
}

class AgeCalcApp extends StatelessWidget {
  const AgeCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const AgeCalculatorScreen(),
    );
  }
}
