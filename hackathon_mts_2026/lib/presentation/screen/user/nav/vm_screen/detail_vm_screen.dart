import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';

class VmDetailScreen extends StatefulWidget {
  const VmDetailScreen({super.key, this.back, required this.vm});
  final VoidCallback? back;
  final VmModel vm;

  @override
  State<VmDetailScreen> createState() => _VmDetailScreenState();
}

class _VmDetailScreenState extends State<VmDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isPasswordVisible = false;
  bool _isSshVisible = false;
  bool _isVmActive = false;
  late final VmModel vm;

  @override
  void initState() {
    super.initState();
    vm = widget.vm;
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _isVmActive = vm.status == 1;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label скопирован в буфер обмена"),
        backgroundColor: Colors.deepOrange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleVmPower() {
    if (vm.status == 0) return; // Нельзя управлять на модерации

    setState(() {
      _isVmActive = !_isVmActive;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isVmActive
              ? "ВМ '${vm.name}' запускается..."
              : "ВМ '${vm.name}' останавливается...",
        ),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  // Проверка доступности действий
  bool get _isModeration => vm.status == 0;
  bool get _canInteract => !_isModeration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildControlBlock(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildLeftColumn()),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: _buildRightColumn()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.back,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.deepOrange.shade300,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            vm.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlBlock() {
    // Определяем статус
    String statusText;
    Color statusColor;
    IconData? statusIcon;

    if (_isModeration) {
      statusText = "НА МОДЕРАЦИИ";
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
    } else if (_isVmActive) {
      statusText = "ЗАПУЩЕНА";
      statusColor = Colors.green;
      statusIcon = Icons.play_circle;
    } else {
      statusText = "ОСТАНОВЛЕНА";
      statusColor = Colors.grey;
      statusIcon = Icons.stop_circle;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withAlpha((255 * 0.15).toInt()),
            statusColor.withAlpha((255 * 0.05).toInt()),
          ],
        ),
        border: Border.all(
          color: statusColor.withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Статус и информация
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ТЕКУЩИЙ СТАТУС",
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    const SizedBox(width: 4),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withAlpha((255 * 0.5).toInt()),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                if (_isModeration) ...[
                  const SizedBox(height: 8),
                  Text(
                    "ВМ проходит проверку. Управление недоступно",
                    style: TextStyle(
                      color: Colors.white.withAlpha((255 * 0.5).toInt()),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Кнопка управления (только если не на модерации)
          if (_canInteract) _buildPowerButton(),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("ОСНОВНАЯ ИНФОРМАЦИЯ"),
          const SizedBox(height: 16),

          // Операционная система
          _buildInfoCard(
            icon: Icons.terminal,
            label: "Операционная система",
            value: vm.os,
            color: Colors.orange,
          ),

          const SizedBox(height: 12),

          _buildSectionTitle("БЕЗОПАСНОСТЬ"),
          const SizedBox(height: 16),

          // Пароль (всегда доступен для просмотра)
          _buildPasswordCard(),

          const SizedBox(height: 12),

          // SSH ключ (если есть) - всегда доступен для просмотра
          if (vm.idSsh != 0) _buildSshCard(),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("РЕСУРСЫ"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              // RAM
              _buildResourceCard(
                icon: Icons.memory,
                label: "RAM",
                value: "${vm.ram} MB",
                color: Colors.blue,
              ),

              const SizedBox(height: 12),

              // ROM
              _buildResourceCard(
                icon: Icons.storage,
                label: "ROM",
                value: "${vm.rom} GB",
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              // CPU
              _buildResourceCard(
                icon: Icons.speed,
                label: "CPU",
                value: "${vm.cors} ядер",
                color: const Color.fromARGB(255, 255, 18, 1),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSectionTitle("ДЕЙСТВИЯ"),
          const SizedBox(height: 16),

          // Перезагрузка (доступна только если не на модерации)
          _buildActionButton(
            icon: Icons.refresh,
            label: "Перезагрузить",
            color: Colors.orange,
            enabled: _canInteract,
            onPressed: _canInteract
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("ВМ '${vm.name}' перезагружается..."),
                        backgroundColor: Colors.deepOrange,
                      ),
                    );
                  }
                : null,
          ),

          const SizedBox(height: 12),

          // Удаление (доступно всегда, но с подтверждением)
          _buildActionButton(
            icon: Icons.delete_outline,
            label: "Удалить ВМ",
            color: Colors.red,
            enabled: true,
            onPressed: () => _showDeleteDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.deepOrange.withAlpha((255 * 0.5).toInt()),
              width: 2,
            ),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.deepOrange.shade200,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withAlpha((255 * 0.1).toInt()), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withAlpha((255 * 0.15).toInt()),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withAlpha((255 * 0.5).toInt()),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withAlpha((255 * 0.5).toInt()),
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withAlpha((255 * 0.1).toInt()),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple.withAlpha((255 * 0.15).toInt()),
                ),
                child: const Icon(Icons.lock, color: Colors.purple, size: 16),
              ),
              const SizedBox(width: 12),
              const Text(
                "Пароль",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.purple.shade300,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.purple.shade300, size: 18),
                onPressed: () => _copyToClipboard(vm.password, "Пароль"),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple.withAlpha((255 * 0.05).toInt()),
              border: Border.all(
                color: Colors.purple.withAlpha((255 * 0.2).toInt()),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isPasswordVisible ? vm.password : "••••••••••••",
                    style: TextStyle(
                      color: _isPasswordVisible
                          ? Colors.purple.shade200
                          : Colors.white.withAlpha((255 * 0.7).toInt()),
                      fontSize: 14,
                      fontFamily: _isPasswordVisible ? null : 'monospace',
                      letterSpacing: 2,
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

  Widget _buildSshCard() {
    //TODO
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.cyan.withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.withAlpha((255 * 0.1).toInt()),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.cyan.withAlpha((255 * 0.15).toInt()),
                ),
                child: const Icon(Icons.vpn_key, color: Colors.cyan, size: 16),
              ),
              const SizedBox(width: 12),
              const Text(
                "SSH подключение",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _isSshVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.cyan.shade300,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _isSshVisible = !_isSshVisible;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.cyan.shade300, size: 18),
                onPressed: () => _copyToClipboard(
                  "ssh user@${vm.name}.local",
                  "SSH команда",
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyan.withAlpha((255 * 0.05).toInt()),
              border: Border.all(
                color: Colors.cyan.withAlpha((255 * 0.2).toInt()),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isSshVisible
                        ? "ssh user@${vm.name}.local"
                        : "••••••••••••",
                    style: TextStyle(
                      color: _isSshVisible
                          ? Colors.cyan.shade200
                          : Colors.white.withAlpha((255 * 0.7).toInt()),
                      fontSize: 14,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _canInteract ? _toggleVmPower : null,
          child: Opacity(
            opacity: _canInteract ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: _isVmActive
                      ? [Colors.red.shade700, Colors.red.shade900]
                      : [Colors.green.shade600, Colors.green.shade800],
                ),
                boxShadow: _canInteract
                    ? [
                        BoxShadow(
                          color: (_isVmActive ? Colors.red : Colors.green)
                              .withAlpha((255 * 0.5).toInt()),
                          blurRadius: 15 + _pulseController.value * 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isVmActive ? Icons.power_off : Icons.power_settings_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required VoidCallback? onPressed,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withAlpha((255 * 0.5).toInt()),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [color.withAlpha((255 * 0.1).toInt()), Colors.transparent],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha((255 * 0.8).toInt()),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            border: Border.all(
              color: Colors.red.withAlpha((255 * 0.3).toInt()),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha((255 * 0.2).toInt()),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "УДАЛЕНИЕ ВМ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Вы уверены, что хотите удалить ВМ '${vm.name}'?\nЭто действие нельзя отменить.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha((255 * 0.7).toInt()),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepOrange.shade200,
                        side: BorderSide(
                          color: Colors.deepOrange.withAlpha(
                            (255 * 0.5).toInt(),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("ОТМЕНА"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.orange],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withAlpha((255 * 0.3).toInt()),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("ВМ '${vm.name}' удалена"),
                              backgroundColor: Colors.deepOrange,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("УДАЛИТЬ"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
