import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/vm_service.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with TickerProviderStateMixin {
  final VmService _vmService = VmService();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  late TabController _tabController;

  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'ВИРТУАЛЬНЫЕ МАШИНЫ',
      'icon': Icons.cloud,
      'color': Colors.orange,
    },
    {'title': 'ПОЛЬЗОВАТЕЛИ', 'icon': Icons.people, 'color': Colors.blue},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с бейджем админа
            Row(
              children: [
                _buildSectionTitle("ПАНЕЛЬ АДМИНИСТРАТОРА"),
                const Spacer(),
                _buildAdminBadge(),
              ],
            ),

            const SizedBox(height: 24),

            // Табы
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.deepOrange.withAlpha(100),
                  width: 1,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.deepOrange.shade200,
                tabs: _tabs
                    .map(
                      (tab) => Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(tab['icon'], size: 18),
                            const SizedBox(width: 8),
                            Text(tab['title']),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Контент вкладок
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedTabIndex == 0
                    ? _buildVmsTab()
                    : _buildUsersTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.deepOrange.withAlpha(150),
              width: 2,
            ),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.deepOrange,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.deepOrange.withAlpha(50), Colors.transparent],
        ),
        border: Border.all(color: Colors.deepOrange, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.admin_panel_settings, color: Colors.deepOrange, size: 16),
          SizedBox(width: 8),
          Text(
            "АДМИН",
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Вкладка с ВМ
  Widget _buildVmsTab() {
    return RefreshIndicator(
      key: _refreshKey,
      color: Colors.deepOrange,
      onRefresh: _refreshList,
      child: FutureBuilder(
        future: _vmService.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<VmModel> data = snapshot.data!;

            // Разделяем на модерацию и активные
            var moderationVms = data.where((vm) => vm.status == 0).toList();
            var activeVms = data.where((vm) => vm.status == 1).toList();

            return ListView(
              children: [
                if (moderationVms.isNotEmpty) ...[
                  _buildCategoryHeader(
                    "НА МОДЕРАЦИИ",
                    Colors.orange,
                    moderationVms.length,
                  ),
                  const SizedBox(height: 12),
                  ...moderationVms
                      .map((vm) => _buildVmCard(vm, isModeration: true))
                      .toList(),
                  const SizedBox(height: 24),
                ],

                if (activeVms.isNotEmpty) ...[
                  _buildCategoryHeader(
                    "АКТИВНЫЕ",
                    Colors.green,
                    activeVms.length,
                  ),
                  const SizedBox(height: 12),
                  ...activeVms
                      .map((vm) => _buildVmCard(vm, isModeration: false))
                      .toList(),
                ],

                if (moderationVms.isEmpty && activeVms.isEmpty) ...[
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, color: Colors.white54, size: 48),
                        SizedBox(height: 16),
                        Text(
                          "Нет виртуальных машин",
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: Colors.white54, size: 64),
                  SizedBox(height: 16),
                  Text(
                    "Нет виртуальных машин",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryHeader(String title, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVmCard(VmModel vm, {required bool isModeration}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isModeration
                ? Colors.orange.withAlpha(30)
                : Colors.green.withAlpha(30),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: isModeration
              ? Colors.orange.withAlpha(100)
              : Colors.green.withAlpha(100),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Иконка
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isModeration
                  ? Colors.orange.withAlpha(50)
                  : Colors.green.withAlpha(50),
            ),
            child: Icon(
              isModeration ? Icons.hourglass_empty : Icons.cloud_done,
              color: isModeration ? Colors.orange : Colors.green,
            ),
          ),
          const SizedBox(width: 16),

          // Информация
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.terminal, color: Colors.white54, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      vm.os,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.memory, color: Colors.white54, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      "${vm.ram} MB",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Кнопка для модерации
          if (isModeration)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.deepOrange, Colors.orange],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await _vmService.buildVm(vm);
                    _refreshList();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Одобрить",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Вкладка с пользователями
  Widget _buildUsersTab() {
    return RefreshIndicator(
      color: Colors.deepOrange,
      onRefresh: _refreshList,
      child: ListView.builder(
        itemCount: 5, // Временные данные
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withAlpha(100), width: 1),
            ),
            child: Row(
              children: [
                // Аватар
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withAlpha(100),
                        Colors.blue.withAlpha(50),
                      ],
                    ),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      "U${index + 1}",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Пользователь ${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "user${index + 1}@example.com",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green.withAlpha(50),
                        ),
                        child: const Text(
                          "Активен",
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                // Кнопки действий
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.deepOrange.shade300,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.block, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Заблокировать"),
                        ],
                      ),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Удалить"),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
