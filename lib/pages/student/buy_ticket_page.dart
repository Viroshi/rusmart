import 'package:flutter/material.dart';
import 'pix_payment_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_box.dart';

class BuyTicketPage extends StatelessWidget {
  const BuyTicketPage({super.key});

  void gerarPagamento(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PixPaymentPage()),
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
          'Comprar ficha',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo da ficha',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Confira os dados antes de gerar o pagamento.',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.restaurant_rounded,
                                color: Colors.white,
                                size: 34,
                              ),

                              SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ficha de almoço',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Restaurante Universitário',
                                      style: TextStyle(
                                        color: AppColors.primaryFixedDim,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                'R\$ 3,00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TicketInfoRow(
                                icon: Icons.calendar_today_outlined,
                                title: 'Data de uso',
                                value: 'Hoje',
                              ),

                              Divider(
                                height: 28,
                                color: AppColors.outlineVariant,
                              ),

                              TicketInfoRow(
                                icon: Icons.schedule_rounded,
                                title: 'Horário do almoço',
                                value: '11:30 às 13:30',
                              ),

                              Divider(
                                height: 28,
                                color: AppColors.outlineVariant,
                              ),

                              TicketInfoRow(
                                icon: Icons.qr_code_2_rounded,
                                title: 'Validação',
                                value: 'QR Code no atendimento',
                              ),

                              Divider(
                                height: 28,
                                color: AppColors.outlineVariant,
                              ),

                              TicketInfoRow(
                                icon: Icons.pix_rounded,
                                title: 'Pagamento',
                                value: 'PIX',
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
                        'A ficha comprada só poderá ser usada no respectivo dia. Após o pagamento, ela ficará armazenada na conta do aluno até a validação no RU.',
                  ),

                  const SizedBox(height: 12),

                  const InfoBox(
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.secondary,
                    text:
                        'Caso o aluno compre a ficha e não utilize no mesmo dia, apenas metade do valor será devolvido.',
                  ),

                  const SizedBox(height: 20),

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Janela sugerida após a compra',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'O sistema irá sugerir um melhor horário de ida ao RU com base na ordem de compra da ficha.',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.notifications_active_outlined,
                                color: AppColors.primary,
                              ),

                              SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  'Exemplo: 12:20 - 12:30',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        gerarPagamento(context);
                      },
                      icon: const Icon(Icons.pix_rounded),
                      label: const Text('Gerar pagamento via PIX'),
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

class TicketInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const TicketInfoRow({
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
