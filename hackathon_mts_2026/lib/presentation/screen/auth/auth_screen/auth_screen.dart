import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/auth/login_screen/login_screen.dart';
import 'package:hackathon_mts_2026/presentation/screen/auth/reg_screen/reg_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isReg = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage("mars.jpg"),
                fit: .cover,
                opacity: .5,
              ),
            ),
          ),

          isReg
              ? RegScreen(goToLogin: () => setState(() => isReg = false))
              : LoginScreen(goToReg: () => setState(() => isReg = true)),
        ],
      ),
    );
  }
}
