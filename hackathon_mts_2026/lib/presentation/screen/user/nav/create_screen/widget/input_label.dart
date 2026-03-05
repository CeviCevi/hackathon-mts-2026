import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange.shade300, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.deepOrange.shade200,
          ),
        ),
      ],
    );
  }
}
