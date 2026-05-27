import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../widgets/app_logo.dart';
import '../admin/admin_dashboard_page.dart';
import '../auth/login_page.dart';
import '../student/student_home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    verificarLogin();
  }

  Future<void> verificarLogin() async {
    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    final firebaseUser = AuthService().currentUser;

    if (!mounted) return;

    if (firebaseUser == null) {
      abrirLogin();
      return;
    }

    try {
      final appUser = await UserService().getUserProfile(firebaseUser.uid);

      if (!mounted) return;

      if (appUser == null) {
        await AuthService().signOut();
        abrirLogin();
        return;
      }

      if (appUser.isAdmin) {
        abrirGestao();
        return;
      }

      abrirAluno();
    } catch (_) {
      if (!mounted) return;

      await AuthService().signOut();
      abrirLogin();
    }
  }

  void abrirLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  void abrirAluno() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentHomePage(),
      ),
    );
  }

  void abrirGestao() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminDashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(size: 110),
              SizedBox(height: 20),
              Text(
                'RU Smart',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Carregando seu acesso...',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 28),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}