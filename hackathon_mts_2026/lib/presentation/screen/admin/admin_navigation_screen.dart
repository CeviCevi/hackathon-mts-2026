import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/router_service.dart';
import 'package:hackathon_mts_2026/presentation/screen/admin/widget/users_tab.dart';
import 'package:hackathon_mts_2026/presentation/screen/admin/widget/vm_tab.dart';
import 'package:hackathon_mts_2026/presentation/screen/auth/auth_screen/auth_screen.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/selection_title.dart';

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _pulseController;
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'ВИРТУАЛЬНЫЕ МАШИНЫ', 'icon': Icons.cloud_queue, 'count': 3},
    {'title': 'ПОЛЬЗОВАТЕЛИ', 'icon': Icons.people, 'count': 12},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                SelectionTitle(title: "АДМИНИСТРИРОВАНИЕ"),
                const Spacer(),
                _buildAdminBadge(),
              ],
            ),

            const SizedBox(height: 24),

            // Табы в стиле пресетов из CreateVmScreen
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  return _buildTabCard(index);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Контент вкладок
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _getTabContent(_selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabCard(int index) {
    final isSelected = _selectedIndex == index;
    final tab = _tabs[index];

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 300,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
        child: Row(
          children: [
            Icon(
              tab['icon'],
              color: isSelected
                  ? Colors.deepOrange
                  : Colors.deepOrange.shade300,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tab['title'],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.deepOrange
                          : Colors.deepOrange.shade300,
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (tab['count'] != null)
                    Text(
                      "${tab['count']} элементов",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.deepOrange.shade200
                            : Colors.deepOrange.shade200.withAlpha(
                                (255 * 0.7).toInt(),
                              ),
                        fontSize: 8,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminBadge() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange.withAlpha((255 * 0.2).toInt()),
                Colors.deepOrange.withAlpha((255 * 0.1).toInt()),
              ],
            ),
            border: Border.all(
              color: Colors.deepOrange.withAlpha((255 * 0.5).toInt()),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
                blurRadius: 10 + _pulseController.value * 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.security, color: Colors.deepOrange, size: 16),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => RouterService.routeCloseAll(context, AuthScreen()),
                child: const Text(
                  "АДМИНИСТРАТОР",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return const VmsTab();
      case 1:
        return const UsersTab();
      default:
        return const VmsTab();
    }
  }
}
