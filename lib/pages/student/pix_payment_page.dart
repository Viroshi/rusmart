import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_colors.dart';
import '../../models/app_user_model.dart';
import '../../services/auth_service.dart';
import '../../services/ticket_service.dart';
import '../../services/user_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/fake_qr_code.dart';
import '../../widgets/info_box.dart';
import 'ticket_qr_page.dart';

class PixPaymentPage extends StatelessWidget {
  const PixPaymentPage({super.key});

  static const String pixCode =
      '00020126580014BR.GOV.BCB.PIX0136ru-smart-demo@uespi.br52040000530398654043.005802BR5920RU SMART DEMO6008TERESINA62070503***6304ABCD';

  void copiarCodigoPix(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: pixCode));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código PIX copiado.'),
      ),
    );
  }

  Future<void> confirmarPagamento(BuildContext context) async {
    try {
      final firebaseUser = AuthService().currentUser;

      if (firebaseUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não está logado.'),
          ),
        );
        return;
      }

      final AppUserModel? appUser = await UserService().getUserProfile(
        firebaseUser.uid,
      );

      if (!context.mounted) return;

      if (appUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil do aluno não encontrado.'),
          ),
        );
        return;
      }

      final ticket = await TicketService().createPaidTicket(
        user: appUser,
        mealType: 'Almoço',
        price: 3.00,
      );

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => TicketQrPage(
            ticketId: ticket.id,
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (erro) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar ficha: $erro'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Pagamento PIX',
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
                maxWidth: 520,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Finalize o pagamento',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Escaneie o QR Code ou copie o código PIX abaixo.',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.secondary.withOpacity(0.22),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color: AppColors.secondary,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Aguardando pagamento',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const FakeQrCode(
                          size: 230,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Valor da ficha',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'R\$ 3,00',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 30,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Divider(
                          color: AppColors.outlineVariant,
                        ),

                        const SizedBox(height: 14),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Código copia e cola',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                          child: const SelectableText(
                            pixCode,
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              copiarCodigoPix(context);
                            },
                            icon: const Icon(Icons.copy_rounded),
                            label: const Text('Copiar código PIX'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'Este pagamento é apenas visual no protótipo. No backend real, o app deverá verificar o pagamento antes de liberar a ficha.',
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        confirmarPagamento(context);
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Simular pagamento confirmado'),
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