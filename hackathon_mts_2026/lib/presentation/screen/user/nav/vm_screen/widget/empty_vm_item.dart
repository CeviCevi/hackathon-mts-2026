import 'package:flutter/material.dart';

class EmptyVmItem extends StatelessWidget {
  const EmptyVmItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrange.withAlpha((255 * 0.1).toInt()),
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 50,
              color: Colors.deepOrange.shade300,
            ),
          ),

          const SizedBox(height: 24),

          // Заголовок
          Text(
            "Здесь пока пусто",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.deepOrange.shade300,
            ),
          ),

          const SizedBox(height: 12),

          // Описание
          Text(
            "У вас нет виртуальных машин.\nСоздайте первую прямо сейчас!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.deepOrange.shade200.withAlpha((255 * 0.7).toInt()),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
