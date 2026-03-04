import 'dart:ui';

import 'package:flutter/material.dart';

class NavigationLeftBar extends StatelessWidget {
  const NavigationLeftBar({super.key, required this.size});

  final Size size;

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
            width: size.width / 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.9),
                  const Color.fromARGB(255, 20, 10, 5),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const NavigationItem(
                  text: "Мои машины",
                  icon: Icons.directions_car,
                ),
                _buildDivider(),
                const NavigationItem(
                  text: "Арендовать машину",
                  icon: Icons.add_circle_outline,
                ),
                _buildDivider(),
                const NavigationItem(text: "История", icon: Icons.history),
                _buildDivider(),
                const NavigationItem(text: "Настройки", icon: Icons.settings),
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
              Colors.deepOrange.withOpacity(0.3),
              Colors.deepOrange.withOpacity(0.5),
              Colors.deepOrange.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const NavigationItem({
    super.key,
    required this.text,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  State<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: _isHovered
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.deepOrange.withOpacity(0.2),
                      Colors.deepOrange.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  )
                : null,
            border: _isHovered
                ? Border.all(
                    color: Colors.deepOrange.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              // Иконка с эффектом свечения
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.deepOrange.withOpacity(_isHovered ? 0.3 : 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered
                      ? Colors.deepOrange.shade300
                      : Colors.deepOrange.shade200.withOpacity(0.8),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Текст с анимацией
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: _isHovered
                        ? Colors.deepOrange.shade300
                        : Colors.deepOrange.shade200.withOpacity(0.8),
                    fontSize: _isHovered ? 17 : 16,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.5,
                    shadows: _isHovered
                        ? [
                            Shadow(
                              color: Colors.deepOrange.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(widget.text),
                ),
              ),

              // Индикатор активного пункта (можно добавить логику)
              if (_isHovered)
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.deepOrange, Colors.orange],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Альтернативный вариант с анимированной подсветкой
class GlowingNavigationItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const GlowingNavigationItem({
    super.key,
    required this.text,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.deepOrange.withOpacity(0.2),
          highlightColor: Colors.deepOrange.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Colors.deepOrange.withOpacity(0.5),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Colors.deepOrange.shade400
                      : Colors.deepOrange.shade200.withOpacity(0.8),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.deepOrange.shade400
                          : Colors.deepOrange.shade200.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
