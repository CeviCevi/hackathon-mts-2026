import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/widget/app/text_field/cosmic_text_field.dart';

class CreateVmScreen extends StatefulWidget {
  const CreateVmScreen({super.key});

  @override
  State<CreateVmScreen> createState() => _CreateVmScreenState();
}

class _CreateVmScreenState extends State<CreateVmScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _pulseController;

  String _selectedOs = 'Ubuntu 22.04';
  String _selectedRam = '4096';
  String _selectedRom = '20480';
  String _selectedCors = '2';
  String _selectedPreset = 'СТАНДАРТ'; // По умолчанию выбран стандарт

  final List<Map<String, dynamic>> _osOptions = [
    {'name': 'Ubuntu 22.04', 'icon': Icons.terminal, 'color': Colors.orange},
    {'name': 'Ubuntu 20.04', 'icon': Icons.terminal, 'color': Colors.orange},
    {'name': 'Debian 11', 'icon': Icons.terminal, 'color': Colors.red},
    {'name': 'CentOS 8', 'icon': Icons.terminal, 'color': Colors.blue},
    {'name': 'Windows Server', 'icon': Icons.window, 'color': Colors.cyan},
  ];

  final List<Map<String, dynamic>> _presets = [
    {
      'name': 'МИКРО',
      'ram': '1024',
      'rom': '10240',
      'cors': '1',
      'icon': Icons.lens,
    },
    {
      'name': 'СТАНДАРТ',
      'ram': '4096',
      'rom': '20480',
      'cors': '2',
      'icon': Icons.lens,
    },
    {
      'name': 'ПРО',
      'ram': '8192',
      'rom': '40960',
      'cors': '4',
      'icon': Icons.lens,
    },
    {
      'name': 'МЕГА',
      'ram': '16384',
      'rom': '81920',
      'cors': '8',
      'icon': Icons.lens,
    },
    {
      'name': 'КАСТОМ',
      'ram': '4096', // Начальные значения
      'rom': '20480',
      'cors': '2',
      'icon': Icons.tune,
      'isCustom': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Генерируем имя по умолчанию
    _generateDefaultName();
  }

  // Проверка, совпадают ли текущие настройки с каким-либо пресетом
  void _checkPresetMatch() {
    if (_selectedPreset == 'КАСТОМ') return; // Уже в кастоме

    for (var preset in _presets) {
      if (preset['isCustom'] == true) continue; // Пропускаем кастом

      if (preset['ram'] == _selectedRam &&
          preset['rom'] == _selectedRom &&
          preset['cors'] == _selectedCors) {
        // Нашли совпадение
        if (_selectedPreset != preset['name']) {
          setState(() {
            _selectedPreset = preset['name'];
          });
        }
        return;
      }
    }

    // Если не нашли совпадений, переключаем на кастом
    if (_selectedPreset != 'КАСТОМ') {
      setState(() {
        _selectedPreset = 'КАСТОМ';
      });
    }
  }

  void _generateDefaultName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7);
    final osShort = _selectedOs.split(' ').first.toLowerCase();
    final presetShort = _selectedPreset.toLowerCase();
    _nameController.text = "user-$osShort-$presetShort-$timestamp";
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Секция с пресетами
          _buildSectionTitle("БЫСТРЫЙ СТАРТ"),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _presets.length,
              itemBuilder: (context, index) {
                final preset = _presets[index];
                return _buildPresetCard(preset);
              },
            ),
          ),

          const SizedBox(height: 24),

          // Основной контент
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Левая колонка
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("ОСНОВНЫЕ НАСТРОЙКИ"),
                      const SizedBox(height: 16),

                      // Имя машины с эффектом и кнопкой генерации
                      _buildAnimatedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildInputLabel("ИМЯ МАШИНЫ", Icons.computer),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.deepOrange.shade300,
                                    size: 16,
                                  ),
                                  onPressed: _generateDefaultName,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            CosmicTextField(
                              controller: _nameController,
                              hintText: "my-awesome-server",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Выбор ОС в виде карточек
                      _buildAnimatedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel(
                              "ОПЕРАЦИОННАЯ СИСТЕМА",
                              Icons.construction_outlined,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _osOptions.map((os) {
                                return _buildOsChip(os);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Пароль
                      _buildAnimatedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel("ПАРОЛЬ", Icons.lock),
                            const SizedBox(height: 8),
                            CosmicTextField(
                              controller: _passwordController,
                              hintText: "Минимум 6 символов",
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Правая колонка - Ресурсы
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("РЕСУРСЫ"),
                      const SizedBox(height: 16),

                      // RAM
                      _buildResourceSlider(
                        label: "RAM",
                        value: _selectedRam,
                        options: _ramOptions,
                        icon: Icons.memory,
                        color: Colors.blue,
                        unit: "MB",
                        onChanged: (v) {
                          setState(() {
                            _selectedRam = v;
                          });
                          _checkPresetMatch();
                          _generateDefaultName();
                        },
                      ),

                      const SizedBox(height: 16),

                      // ROM
                      _buildResourceSlider(
                        label: "ROM",
                        value: _selectedRom,
                        options: _romOptions,
                        icon: Icons.storage,
                        color: Colors.purple,
                        unit: "MB",
                        onChanged: (v) {
                          setState(() {
                            _selectedRom = v;
                          });
                          _checkPresetMatch();
                          _generateDefaultName();
                        },
                      ),

                      const SizedBox(height: 16),

                      // CPU
                      _buildResourceSlider(
                        label: "CPU",
                        value: _selectedCors,
                        options: _corsOptions,
                        icon: Icons.speed,
                        color: Colors.orange,
                        unit: "ядер",
                        onChanged: (v) {
                          setState(() {
                            _selectedCors = v;
                          });
                          _checkPresetMatch();
                          _generateDefaultName();
                        },
                      ),

                      const SizedBox(height: 16),

                      // Итого
                      _buildAnimatedCard(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.deepOrange.withAlpha(
                                  (255 * 0.15).toInt(),
                                ),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ИТОГО:",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "$_selectedRam MB / $_selectedRom MB / $_selectedCors ядер",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Кнопки действий
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                label: "ТЕСТ",
                icon: Icons.play_arrow,
                isPrimary: false,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                label: "СОЗДАТЬ",
                icon: Icons.add,
                isPrimary: true,
                onPressed: _createVm,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Новые компоненты
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

  Widget _buildPresetCard(Map<String, dynamic> preset) {
    final isSelected = _selectedPreset == preset['name'];
    final isCustom = preset['isCustom'] == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPreset = preset['name'];
          if (!isCustom) {
            _selectedRam = preset['ram'];
            _selectedRom = preset['rom'];
            _selectedCors = preset['cors'];
          }
          _generateDefaultName();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
                    Colors.deepOrange.withAlpha((255 * 0.1).toInt()),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepOrange.withAlpha((255 * 0.1).toInt()),
                    Colors.transparent,
                  ],
                ),
          border: Border.all(
            color: isSelected
                ? Colors.deepOrange
                : Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              preset['icon'],
              color: isSelected
                  ? Colors.deepOrange
                  : Colors.deepOrange.shade300,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              preset['name'],
              style: TextStyle(
                color: isSelected
                    ? Colors.deepOrange
                    : Colors.deepOrange.shade300,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            if (!isCustom) ...[
              Text(
                "${preset['ram']}MB",
                style: TextStyle(
                  color: isSelected
                      ? Colors.deepOrange.shade200
                      : Colors.deepOrange.shade200.withAlpha(
                          (255 * 0.7).toInt(),
                        ),
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  Widget _buildInputLabel(String label, IconData icon) {
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

  Widget _buildOsChip(Map<String, dynamic> os) {
    final isSelected = _selectedOs == os['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOs = os['name'];
          _generateDefaultName();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? (os['color'] as Color).withAlpha((255 * 0.2).toInt())
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? os['color'] as Color
                : Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              os['icon'],
              color: isSelected
                  ? os['color'] as Color
                  : Colors.deepOrange.shade300,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              os['name'],
              style: TextStyle(
                color: isSelected
                    ? os['color'] as Color
                    : Colors.deepOrange.shade200,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceSlider({
    required String label,
    required String value,
    required List<String> options,
    required IconData icon,
    required Color color,
    required String unit,
    required void Function(String) onChanged,
  }) {
    final currentIndex = options.indexOf(value);

    return _buildAnimatedCard(
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

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    if (isPrimary) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Colors.deepOrange, Colors.orange],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.deepOrange,
          side: BorderSide(
            color: Colors.deepOrange.withAlpha((255 * 0.5).toInt()),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }
  }

  final List<String> _ramOptions = ['1024', '2048', '4096', '8192', '16384'];
  final List<String> _romOptions = [
    '10240',
    '20480',
    '40960',
    '81920',
    '163840',
  ];
  final List<String> _corsOptions = ['1', '2', '4', '8', '16'];

  void _createVm() {
    if (_nameController.text.isEmpty) {
      _generateDefaultName();
    }
    // Логика создания
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("ВМ '${_nameController.text}' создана!"),
        backgroundColor: Colors.deepOrange,
      ),
    );
    Navigator.pop(context);
  }
}
