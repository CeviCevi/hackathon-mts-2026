import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/auth_service.dart';
import 'package:hackathon_mts_2026/domain/model/user_model.dart';
import 'package:hackathon_mts_2026/presentation/widget/app/text_field/cosmic_text_field.dart';
import 'package:hackathon_mts_2026/presentation/widget/test/test.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key, this.goToLogin});

  final VoidCallback? goToLogin;

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isLoad = false;

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.deepOrange,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Основной контент
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "Регистрация",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 34,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CosmicTextField(controller: _login, hintText: "логин"),
                      CosmicTextField(
                        controller: _password,
                        hintText: "пароль",
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      NeonCosmicButton(
                        onPressed: () async {
                          setState(() => isLoad = true);

                          // Имитация загрузки
                          await Future.delayed(const Duration(seconds: 2));

                          var data = await AuthService().registration(
                            UserModel(
                              id: 0,
                              login: _login.text,
                              password: _password.text,
                            ),
                          );

                          setState(() => isLoad = false);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${data?.id ?? "Null"}")),
                            );
                          }
                        },
                        text: "Продолжить",
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                        onPressed: widget.goToLogin,
                        padding: EdgeInsets.zero,
                        child: Text(
                          "Уже зарегистрирован? Войти",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: 0.5,
                            color: Colors.deepOrange.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Затемнение и крутилка (только поверх плашки)
              if (isLoad)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((255 * 0.5).toInt()),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
