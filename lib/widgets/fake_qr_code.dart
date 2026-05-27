import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class FakeQrCode extends StatelessWidget {
  final double size;

  const FakeQrCode({
    super.key,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _FakeQrCodePainter(),
      ),
    );
  }
}

class _FakeQrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint blackPaint = Paint()
      ..color = AppColors.onSurface
      ..style = PaintingStyle.fill;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double unit = size.width / 25;

    void drawSquare(int x, int y, int sizeInUnits, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(
          x * unit,
          y * unit,
          sizeInUnits * unit,
          sizeInUnits * unit,
        ),
        paint,
      );
    }

    void drawFinderPattern(int x, int y) {
      drawSquare(x, y, 7, blackPaint);
      drawSquare(x + 1, y + 1, 5, whitePaint);
      drawSquare(x + 2, y + 2, 3, blackPaint);
    }

    drawFinderPattern(0, 0);
    drawFinderPattern(18, 0);
    drawFinderPattern(0, 18);

    for (int row = 0; row < 25; row++) {
      for (int col = 0; col < 25; col++) {
        final bool insideTopLeft = col < 8 && row < 8;
        final bool insideTopRight = col > 16 && row < 8;
        final bool insideBottomLeft = col < 8 && row > 16;

        if (insideTopLeft || insideTopRight || insideBottomLeft) {
          continue;
        }

        final bool shouldPaint =
            ((row * col + row + col * 3) % 5 == 0) ||
            ((row + col) % 7 == 0) ||
            ((row * 2 + col) % 11 == 0);

        if (shouldPaint) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * unit + unit * 0.12,
              row * unit + unit * 0.12,
              unit * 0.76,
              unit * 0.76,
            ),
            blackPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}