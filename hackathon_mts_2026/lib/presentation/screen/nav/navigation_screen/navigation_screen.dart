import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/navigation_screen/widget/navigation_left_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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

          Positioned(
            left: 30,
            top: 30,
            bottom: 30,
            child: NavigationLeftBar(size: size),
          ),
        ],
      ),
    );
  }
}
