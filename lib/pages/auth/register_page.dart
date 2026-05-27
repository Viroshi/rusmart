import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../widgets/app_logo.dart';
import '../student/student_home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool esconderSenha = true;
  bool carregando = false;

  @override
  void dispose() {
    nomeController.dispose();
    matriculaController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> criarConta() async {
    final String nome = nomeController.text.trim();
    final String matricula = matriculaController.text.trim();
    final String email = emailController.text.trim();
    final String senha = senhaController.text.trim();

    if (nome.isEmpty || matricula.isEmpty || email.isEmpty || senha.isEmpty) {
      mostrarMensagem('Preencha todos os campos.');
      return;
    }

    if (senha.length < 6) {
      mostrarMensagem('A senha precisa ter pelo menos 6 caracteres.');
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      final UserCredential credential =
          await authService.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        mostrarMensagem('Não foi possível criar o usuário.');
        return;
      }

      await userService.createStudentProfile(
        uid: firebaseUser.uid,
        name: nome,
        email: email,
        registration: matricula,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const StudentHomePage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (erro) {
      mostrarMensagem(traduzirErroFirebase(erro));
    } catch (erro) {
      mostrarMensagem('Erro ao criar conta: $erro');
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  String traduzirErroFirebase(FirebaseAuthException erro) {
    switch (erro.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha é fraca. Use pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      case 'operation-not-allowed':
        return 'Login por e-mail e senha ainda não foi ativado no Firebase.';
      default:
        return 'Erro: ${erro.message ?? erro.code}';
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Criar conta',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant,
                  ),
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
                    const AppLogo(size: 88),

                    const SizedBox(height: 16),

                    const Text(
                      'Cadastro do aluno',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Crie uma conta para acessar o RU Smart.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 28),

                    TextField(
                      controller: nomeController,
                      enabled: !carregando,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: matriculaController,
                      keyboardType: TextInputType.number,
                      enabled: !carregando,
                      decoration: const InputDecoration(
                        labelText: 'Matrícula',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !carregando,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: senhaController,
                      obscureText: esconderSenha,
                      enabled: !carregando,
                      decoration: InputDecoration(
                        labelText: 'Senha',
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
                      child: FilledButton.icon(
                        onPressed: carregando ? null : criarConta,
                        icon: carregando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.3,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.person_add_alt_1_rounded),
                        label: Text(
                          carregando ? 'Criando...' : 'Criar conta',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton.icon(
                      onPressed: carregando
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Voltar para login'),
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