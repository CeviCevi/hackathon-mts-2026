import 'package:flutter/material.dart';

class NavigationItem extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;

  const NavigationItem({
    super.key,
    required this.text,
    required this.icon,
    this.color,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isSelected || _isHovered;

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
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.deepOrange.withAlpha(
                        (255 * (widget.isSelected ? 0.3 : 0.2)).toInt(),
                      ),
                      Colors.deepOrange.withAlpha(
                        (255 * (widget.isSelected ? 0.2 : 0.1)).toInt(),
                      ),
                      Colors.transparent,
                    ],
                  )
                : null,
            border: isActive
                ? Border.all(
                    color: Colors.deepOrange.withAlpha(
                      (255 * (widget.isSelected ? 0.5 : 0.3)).toInt(),
                    ),
                    width: widget.isSelected ? 1.5 : 1,
                  )
                : null,
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  // Иконка с эффектом свечения
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.deepOrange.withAlpha(
                            (255 * (isActive ? 0.3 : 0.1)).toInt(),
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      color: isActive
                          ? (widget.isSelected
                                ? Colors.deepOrange.shade400
                                : Colors.deepOrange.shade300)
                          : Colors.deepOrange.shade200.withAlpha(
                              (255 * 0.8).toInt(),
                            ),
                      size: widget.isSelected ? 26 : 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Текст с анимацией
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isActive
                            ? (widget.isSelected
                                  ? Colors.deepOrange.shade400
                                  : Colors.deepOrange.shade300)
                            : Colors.deepOrange.shade200.withAlpha(
                                (255 * 0.8).toInt(),
                              ),
                        fontSize: isActive ? 17 : 16,
                        fontWeight: widget.isSelected
                            ? FontWeight.w700
                            : (isActive ? FontWeight.w600 : FontWeight.w500),
                        letterSpacing: 0.5,
                        shadows: isActive
                            ? [
                                Shadow(
                                  color: Colors.deepOrange.withAlpha(
                                    (255 * (widget.isSelected ? 0.7 : 0.5))
                                        .toInt(),
                                  ),
                                  blurRadius: widget.isSelected ? 15 : 10,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(widget.text),
                    ),
                  ),
                ],
              ),

              // Индикатор выбранного пункта (СПРАВА)
              if (widget.isSelected)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.deepOrange, Colors.orange],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withAlpha(
                            (255 * 0.5).toInt(),
                          ),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),

              // Индикатор наведения (слева)
              if (_isHovered && !widget.isSelected)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
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
