import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class PatternBackground extends StatelessWidget {
  final Widget? child;

  const PatternBackground({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PatternPainter(),
      child: SizedBox.expand(
        child: child,
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = AppColors.background;

    canvas.drawRect(
      Offset.zero & size,
      backgroundPaint,
    );

    final dotPaint = Paint()
      ..color = AppColors.surfaceDim.withOpacity(0.75);

    const double spacing = 20;
    const double radius = 1;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          radius,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}