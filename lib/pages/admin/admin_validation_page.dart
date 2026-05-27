import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/ticket_model.dart';
import '../../services/ticket_service.dart';

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({super.key});

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  final TicketService ticketService = TicketService();
  final TextEditingController qrCodeController = TextEditingController();

  bool validandoCodigo = false;
  String? ticketEmValidacao;
  TicketModel? ultimaFichaValidada;

  @override
  void dispose() {
    qrCodeController.dispose();
    super.dispose();
  }

  Future<void> validarPorCodigo() async {
    final qrCode = qrCodeController.text.trim();

    if (qrCode.isEmpty) {
      mostrarMensagem('Informe o código da ficha.');
      return;
    }

    setState(() {
      validandoCodigo = true;
    });

    try {
      final ticket = await ticketService.validateTicketByQrCode(
        qrCode: qrCode,
      );

      setState(() {
        ultimaFichaValidada = ticket;
        qrCodeController.clear();
      });

      mostrarMensagem('Ficha validada com sucesso.');
    } catch (erro) {
      mostrarMensagem('Erro ao validar ficha: $erro');
    } finally {
      if (mounted) {
        setState(() {
          validandoCodigo = false;
        });
      }
    }
  }

  Future<void> validarFichaDaLista(TicketModel ticket) async {
    setState(() {
      ticketEmValidacao = ticket.id;
    });

    try {
      final validatedTicket = await ticketService.validateTicketById(
        ticketId: ticket.id,
      );

      setState(() {
        ultimaFichaValidada = validatedTicket;
      });

      mostrarMensagem('Ficha de ${ticket.userName} validada com sucesso.');
    } catch (erro) {
      mostrarMensagem('Erro ao validar ficha: $erro');
    } finally {
      if (mounted) {
        setState(() {
          ticketEmValidacao = null;
        });
      }
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  String formatarValor(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Validação de fichas',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<TicketModel>>(
          stream: ticketService.watchTodayPaidTickets(),
          builder: (context, snapshot) {
            final tickets = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 620,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Validar acesso ao RU',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 28,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Valide a ficha do aluno e registre o uso no banco de dados.',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Validar por código',
                                  style: TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            TextField(
                              controller: qrCodeController,
                              enabled: !validandoCodigo,
                              decoration: const InputDecoration(
                                labelText: 'Código da ficha',
                                hintText: 'Cole o código do QR Code',
                                prefixIcon: Icon(Icons.confirmation_number),
                              ),
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              height: 48,
                              child: FilledButton.icon(
                                onPressed: validandoCodigo
                                    ? null
                                    : validarPorCodigo,
                                icon: validandoCodigo
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.verified_rounded),
                                label: Text(
                                  validandoCodigo
                                      ? 'Validando...'
                                      : 'Validar código',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (ultimaFichaValidada != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Última ficha validada: ${ultimaFichaValidada!.userName} - Matrícula ${ultimaFichaValidada!.registration}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Fichas ativas de hoje',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${tickets.length} pendente(s)',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (tickets.isEmpty)
                        const EmptyValidationList()
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tickets.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(height: 12);
                          },
                          itemBuilder: (context, index) {
                            final ticket = tickets[index];

                            return TicketValidationCard(
                              ticket: ticket,
                              priceText: formatarValor(ticket.price),
                              isLoading: ticketEmValidacao == ticket.id,
                              onValidate: () {
                                validarFichaDaLista(ticket);
                              },
                            );
                          },
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

class TicketValidationCard extends StatelessWidget {
  final TicketModel ticket;
  final String priceText;
  final bool isLoading;
  final VoidCallback onValidate;

  const TicketValidationCard({
    super.key,
    required this.ticket,
    required this.priceText,
    required this.isLoading,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryFixed,
                child: Text(
                  ticket.queuePosition.toString(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.userName,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Matrícula: ${ticket.registration}',
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Ativa',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                TicketMiniInfo(
                  icon: Icons.restaurant_menu_rounded,
                  label: 'Refeição',
                  value: ticket.mealType,
                ),
                const SizedBox(height: 8),
                TicketMiniInfo(
                  icon: Icons.payments_outlined,
                  label: 'Valor',
                  value: priceText,
                ),
                const SizedBox(height: 8),
                TicketMiniInfo(
                  icon: Icons.schedule_rounded,
                  label: 'Janela sugerida',
                  value:
                      '${ticket.suggestedStartTime} - ${ticket.suggestedEndTime}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onValidate,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                isLoading ? 'Validando...' : 'Validar ficha',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketMiniInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const TicketMiniInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 19,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class EmptyValidationList extends StatelessWidget {
  const EmptyValidationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            color: AppColors.primary,
            size: 52,
          ),
          SizedBox(height: 14),
          Text(
            'Nenhuma ficha pendente',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'As fichas compradas pelos alunos aparecerão aqui para validação.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}