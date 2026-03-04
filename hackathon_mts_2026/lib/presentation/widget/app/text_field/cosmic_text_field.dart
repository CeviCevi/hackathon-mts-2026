import 'package:flutter/material.dart';
import 'package:flutter_animate_border/flutter_animate_border.dart';

class CosmicTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onSuffixIconTap;
  final String? initialValue;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool expands;

  const CosmicTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSuffixIconTap,
    this.initialValue,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
  });

  @override
  State<CosmicTextField> createState() => _CosmicTextFieldState();
}

class _CosmicTextFieldState extends State<CosmicTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  late FlutterAnimateBorderController _borderController;
  // ignore: unused_field
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _borderController = FlutterAnimateBorderController(
      loopDuration: const Duration(seconds: 10),
    );

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_focusNode.hasFocus) {
      _borderController.doFreeze = false;
    } else {
      _borderController.doFreeze = true;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Текстовое поле (всегда одно и то же)
        _buildTextField(),

        // Анимированная рамка (поверх поля)
        // if (_isFocused)
        //   Positioned.fill(
        //     child: IgnorePointer(
        //       child: FlutterAnimateBorder(
        //         controller: _borderController,
        //         lineThickness: 2,
        //         lineWidth: 100,
        //         linePadding: 5,
        //         cornerRadius: 16,
        //         gradient: RadialGradient(
        //           radius: 1,
        //           colors: [
        //             Colors.deepOrange.withAlpha(200),
        //             Colors.orange.withAlpha(200),
        //           ],
        //         ),
        //         child: Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      maxLines: widget.expands ? null : widget.maxLines,
      minLines: widget.expands ? null : widget.minLines,
      expands: widget.expands,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
        decorationColor: Colors.transparent,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 0,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: TextStyle(
          color: Colors.deepOrange.shade200,
          fontSize: 14,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
        hintStyle: TextStyle(
          color: Colors.deepOrange.shade200.withAlpha((255 * 0.5).toInt()),
          fontSize: 14,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: Colors.deepOrange.shade300,
                size: 20,
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
        filled: true,
        fillColor: Colors.black.withAlpha((255 * 0.7).toInt()),
        focusColor: Colors.black.withAlpha((255 * 1).toInt()),
        hoverColor: Colors.black.withAlpha((255 * 0.2).toInt()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.deepOrange.shade400.withAlpha((255 * 0.5).toInt()),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.deepOrange.shade400.withAlpha((255 * 0.3).toInt()),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.deepOrange.shade400.withAlpha((255 * 0.1).toInt()),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        errorStyle: TextStyle(
          color: Colors.red.shade300,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        isDense: true,
      ),
      cursorColor: Colors.deepOrange.shade400,
      cursorWidth: 2,
      cursorRadius: const Radius.circular(2),
    );
  }

  Widget? _buildSuffixIcon() {
    // Если есть кастомный suffixIcon и это не поле пароля
    if (widget.suffixIcon != null && !widget.obscureText) {
      return GestureDetector(
        onTap: widget.onSuffixIconTap,
        child: Icon(
          widget.suffixIcon,
          color: Colors.deepOrange.shade300,
          size: 20,
        ),
      );
    }

    // Если это поле пароля (obscureText = true)
    if (widget.obscureText) {
      return GestureDetector(
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.deepOrange.shade300,
          size: 20,
        ),
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return null;
  }
}
