import 'package:flutter/material.dart';
import 'package:hackathon_mts_2026/data/service/vm_service.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';
import 'package:hackathon_mts_2026/presentation/screen/user/nav/create_screen/widget/popup_text.dart';

void showCosmicDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonText,
  required VoidCallback onButtonPressed,
  required VmModel vm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha((255 * 0.8).toInt()),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: .symmetric(horizontal: 330),
        height: .maxFinite,
        decoration: BoxDecoration(
          borderRadius: .circular(16),
          color: Colors.transparent,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withAlpha((255 * 0.8).toInt()),
              Colors.black.withAlpha((255 * 0.9).toInt()),
              const Color.fromARGB(255, 20, 10, 5),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withAlpha((255 * 0.0).toInt()),
              blurRadius: 16,
              blurStyle: .outer,
            ),
          ],
        ),
        child: BackdropFilter(
          filter: .blur(sigmaX: 10, sigmaY: 10),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: .center,
              children: [
                VmConfirmationWidget(vm: vm),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: .spaceAround,
                  children: [
                    _button(context, "Отмена", () => Navigator.pop(context)),
                    _button(context, "Продолжить", () {
                      VmService().create(vm);
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

SizedBox _button(BuildContext context, String text, VoidCallback function) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 6,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: function,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.deepOrange.withAlpha(50),
        borderRadius: .circular(16),
        child: Container(
          padding: const .symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            //color: Colors.transparent,
            gradient: LinearGradient(
              colors: [Colors.deepOrange.withAlpha(50), Colors.transparent],
            ),
            borderRadius: .circular(16),
            border: Border.all(color: Colors.deepOrange, width: 1.5),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.deepOrange, fontWeight: .w600),
            ),
          ),
        ),
      ),
    ),
  );
}
