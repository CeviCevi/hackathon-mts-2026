import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/navigation_screen/navigation_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: .dark,
        ),
      ),
      home: NavigationScreen(),
    );
  }
}
