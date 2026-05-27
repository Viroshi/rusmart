import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'pages/splash/splash_page.dart';

void main() {
  runApp(const RuSmartApp());
}

class RuSmartApp extends StatelessWidget {
  const RuSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RU Smart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}