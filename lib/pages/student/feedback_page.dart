import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_box.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int notaSelecionada = 4;

  final TextEditingController comentarioController = TextEditingController();

  final Set<String> pontosSelecionados = {
    'Comida boa',
    'Atendimento bom',
  };

  final List<String> opcoes = [
    'Comida boa',
    'Fila rápida',
    'Atendimento bom',
    'Temperatura boa',
    'Pouca variedade',
    'Demora na fila',
    'Porção pequena',
    'Ambiente limpo',
  ];

  @override
  void dispose() {
    comentarioController.dispose();
    super.dispose();
  }

  void alternarOpcao(String opcao, bool selecionado) {
    setState(() {
      if (selecionado) {
        pontosSelecionados.add(opcao);
      } else {
        pontosSelecionados.remove(opcao);
      }
    });
  }

  void enviarFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback enviado no protótipo.'),
      ),
    );

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
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
          'Avaliar refeição',
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
                    'Como foi sua refeição?',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Sua opinião ajuda a gestão do RU a melhorar o atendimento e a qualidade da comida.',
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
                        const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Avaliação geral',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 2,
                            children: List.generate(
                              5,
                              (index) {
                                final int valor = index + 1;
                                final bool ativo = valor <= notaSelecionada;

                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      notaSelecionada = valor;
                                    });
                                  },
                                  icon: Icon(
                                    ativo
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 38,
                                    color: ativo
                                        ? Colors.amber.shade700
                                        : AppColors.outline,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Center(
                          child: Text(
                            '$notaSelecionada de 5',
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
                              Icons.check_circle_outline_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'O que se destacou?',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: opcoes.map(
                            (opcao) {
                              final bool selecionado =
                                  pontosSelecionados.contains(opcao);

                              return FilterChip(
                                label: Text(opcao),
                                selected: selecionado,
                                selectedColor:
                                    AppColors.primaryFixed.withOpacity(0.9),
                                checkmarkColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: selecionado
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: selecionado
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: selecionado
                                      ? AppColors.primaryFixedDim
                                      : AppColors.outlineVariant,
                                ),
                                onSelected: (value) {
                                  alternarOpcao(opcao, value);
                                },
                              );
                            },
                          ).toList(),
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
                              Icons.edit_note_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Comentário opcional',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: comentarioController,
                          minLines: 4,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            hintText:
                                'Ex: a comida estava boa, mas a fila demorou um pouco...',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'No sistema real, essas avaliações serão usadas pela gestão para identificar problemas recorrentes e melhorar o serviço.',
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: enviarFeedback,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Enviar avaliação'),
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