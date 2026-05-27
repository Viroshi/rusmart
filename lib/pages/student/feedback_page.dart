import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/ticket_model.dart';
import '../../services/auth_service.dart';
import '../../services/feedback_service.dart';
import '../../services/ticket_service.dart';

class FeedbackPage extends StatefulWidget {
  final String? ticketId;

  const FeedbackPage({
    super.key,
    this.ticketId,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackService feedbackService = FeedbackService();
  final TicketService ticketService = TicketService();
  final TextEditingController comentarioController = TextEditingController();

  int nota = 0;
  bool salvando = false;

  final List<String> opcoes = [
    'Comida boa',
    'Temperatura adequada',
    'Fila organizada',
    'Atendimento bom',
    'Pouca variedade',
    'Comida fria',
    'Demora na fila',
    'Porção insuficiente',
  ];

  final Set<String> selecionados = {};

  @override
  void dispose() {
    comentarioController.dispose();
    super.dispose();
  }

  Stream<TicketModel?> carregarFicha() {
    if (widget.ticketId != null) {
      return ticketService.watchTicketById(widget.ticketId!);
    }

    final user = AuthService().currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return ticketService.watchTodayTicket(user.uid);
  }

  Future<void> salvarAvaliacao(TicketModel ticket) async {
    if (nota == 0) {
      mostrarMensagem('Selecione uma nota para a refeição.');
      return;
    }

    if (ticket.status != 'validated') {
      mostrarMensagem('A avaliação só é liberada depois da ficha ser validada.');
      return;
    }

    setState(() {
      salvando = true;
    });

    try {
      await feedbackService.saveFeedback(
        ticket: ticket,
        rating: nota,
        selectedTags: selecionados.toList(),
        comment: comentarioController.text,
      );

      if (!mounted) return;

      mostrarMensagem('Avaliação enviada com sucesso.');

      Navigator.pop(context);
    } catch (erro) {
      mostrarMensagem('Erro ao salvar avaliação: $erro');
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  void alternarOpcao(String opcao) {
    setState(() {
      if (selecionados.contains(opcao)) {
        selecionados.remove(opcao);
      } else {
        selecionados.add(opcao);
      }
    });
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  String textoNota() {
    switch (nota) {
      case 1:
        return 'Muito ruim';
      case 2:
        return 'Ruim';
      case 3:
        return 'Regular';
      case 4:
        return 'Boa';
      case 5:
        return 'Excelente';
      default:
        return 'Toque nas estrelas para avaliar';
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
          'Avaliar refeição',
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final ticket = snapshot.data;

            if (ticket == null) {
              return const EmptyFeedbackView(
                title: 'Ficha não encontrada',
                message:
                    'Não foi possível encontrar uma ficha para avaliação.',
              );
            }

            if (ticket.status != 'validated') {
              return const EmptyFeedbackView(
                title: 'Avaliação indisponível',
                message:
                    'A avaliação só fica disponível depois que a ficha é validada pela gestão.',
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 560,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Como foi sua refeição?',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 28,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${ticket.mealType} • Matrícula ${ticket.registration}',
                        style: const TextStyle(
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Sua nota',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final starValue = index + 1;
                                final selected = starValue <= nota;

                                return IconButton(
                                  onPressed: salvando
                                      ? null
                                      : () {
                                          setState(() {
                                            nota = starValue;
                                          });
                                        },
                                  icon: Icon(
                                    selected
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 38,
                                    color: selected
                                        ? AppColors.secondary
                                        : AppColors.outline,
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              textoNota(),
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Marque pontos observados',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: opcoes.map((opcao) {
                                final selected = selecionados.contains(opcao);

                                return FilterChip(
                                  selected: selected,
                                  label: Text(opcao),
                                  onSelected: salvando
                                      ? null
                                      : (_) {
                                          alternarOpcao(opcao);
                                        },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        child: TextField(
                          controller: comentarioController,
                          enabled: !salvando,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Comentário opcional',
                            hintText:
                                'Escreva uma observação sobre a refeição, fila ou atendimento.',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.notes_rounded),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 52,
                        child: FilledButton.icon(
                          onPressed:
                              salvando ? null : () => salvarAvaliacao(ticket),
                          icon: salvando
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(
                            salvando ? 'Enviando...' : 'Enviar avaliação',
                          ),
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

class EmptyFeedbackView extends StatelessWidget {
  final String title;
  final String message;

  const EmptyFeedbackView({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.outlineVariant,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.rate_review_outlined,
                  color: AppColors.primary,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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