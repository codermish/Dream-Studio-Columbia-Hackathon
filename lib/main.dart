import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const AiVideoTeacherApp());
}

class AiVideoTeacherApp extends StatelessWidget {
  const AiVideoTeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduVision AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4285F4),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF202124),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const LandingPage(),
    );
  }
}