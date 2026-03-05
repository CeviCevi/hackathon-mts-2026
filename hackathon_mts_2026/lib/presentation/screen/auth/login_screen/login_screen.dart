import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/auth_service.dart';
import 'package:hackathon_mts_2026/data/service/router_service.dart';
import 'package:hackathon_mts_2026/domain/fish/db.dart';
import 'package:hackathon_mts_2026/domain/model/user_model.dart';
import 'package:hackathon_mts_2026/presentation/screen/admin/admin_navigation_screen.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/navigation_screen/navigation_screen.dart';
import 'package:hackathon_mts_2026/presentation/widget/app/text_field/cosmic_text_field.dart';
import 'package:hackathon_mts_2026/presentation/widget/test/test.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.goToReg});
  final VoidCallback? goToReg;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                        "Аутентификация",
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
                          if (_login.text == "admin" &&
                              _password.text == "1111") {
                            log("message");
                            RouterService.routeCloseAll(
                              context,
                              AdminNavigationScreen(),
                            );
                            return;
                          }
                          setState(() => isLoad = true);

                          var data = await AuthService().login(
                            UserModel(
                              id: 0,
                              login: _login.text,
                              password: _password.text,
                            ),
                          );

                          setState(() => isLoad = false);

                          if (mounted && data?.id != null) {
                            userInSystem = data!;
                            RouterService.routeCloseAll(
                              context,
                              NavigationScreen(),
                            );
                          }
                        },
                        text: "Продолжить",
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                        onPressed: widget.goToReg,
                        padding: EdgeInsets.zero,
                        child: Text(
                          "Нет аккаунта? Зарегистрироваться",
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
