import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/navigation_screen/widget/navigation_item.dart';

class NavigationLeftBar extends StatefulWidget {
  const NavigationLeftBar({super.key, required this.size});

  final Size size;

  @override
  State<NavigationLeftBar> createState() => _NavigationLeftBarState();
}

class _NavigationLeftBarState extends State<NavigationLeftBar> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "Мои машины",
    "Арендовать машину",
    "История",
    "Настройки",
  ];

  final List<IconData> _icons = const [
    Icons.computer_rounded,
    Icons.add_circle_outline,
    Icons.history,
    Icons.settings,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Здесь можно добавить навигацию или другие действия
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.deepOrange,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: widget.size.width / 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha((255 * 0.8).toInt()),
                  Colors.black.withAlpha((255 * 0.9).toInt()),
                  const Color.fromARGB(255, 20, 10, 5),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                ...List.generate(_titles.length, (index) {
                  return Column(
                    children: [
                      if (index > 0) _buildDivider(),
                      NavigationItem(
                        text: _titles[index],
                        icon: _icons[index],
                        isSelected: _selectedIndex == index,
                        onTap: () => _onItemTapped(index),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
              Colors.deepOrange.withAlpha((255 * 0.5).toInt()),
              Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
