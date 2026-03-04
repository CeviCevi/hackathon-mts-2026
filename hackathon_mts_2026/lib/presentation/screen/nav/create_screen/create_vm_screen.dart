import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/create_screen/widget/animated_card.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/create_screen/widget/input_label.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/create_screen/widget/resource_slider.dart';
import 'package:hackathon_mts_2026/presentation/screen/nav/create_screen/widget/selection_title.dart';
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
      'ram': '10000',
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
          SelectionTitle(title: "БЫСТРЫЙ СТАРТ"),
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
                      SelectionTitle(title: "ОСНОВНЫЕ НАСТРОЙКИ"),
                      const SizedBox(height: 16),

                      // Имя машины с эффектом и кнопкой генерации
                      AnimatedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InputLabel(
                                  label: "ИМЯ МАШИНЫ",
                                  icon: Icons.computer,
                                ),
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
                      AnimatedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputLabel(
                              label: "ОПЕРАЦИОННАЯ СИСТЕМА",
                              icon: Icons.construction_outlined,
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
                      AnimatedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputLabel(label: "ПАРОЛЬ", icon: Icons.lock),
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
                      SelectionTitle(title: "РЕСУРСЫ"),
                      const SizedBox(height: 20),

                      // RAM
                      ResourceSlider(
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

                      const SizedBox(height: 21),

                      // ROM
                      ResourceSlider(
                        label: "ROM",
                        value: _selectedRom,
                        options: _romOptions,
                        icon: Icons.storage,
                        color: Colors.green,
                        unit: "MB",
                        onChanged: (v) {
                          setState(() {
                            _selectedRom = v;
                          });
                          _checkPresetMatch();
                          _generateDefaultName();
                        },
                      ),

                      const SizedBox(height: 21),

                      // CPU
                      ResourceSlider(
                        label: "CPU",
                        value: _selectedCors,
                        options: _corsOptions,
                        icon: Icons.speed,
                        color: Color.fromARGB(255, 255, 18, 1),
                        unit: "ядер",
                        onChanged: (v) {
                          setState(() {
                            _selectedCors = v;
                          });
                          _checkPresetMatch();
                          _generateDefaultName();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Кнопки действий
          Align(
            alignment: .centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _createVm,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.deepOrange.withAlpha(50),
                  borderRadius: .circular(16),
                  child: Container(
                    padding: const .symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      //color: Colors.transparent,
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.withAlpha(50),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: .circular(16),
                      border: Border.all(color: Colors.deepOrange, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        "Продолжить",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  final List<String> _ramOptions = ['1024', '2048', '4096', '8192', '10000'];
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
    //Navigator.pop(context);
  }
}
