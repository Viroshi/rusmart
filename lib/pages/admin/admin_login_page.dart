import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/info_box.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool esconderSenha = true;

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void entrarComoGestao() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool telaLarga = constraints.maxWidth >= 780;

            if (telaLarga) {
              return Row(
                children: [
                  Expanded(child: AdminBrandPanel()),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: AdminLoginCard(
                          usuarioController: usuarioController,
                          senhaController: senhaController,
                          esconderSenha: esconderSenha,
                          onToggleSenha: () {
                            setState(() {
                              esconderSenha = !esconderSenha;
                            });
                          },
                          onEntrar: entrarComoGestao,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: AdminLoginCard(
                  usuarioController: usuarioController,
                  senhaController: senhaController,
                  esconderSenha: esconderSenha,
                  onToggleSenha: () {
                    setState(() {
                      esconderSenha = !esconderSenha;
                    });
                  },
                  onEntrar: entrarComoGestao,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AdminBrandPanel extends StatelessWidget {
  const AdminBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLogo(size: 78, circular: false),

          Spacer(),

          Text(
            'Gestão\nInteligente.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 46,
              height: 1.05,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),

          SizedBox(height: 18),

          Text(
            'Painel administrativo para acompanhar fichas, cardápios, validações e relatórios do Restaurante Universitário.',
            style: TextStyle(
              color: AppColors.primaryFixedDim,
              fontSize: 18,
              height: 1.45,
            ),
          ),

          Spacer(),

          Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primaryFixedDim),
              SizedBox(width: 8),
              Text(
                'Ambiente seguro da gestão',
                style: TextStyle(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminLoginCard extends StatelessWidget {
  final TextEditingController usuarioController;
  final TextEditingController senhaController;
  final bool esconderSenha;
  final VoidCallback onToggleSenha;
  final VoidCallback onEntrar;

  const AdminLoginCard({
    super.key,
    required this.usuarioController,
    required this.senhaController,
    required this.esconderSenha,
    required this.onToggleSenha,
    required this.onEntrar,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 430),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
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
            const AppLogo(size: 86, circular: true),

            const SizedBox(height: 18),

            const Text(
              'RU Smart Gestão',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Acesso restrito aos funcionários',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
            ),

            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Usuário',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 6),

            TextField(
              controller: usuarioController,
              decoration: const InputDecoration(
                hintText: 'Digite seu usuário',
                prefixIcon: Icon(Icons.person_outline_rounded),
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
              decoration: InputDecoration(
                hintText: 'Digite sua senha',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: onToggleSenha,
                  icon: Icon(
                    esconderSenha
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: onEntrar,
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: const Text('Entrar como gestão'),
              ),
            ),

            const SizedBox(height: 16),

            const InfoBox(
              icon: Icons.info_outline_rounded,
              text:
                  'Este login ainda é visual. A autenticação real será feita depois com backend.',
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Voltar para login do aluno'),
            ),
          ],
        ),
      ),
    );
  }
}
