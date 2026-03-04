import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/create_screen/create_vm_screen.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/navigation_screen/widget/navigation_left_bar.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/vm_screen/vm_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> pages = [
    VmScreen(),
    CreateVmScreen(),
    Scaffold(),
    Scaffold(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage("mars.jpg"),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),

          // Основной контент
          Positioned(
            left: 30,
            top: 30,
            bottom: 30,
            right: 30,
            child: Row(
              children: [
                // Левая навигационная панель
                NavigationLeftBar(
                  size: size,
                  onItemTapped: _onItemTapped,
                  initialIndex: _selectedIndex,
                ),

                const SizedBox(width: 30),

                // Рабочая область (правая панель)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha((255 * 0.4).toInt()),
                          ),
                          child: pages[_selectedIndex],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
