import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EyesApp());
}

class EyesApp extends StatelessWidget {
  const EyesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyes 训练营',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3AA0FF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
