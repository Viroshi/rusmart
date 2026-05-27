import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/pattern_background.dart';
import '../auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: Stack(
          children: [
            const Positioned(
              top: 110,
              left: 34,
              child: FloatingBackgroundIcon(
                icon: Icons.school_rounded,
                color: AppColors.primary,
                size: 58,
                opacity: 0.10,
                rotation: -0.25,
              ),
            ),

            const Positioned(
              top: 150,
              right: 46,
              child: FloatingBackgroundIcon(
                icon: Icons.restaurant_rounded,
                color: AppColors.secondary,
                size: 52,
                opacity: 0.10,
                rotation: 0.25,
              ),
            ),

            const Positioned(
              bottom: 210,
              left: 52,
              child: FloatingBackgroundIcon(
                icon: Icons.menu_book_rounded,
                color: AppColors.primary,
                size: 54,
                opacity: 0.10,
                rotation: 0.18,
              ),
            ),

            const Positioned(
              bottom: 160,
              right: 38,
              child: FloatingBackgroundIcon(
                icon: Icons.local_dining_rounded,
                color: AppColors.secondary,
                size: 60,
                opacity: 0.10,
                rotation: -0.35,
              ),
            ),

            const Positioned(
              top: 310,
              left: 18,
              child: FloatingBackgroundIcon(
                icon: Icons.science_rounded,
                color: AppColors.primary,
                size: 40,
                opacity: 0.05,
              ),
            ),

            const Positioned(
              top: 390,
              right: 18,
              child: FloatingBackgroundIcon(
                icon: Icons.eco_rounded,
                color: AppColors.secondary,
                size: 42,
                opacity: 0.05,
              ),
            ),

            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 390,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LogoBox(),

                        SizedBox(height: 24),

                        Text(
                          'RU Smart',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 48,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Restaurante Universitário inteligente',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 32),

                        LoadingDots(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingBackgroundIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double opacity;
  final double rotation;

  const FloatingBackgroundIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    required this.opacity,
    this.rotation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Opacity(
        opacity: opacity,
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}

class LogoBox extends StatelessWidget {
  const LogoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            color: AppColors.primaryFixedDim.withOpacity(0.20),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFixedDim.withOpacity(0.35),
                blurRadius: 42,
                spreadRadius: 18,
              ),
            ],
          ),
        ),
        const AppLogo(
          size: 165,
          circular: false,
        ),
      ],
    );
  }
}

class LoadingDots extends StatelessWidget {
  const LoadingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedDot(delay: 0),
        SizedBox(width: 6),
        AnimatedDot(delay: 200),
        SizedBox(width: 6),
        AnimatedDot(delay: 400),
      ],
    );
  }
}

class AnimatedDot extends StatefulWidget {
  final int delay;

  const AnimatedDot({
    super.key,
    required this.delay,
  });

  @override
  State<AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    opacity = Tween<double>(
      begin: 0.35,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(
      Duration(milliseconds: widget.delay),
      () {
        if (mounted) {
          controller.repeat(reverse: true);
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}