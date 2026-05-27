import 'package:flutter/material.dart';
import 'menu_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/food_line.dart';
import '../../widgets/info_box.dart';
import '../../widgets/status_chip.dart';
import 'buy_ticket_page.dart';
import 'ticket_qr_page.dart';
import 'feedback_page.dart';
import '../auth/login_page.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  void mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'RU Smart',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Olá, estudante!',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Acompanhe sua ficha, cardápio e janela de atendimento.',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StatusChip(
                          icon: Icons.check_circle_rounded,
                          text: 'Ficha ativa para hoje',
                          color: AppColors.secondary,
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Janela sugerida',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          '12:20 - 12:30',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 30,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 14),

                        const InfoBox(
                          icon: Icons.notifications_active_outlined,
                          color: AppColors.secondary,
                          text:
                              'Seu atendimento está se aproximando. Dirija-se ao RU nos próximos 10 minutos.',
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TicketQrPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_2_rounded),
                            label: const Text('Ver QR Code'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cardápio de hoje',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        const FoodLine(
                          label: 'Prato principal',
                          value: 'Strogonoff de frango',
                        ),

                        const FoodLine(
                          label: 'Acompanhamentos',
                          value: 'Arroz, feijão, batata palha e salada',
                        ),

                        const FoodLine(
                          label: 'Sobremesa',
                          value: 'Gelatina de morango ou fruta',
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MenuPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.menu_book_outlined),
                            label: const Text('Abrir cardápio completo'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: HomeActionCard(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Comprar ficha',
                          subtitle: 'Pagamento via Pix',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BuyTicketPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: HomeActionCard(
                          icon: Icons.rate_review_outlined,
                          title: 'Avaliar refeição',
                          subtitle: 'Enviar feedback',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FeedbackPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'A janela de atendimento é apenas uma sugestão para reduzir filas. O aluno ainda poderá ir ao RU no horário que preferir.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const HomeActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 138,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),

                const Spacer(),

                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
