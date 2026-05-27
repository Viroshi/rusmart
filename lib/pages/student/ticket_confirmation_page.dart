import 'package:flutter/material.dart';
import 'ticket_qr_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_box.dart';
import '../../widgets/status_chip.dart';

class TicketConfirmationPage extends StatelessWidget {
  const TicketConfirmationPage({super.key});

  void verQrCode(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TicketQrPage()),
    );
  }

  void voltarParaHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.secondary,
                      size: 72,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Ficha comprada com sucesso!',
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
                    'Sua ficha foi armazenada na conta e já pode ser usada no atendimento do RU.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StatusChip(
                          icon: Icons.confirmation_number_rounded,
                          text: 'Ficha ativa para hoje',
                          color: AppColors.secondary,
                        ),

                        const SizedBox(height: 20),

                        const ConfirmationInfoRow(
                          icon: Icons.restaurant_rounded,
                          title: 'Refeição',
                          value: 'Almoço',
                        ),

                        const Divider(
                          height: 30,
                          color: AppColors.outlineVariant,
                        ),

                        const ConfirmationInfoRow(
                          icon: Icons.payments_outlined,
                          title: 'Valor pago',
                          value: 'R\$ 3,00',
                        ),

                        const Divider(
                          height: 30,
                          color: AppColors.outlineVariant,
                        ),

                        const ConfirmationInfoRow(
                          icon: Icons.format_list_numbered_rounded,
                          title: 'Posição na fila virtual',
                          value: '12º aluno',
                        ),

                        const Divider(
                          height: 30,
                          color: AppColors.outlineVariant,
                        ),

                        const ConfirmationInfoRow(
                          icon: Icons.schedule_rounded,
                          title: 'Janela sugerida',
                          value: '12:20 - 12:30',
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.notifications_active_outlined,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Você será notificado próximo ao horário sugerido.',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'A janela de atendimento é apenas uma sugestão para reduzir filas. O aluno poderá ir ao RU no horário que preferir.',
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        verQrCode(context);
                      },
                      icon: const Icon(Icons.qr_code_2_rounded),
                      label: const Text('Ver QR Code da ficha'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        voltarParaHome(context);
                      },
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Voltar para início'),
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

class ConfirmationInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ConfirmationInfoRow({
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
