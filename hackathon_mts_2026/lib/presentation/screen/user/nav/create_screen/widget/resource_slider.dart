import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/animated_card.dart';

class ResourceSlider extends StatelessWidget {
  const ResourceSlider({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.icon,
    required this.color,
    required this.unit,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final IconData icon;
  final Color color;
  final String unit;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final currentIndex = options.indexOf(value);

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withAlpha((255 * 0.3).toInt()),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  " $unit",
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: color,
                inactiveTrackColor: color.withAlpha((255 * 0.2).toInt()),
                thumbColor: color,
                overlayColor: color.withAlpha((255 * 0.2).toInt()),
              ),
              child: Slider(
                value: currentIndex.toDouble(),
                min: 0,
                max: (options.length - 1).toDouble(),
                divisions: options.length - 1,
                onChanged: (v) => onChanged(options[v.round()]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
