import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';

class VmConfirmationWidget extends StatelessWidget {
  final VmModel vm;

  const VmConfirmationWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const .all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepOrange.withAlpha((255 * 0.1).toInt()),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Предупреждение
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepOrange.withAlpha((255 * 0.15).toInt()),
              border: Border.all(
                color: Colors.deepOrange.withAlpha((255 * 0.5).toInt()),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.deepOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ВНИМАНИЕ!",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "После создания виртуальной машины изменить её параметры (RAM, ROM, CPU) будет невозможно",
                        style: TextStyle(
                          color: Colors.white.withAlpha((255 * 0.9).toInt()),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Заголовок параметров
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "ПАРАМЕТРЫ МАШИНЫ",
                style: TextStyle(
                  color: Colors.deepOrange.shade200,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Сетка с параметрами
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.computer,
                  label: "Имя машины",
                  value: vm.name,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.terminal,
                  label: "ОС",
                  value: vm.os,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.memory,
                  label: "RAM",
                  value: "${vm.ram} MB",
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.storage,
                  label: "ROM",
                  value: "${vm.rom} GB",
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.speed,
                  label: "CPU",
                  value: "${vm.cors} ядер",
                  color: const Color.fromARGB(255, 255, 18, 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.vpn_key,
                  label: "SSH ключ",
                  value: vm.idSsh == 0 ? "Не привязан" : "ID: ${vm.idSsh}",
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha((255 * 0.2).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color.withAlpha((255 * 0.1).toInt()),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withAlpha((255 * 0.5).toInt()),
                    fontSize: 9,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
