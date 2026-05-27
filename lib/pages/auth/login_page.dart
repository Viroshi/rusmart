import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import '../../core/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_logo.dart';
import '../admin/admin_login_page.dart';
import '../onboarding/onboarding_page.dart';
import '../student/student_home_page.dart';
import '../../services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool esconderSenha = true;
  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrarNoApp() async {
    final String email = emailController.text.trim();
    final String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      mostrarMensagem('Preencha o e-mail e a senha.');
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      final credential = await authService.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = credential.user;

      if (user == null) {
        mostrarMensagem('Não foi possível acessar o usuário.');
        return;
      }

      await UserService().ensureStudentProfileExists(
        uid: user.uid,
        email: user.email ?? email,
      );

      final appUser = await UserService().getUserProfile(user.uid);

      if (appUser == null) {
        await authService.signOut();
        mostrarMensagem('Perfil do usuário não encontrado.');
        return;
      }

      if (appUser.isAdmin) {
        await authService.signOut();
        mostrarMensagem('Conta de gestão. Use o acesso da gestão.');
        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHomePage()),
      );
    } on FirebaseAuthException catch (erro) {
      mostrarMensagem(traduzirErroFirebase(erro));
    } catch (_) {
      mostrarMensagem('Erro inesperado ao fazer login.');
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  void criarContaTeste() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  String traduzirErroFirebase(FirebaseAuthException erro) {
    switch (erro.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha é fraca. Use pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'operation-not-allowed':
        return 'Login por e-mail e senha ainda não foi ativado no Firebase.';
      default:
        return 'Erro: ${erro.message ?? erro.code}';
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void abrirTutorial() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  void abrirLoginGestao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogo(size: 96),

                    const SizedBox(height: 16),

                    const Text(
                      'RU Smart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Acesso ao Restaurante Universitário',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !carregando,
                      decoration: const InputDecoration(
                        hintText: 'Digite seu e-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Senha',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: senhaController,
                      obscureText: esconderSenha,
                      enabled: !carregando,
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: carregando
                              ? null
                              : () {
                                  setState(() {
                                    esconderSenha = !esconderSenha;
                                  });
                                },
                          icon: Icon(
                            esconderSenha
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: carregando ? null : entrarNoApp,
                        child: carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Entrar'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: carregando ? null : criarContaTeste,
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text('Criar conta de aluno'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextButton.icon(
                      onPressed: carregando ? null : abrirTutorial,
                      icon: const Icon(Icons.help_outline_rounded, size: 20),
                      label: const Text('Como usar o app?'),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: carregando ? null : abrirLoginGestao,
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        label: const Text('Acesso da gestão'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(color: AppColors.outlineVariant),

                    const SizedBox(height: 12),

                    const Text(
                      'Ambiente Seguro Acadêmico',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
