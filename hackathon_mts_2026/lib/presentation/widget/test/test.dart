import 'package:flutter/material.dart';

class CosmicOrangeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final double width;
  final double height;
  final bool isOutlined;

  const CosmicOrangeButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 56,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isOutlined ? null : _buildGradient(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isOutlined
            ? null
            : [
                // Оранжевое свечение
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
        border: Border.all(
          color: isOutlined
              ? Colors.deepOrange
              : Colors.deepOrange.shade200.withOpacity(0.5),
          width: isOutlined ? 2 : 1.5,
        ),
      ),
      child: Material(
        color: isOutlined ? Colors.transparent : null,
        borderRadius: .circular(16),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.deepOrange.withOpacity(0.2),
          highlightColor: Colors.deepOrange.withOpacity(0.1),
          hoverColor: Colors.orange.withAlpha(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isOutlined
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                child: isLoading
                    ? _buildLoadingIndicator()
                    : _buildButtonContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _buildGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.deepOrange.shade400,
        Colors.deepOrange.shade700,
        Colors.deepOrange.shade900,
      ],
      stops: const [0.0, 0.6, 1.0],
    );
  }

  Widget _buildButtonContent() {
    final textStyle = TextStyle(
      color: isOutlined ? Colors.deepOrange.shade400 : Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.5,
      shadows: isOutlined
          ? null
          : [
              const Shadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(1, 1),
              ),
            ],
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isOutlined ? Colors.deepOrange.shade400 : Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    } else {
      return Text(text, style: textStyle);
    }
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          isOutlined ? Colors.deepOrange.shade400 : Colors.white,
        ),
        backgroundColor: Colors.deepOrange.withOpacity(0.2),
      ),
    );
  }
}

class NeonCosmicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;

  const NeonCosmicButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<NeonCosmicButton> createState() => _NeonCosmicButtonState();
}

class _NeonCosmicButtonState extends State<NeonCosmicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(_pulseAnimation.value),
                blurRadius: 5,
                spreadRadius: 0,
                blurStyle: .outer,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: child,
        );
      },
      child: CosmicOrangeButton(
        onPressed: widget.onPressed,
        text: widget.text,
        icon: widget.icon,
        isOutlined: true,
        isLoading: widget.isLoading,
      ),
    );
  }
}

class OutlinedCosmicButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;

  const OutlinedCosmicButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CosmicOrangeButton(
      onPressed: onPressed,
      text: text,
      icon: icon,
      isOutlined: true,
    );
  }
}
