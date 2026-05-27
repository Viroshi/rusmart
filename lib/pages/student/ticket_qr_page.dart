import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/ticket_model.dart';
import '../../services/auth_service.dart';
import '../../services/ticket_service.dart';
import 'feedback_page.dart';

class TicketQrPage extends StatelessWidget {
  final String? ticketId;

  const TicketQrPage({super.key, this.ticketId});

  Stream<TicketModel?> carregarFicha() {
    if (ticketId != null) {
      return TicketService().watchTicketById(ticketId!);
    }

    final user = AuthService().currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return TicketService().watchTodayTicket(user.uid);
  }

  String formatarValor(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String statusLabel(String status) {
    switch (status) {
      case 'paid':
        return 'Ativo para hoje';
      case 'validated':
        return 'Ficha validada';
      case 'expired':
        return 'Ficha expirada';
      default:
        return 'Status desconhecido';
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'paid':
        return Icons.check_circle_rounded;
      case 'validated':
        return Icons.verified_rounded;
      case 'expired':
        return Icons.event_busy_rounded;
      default:
        return Icons.help_outline_rounded;
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
          'QR Code da ficha',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<TicketModel?>(
          stream: carregarFicha(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final ticket = snapshot.data;

            if (ticket == null) {
              return const EmptyTicketView();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      const Text(
                        'Seu acesso ao RU',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Apresente este código na validação.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(20),
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
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon(ticket.status),
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    statusLabel(ticket.status),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            FakeTicketQrCode(value: ticket.qrCode, size: 220),

                            const SizedBox(height: 22),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: AppColors.outlineVariant,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    ticket.userName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    'Matrícula: ${ticket.registration}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            TicketInfoLine(
                              icon: Icons.restaurant_menu_rounded,
                              label: 'Refeição',
                              value: ticket.mealType,
                            ),
                            const SizedBox(height: 12),
                            TicketInfoLine(
                              icon: Icons.payments_outlined,
                              label: 'Valor pago',
                              value: formatarValor(ticket.price),
                            ),
                            const SizedBox(height: 12),
                            TicketInfoLine(
                              icon: Icons.confirmation_number_outlined,
                              label: 'Posição virtual',
                              value: '#${ticket.queuePosition}',
                            ),
                            const SizedBox(height: 12),
                            TicketInfoLine(
                              icon: Icons.schedule_rounded,
                              label: 'Janela sugerida',
                              value:
                                  '${ticket.suggestedStartTime} - ${ticket.suggestedEndTime}',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'A janela de atendimento é uma sugestão do sistema. O aluno ainda pode ir ao RU em outro horário de funcionamento.',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (ticket.status == 'validated')
                        SizedBox(
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FeedbackPage(ticketId: ticket.id),
                                ),
                              );
                            },
                            icon: const Icon(Icons.star_rate_rounded),
                            label: const Text('Avaliar refeição'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EmptyTicketView extends StatelessWidget {
  const EmptyTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  color: AppColors.primary,
                  size: 56,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhuma ficha ativa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quando você comprar uma ficha, o QR Code aparecerá aqui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 15,
                    height: 1.4,
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

class TicketInfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const TicketInfoLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class FakeTicketQrCode extends StatelessWidget {
  final String value;
  final double size;

  const FakeTicketQrCode({super.key, required this.value, required this.size});

  bool isFinderPattern(int row, int col) {
    final topLeft = row < 5 && col < 5;
    final topRight = row < 5 && col > 16;
    final bottomLeft = row > 16 && col < 5;

    return topLeft || topRight || bottomLeft;
  }

  bool isDarkCell(int index) {
    final row = index ~/ 21;
    final col = index % 21;

    if (isFinderPattern(row, col)) {
      final localRow = row < 5 ? row : row - 16;
      final localCol = col < 5 ? col : col - 16;

      final border =
          localRow == 0 || localRow == 4 || localCol == 0 || localCol == 4;

      final center =
          localRow >= 2 && localRow <= 2 && localCol >= 2 && localCol <= 2;

      return border || center;
    }

    final seed = value.hashCode.abs();
    return ((seed + index * 31 + row * 7 + col * 13) % 5) < 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 21 * 21,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 21,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(0.6),
            decoration: BoxDecoration(
              color: isDarkCell(index) ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          );
        },
      ),
    );
  }
}
