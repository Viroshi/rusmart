import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool circular;

  const AppLogo({
    super.key,
    this.size = 96,
    this.circular = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.school_rounded,
        color: AppColors.primary,
        size: size * 0.54,
      ),

      /*
      Quando você tiver o logo real, substitua o Icon por:

      ClipRRect(
        borderRadius: circular
            ? BorderRadius.circular(size)
            : BorderRadius.circular(14),
        child: Image.asset(
          'assets/images/logo_ru_smart.png',
          fit: BoxFit.cover,
        ),
      );

      E adicione no pubspec.yaml:

      flutter:
        assets:
          - assets/images/logo_ru_smart.png
      */
    );
  }
}