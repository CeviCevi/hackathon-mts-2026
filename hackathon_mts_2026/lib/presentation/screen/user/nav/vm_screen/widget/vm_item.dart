import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';

class VmItem extends StatelessWidget {
  final VmModel vm;
  final VoidCallback? onTap;
  final bool isSelected;

  const VmItem({
    super.key,
    required this.vm,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const .fromLTRB(0, 0, 15, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(
            221,
            31,
            4,
            4,
          ).withAlpha((255 * 0.8).toInt()),
          border: Border.all(
            color: isSelected
                ? Colors.deepOrange.shade400
                : Colors.deepOrange.withAlpha((255 * 0.2).toInt()),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepOrange.withAlpha((255 * 0.2).toInt()),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Левая часть с иконкой
                  _buildLeftSection(),

                  const SizedBox(width: 16),

                  // Правая часть с информацией
                  Expanded(child: _buildInfoSection()),

                  // Стрелка перехода
                  Icon(
                    Icons.chevron_right,
                    color: Colors.deepOrange.shade300.withAlpha(
                      (255 * 0.6).toInt(),
                    ),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Левая секция с иконкой и статусом
  Widget _buildLeftSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Иконка VM
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _getStatusColor().withAlpha((255 * 0.3).toInt()),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStatusColor().withAlpha((255 * 0.5).toInt()),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.desktop_windows_rounded,
                color: _getStatusColor(),
                size: 28,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStatusColor(),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor().withAlpha((255 * 0.5).toInt()),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Статус текстом
        Text(
          _getStatusText(),
          style: TextStyle(
            color: _getStatusColor(),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Правая секция с информацией
  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Имя и ОС
        Row(
          children: [
            Expanded(
              child: Text(
                vm.name,
                style: TextStyle(
                  color: Colors.deepOrange.shade200,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // ОС
        Row(
          children: [
            Icon(
              Icons.window_rounded,
              size: 14,
              color: Colors.deepOrange.shade200.withAlpha((255 * 0.6).toInt()),
            ),
            const SizedBox(width: 4),
            Text(
              vm.os,
              style: TextStyle(
                color: Colors.deepOrange.shade200.withAlpha(
                  (255 * 0.8).toInt(),
                ),
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Характеристики в одну строку
        Row(
          children: [
            _buildSpecChip(
              icon: Icons.memory,
              value: "${vm.ram} MB",
              color: Colors.purpleAccent,
            ),
            const SizedBox(width: 8),
            _buildSpecChip(
              icon: Icons.storage,
              value: "${vm.rom} GB",
              color: Colors.lightGreenAccent,
            ),
            const SizedBox(width: 8),
            _buildSpecChip(
              icon: Icons.speed,
              value: "${vm.cors} vCPU",
              color: Colors.cyanAccent,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Мини-прогресс бары (только для активных)
        if (vm.status == 1) ...[
          Row(
            children: [
              Expanded(
                child: _buildMiniProgress(
                  label: "CPU",
                  value: 0.45,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniProgress(
                  label: "RAM",
                  value: 0.62,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Чип характеристики
  Widget _buildSpecChip({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withAlpha((255 * 0.4).toInt()),
          border: Border.all(
            color: color.withAlpha((255 * 0.3).toInt()),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Мини прогресс
  Widget _buildMiniProgress({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color.withAlpha((255 * 0.7).toInt()),
                fontSize: 9,
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withAlpha((255 * 0.2).toInt()),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  // Навигация на детальный экран

  String _getStatusText() {
    switch (vm.status) {
      case 0:
        return "В модерации";
      case 201:
        return "Активна";
      case 202:
        return "Остановлена";
      case 3:
        return "Запуск";
      default:
        return "Неизвестно";
    }
  }

  Color _getStatusColor() {
    switch (vm.status) {
      case 0:
        return Colors.orange;
      case 201:
        return Colors.green;
      case 202:
        return Colors.grey;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
