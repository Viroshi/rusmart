import 'package:flutter/material.dart';
import 'feedback_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/fake_qr_code.dart';
import '../../widgets/info_box.dart';
import '../../widgets/status_chip.dart';

class TicketQrPage extends StatelessWidget {
  const TicketQrPage({super.key});

  void validarSimulado(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackPage()),
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
          'QR Code da ficha',
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Apresente no RU',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Mostre este QR Code no atendimento para validar sua refeição.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 22),

                  AppCard(
                    child: Column(
                      children: [
                        const StatusChip(
                          icon: Icons.check_circle_rounded,
                          text: 'Ficha ativa para hoje',
                          color: AppColors.secondary,
                        ),

                        const SizedBox(height: 22),

                        const FakeQrCode(size: 240),

                        const SizedBox(height: 22),

                        const Text(
                          'Ficha de almoço',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Restaurante Universitário',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Divider(color: AppColors.outlineVariant),

                        const SizedBox(height: 16),

                        const TicketQrInfoRow(
                          icon: Icons.person_outline_rounded,
                          title: 'Aluno',
                          value: 'Estudante RU Smart',
                        ),

                        const SizedBox(height: 14),

                        const TicketQrInfoRow(
                          icon: Icons.badge_outlined,
                          title: 'Matrícula',
                          value: '2024000000',
                        ),

                        const SizedBox(height: 14),

                        const TicketQrInfoRow(
                          icon: Icons.schedule_rounded,
                          title: 'Janela sugerida',
                          value: '12:20 - 12:30',
                        ),

                        const SizedBox(height: 14),

                        const TicketQrInfoRow(
                          icon: Icons.confirmation_number_outlined,
                          title: 'Código da ficha',
                          value: 'RU-2024-0012',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.notifications_active_outlined,
                    color: AppColors.secondary,
                    text:
                        'Seu atendimento está se aproximando. Dirija-se ao RU nos próximos 10 minutos.',
                  ),

                  const SizedBox(height: 12),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'Este QR Code é visual no protótipo. No sistema real, ele será gerado pelo backend e validado pela gestão do RU.',
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        validarSimulado(context);
                      },
                      icon: const Icon(Icons.verified_rounded),
                      label: const Text('Simular validação no RU'),
                    ),
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

class TicketQrInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const TicketQrInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
