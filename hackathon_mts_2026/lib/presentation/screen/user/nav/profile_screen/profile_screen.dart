import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_mts_2026/domain/fish/db.dart';
import 'package:hackathon_mts_2026/presentation/screen/auth/auth_screen/auth_screen.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/animated_card.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/input_label.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/selection_title.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isPasswordVisible = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label скопирован"),
        backgroundColor: Colors.deepOrange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок как в CreateVmScreen
          SelectionTitle(title: "ЛИЧНЫЙ КАБИНЕТ"),
          const SizedBox(height: 24),

          // Аватар как AnimatedCard
          Center(
            child: AnimatedCard(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
                      Colors.deepOrange.withAlpha((255 * 0.1).toInt()),
                    ],
                  ),
                  border: Border.all(color: Colors.deepOrange, width: 2),
                ),
                child: Center(
                  child: Text(
                    userInSystem.login[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Карточка с логином как в CreateVmScreen
          AnimatedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputLabel(label: "ЛОГИН", icon: Icons.person),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    userInSystem.login,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Карточка с паролем как в CreateVmScreen
          AnimatedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InputLabel(label: "ПАРОЛЬ", icon: Icons.lock),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.deepOrange.shade300,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: Colors.deepOrange.shade300,
                        size: 16,
                      ),
                      onPressed: () =>
                          _copyToClipboard(userInSystem.password, "Пароль"),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepOrange.withAlpha((255 * 0.3).toInt()),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _isPasswordVisible ? userInSystem.password : "••••••••••••",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: _isPasswordVisible ? 0 : 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ID пользователя дополнительно
          AnimatedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputLabel(label: "ID ПОЛЬЗОВАТЕЛЯ", icon: Icons.numbers),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withAlpha((255 * 0.3).toInt()),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "${userInSystem.id}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // Кнопка выхода как в CreateVmScreen
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.deepOrange.withAlpha(50),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.withAlpha(50),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepOrange, width: 1.5),
                    ),
                    child: const Center(
                      child: Text(
                        "Выйти",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
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
}
