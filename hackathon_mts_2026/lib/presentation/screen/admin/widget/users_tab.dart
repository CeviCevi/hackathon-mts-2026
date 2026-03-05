import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/auth_service.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/animated_card.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с декоративной линией
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "УПРАВЛЕНИЕ ПОЛЬЗОВАТЕЛЯМИ",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepOrange.withAlpha(30),
                  border: Border.all(color: Colors.deepOrange.withAlpha(100)),
                ),
                child: FutureBuilder(
                  future: AuthService().getAllUsers(),
                  builder: (context, snapshot) {
                    return Text(
                      "Всего: ${snapshot.data?.length ?? 0}",
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Статистика
          Row(
            children: [
              _buildStatCard("Активные", "12", Icons.person, Colors.green),
              const SizedBox(width: 12),
              _buildStatCard("Заблокированы", "3", Icons.block, Colors.red),
              const SizedBox(width: 12),
              _buildStatCard("Новые", "5", Icons.fiber_new, Colors.orange),
            ],
          ),

          const SizedBox(height: 20),

          // Поле поиска
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.deepOrange.withAlpha(100)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.deepOrange, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Поиск пользователей...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Список пользователей
          Expanded(
            child: FutureBuilder(
              future: AuthService().getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedCard(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.deepOrange.withAlpha(30),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.deepOrange
                                        .withAlpha(50),
                                    child: Text(
                                      user.login[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                user.login,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green.withAlpha(30),
                                      border: Border.all(
                                        color: Colors.green.withAlpha(100),
                                      ),
                                    ),
                                    child: const Text(
                                      "Активен",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "ID: ${user.id}",
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(100),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.deepOrange.shade300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.block,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text("Заблокировать"),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text("Удалить"),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: Colors.white54,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Пользователи не найдены",
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(100)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withAlpha(30), Colors.transparent],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha(150),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
