import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/daily_report_model.dart';
import '../../models/feedback_model.dart';
import '../../models/ticket_model.dart';
import '../../services/feedback_service.dart';
import '../../services/report_service.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  String formatarValor(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatarData(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String formatarHora(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String formatarPercentual(double value) {
    return '${(value * 100).toStringAsFixed(1).replaceAll('.', ',')}%';
  }

  @override
  Widget build(BuildContext context) {
    final ReportService reportService = ReportService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Relatórios',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DailyReportModel>(
          stream: reportService.watchTodayReport(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Erro ao carregar relatórios: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            final report = snapshot.data;

            if (report == null) {
              return const Center(
                child: Text('Relatório não encontrado.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 720,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Resumo do dia',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 28,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Dados de ${formatarData(report.date)}',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ReportMetricCard(
                            icon: Icons.confirmation_number_outlined,
                            title: 'Fichas vendidas',
                            value: report.totalTickets.toString(),
                            subtitle: 'Total de fichas do dia',
                          ),
                          ReportMetricCard(
                            icon: Icons.verified_rounded,
                            title: 'Validadas',
                            value: report.validatedTickets.toString(),
                            subtitle: 'Alunos atendidos',
                          ),
                          ReportMetricCard(
                            icon: Icons.schedule_rounded,
                            title: 'Pendentes',
                            value: report.paidTickets.toString(),
                            subtitle: 'Ainda não utilizadas',
                          ),
                          ReportMetricCard(
                            icon: Icons.payments_outlined,
                            title: 'Arrecadação',
                            value: formatarValor(report.totalRevenue),
                            subtitle: 'Valor total vendido',
                          ),
                        ],
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Desempenho da validação',
                                  style: TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Text(
                              formatarPercentual(report.validationRate),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 32,
                                height: 1,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 8),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: report.validationRate,
                                minHeight: 10,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              '${report.validatedTickets} de ${report.totalTickets} ficha(s) já foram validadas.',
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
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
                            const Text(
                              'Detalhamento financeiro',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 14),

                            ReportInfoLine(
                              icon: Icons.payments_outlined,
                              label: 'Arrecadação total',
                              value: formatarValor(report.totalRevenue),
                            ),

                            const SizedBox(height: 10),

                            ReportInfoLine(
                              icon: Icons.check_circle_outline_rounded,
                              label: 'Valor de fichas validadas',
                              value: formatarValor(report.validatedRevenue),
                            ),

                            const SizedBox(height: 10),

                            ReportInfoLine(
                              icon: Icons.pending_actions_rounded,
                              label: 'Valor pendente de uso',
                              value: formatarValor(report.pendingRevenue),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      FeedbackReportSection(
                        dateKey: report.dateKey,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Últimas fichas',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (report.latestTickets.isEmpty)
                        const EmptyReportTickets()
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: report.latestTickets.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final ticket = report.latestTickets[index];

                            return ReportTicketCard(
                              ticket: ticket,
                              timeText: formatarHora(ticket.createdAt),
                              priceText: formatarValor(ticket.price),
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

class FeedbackReportSection extends StatelessWidget {
  final String dateKey;

  const FeedbackReportSection({
    super.key,
    required this.dateKey,
  });

  double mediaDasNotas(List<FeedbackModel> feedbacks) {
    if (feedbacks.isEmpty) {
      return 0;
    }

    final total = feedbacks.fold<int>(
      0,
      (sum, feedback) => sum + feedback.rating,
    );

    return total / feedbacks.length;
  }

  Map<String, int> contarTags(List<FeedbackModel> feedbacks) {
    final Map<String, int> result = {};

    for (final feedback in feedbacks) {
      for (final tag in feedback.selectedTags) {
        result[tag] = (result[tag] ?? 0) + 1;
      }
    }

    return result;
  }

  List<MapEntry<String, int>> principaisTags(List<FeedbackModel> feedbacks) {
    final tags = contarTags(feedbacks).entries.toList();

    tags.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return tags.take(6).toList();
  }

  List<FeedbackModel> comentariosRecentes(List<FeedbackModel> feedbacks) {
    return feedbacks
        .where((feedback) => feedback.comment.trim().isNotEmpty)
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final FeedbackService feedbackService = FeedbackService();

    return StreamBuilder<List<FeedbackModel>>(
      stream: feedbackService.watchTodayFeedbacks(dateKey),
      builder: (context, snapshot) {
        final feedbacks = snapshot.data ?? [];
        final average = mediaDasNotas(feedbacks);
        final tags = principaisTags(feedbacks);
        final comments = comentariosRecentes(feedbacks);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.outlineVariant,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Avaliações dos alunos',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ReportMetricCard(
                  icon: Icons.rate_review_outlined,
                  title: 'Avaliações',
                  value: feedbacks.length.toString(),
                  subtitle: 'Total recebido hoje',
                ),
                ReportMetricCard(
                  icon: Icons.star_rate_rounded,
                  title: 'Nota média',
                  value: feedbacks.isEmpty
                      ? '0,0'
                      : average.toStringAsFixed(1).replaceAll('.', ','),
                  subtitle: 'Média de 1 a 5 estrelas',
                ),
              ],
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.label_outline_rounded,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Pontos mais marcados',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (tags.isEmpty)
                    const Text(
                      'Nenhum ponto marcado ainda.',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${entry.key} • ${entry.value}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Comentários recentes',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (comments.isEmpty)
                    const Text(
                      'Nenhum comentário enviado ainda.',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final feedback = comments[index];

                        return FeedbackCommentCard(
                          feedback: feedback,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class FeedbackCommentCard extends StatelessWidget {
  final FeedbackModel feedback;

  const FeedbackCommentCard({
    super.key,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rate_rounded,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${feedback.rating}/5',
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feedback.userName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            feedback.comment,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const ReportMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 354,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 22,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportInfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ReportInfoLine({
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
          size: 21,
        ),
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

class ReportTicketCard extends StatelessWidget {
  final TicketModel ticket;
  final String timeText;
  final String priceText;

  const ReportTicketCard({
    super.key,
    required this.ticket,
    required this.timeText,
    required this.priceText,
  });

  String statusLabel(String status) {
    switch (status) {
      case 'paid':
        return 'Pendente';
      case 'validated':
        return 'Validada';
      case 'expired':
        return 'Expirada';
      default:
        return 'Desconhecido';
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'paid':
        return Icons.schedule_rounded;
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryFixed,
            child: Icon(
              statusIcon(ticket.status),
              color: AppColors.primary,
              size: 21,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Matrícula: ${ticket.registration} • $timeText',
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                statusLabel(ticket.status),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyReportTickets extends StatelessWidget {
  const EmptyReportTickets({super.key});

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
            Icons.analytics_outlined,
            color: AppColors.primary,
            size: 52,
          ),
          SizedBox(height: 14),
          Text(
            'Nenhuma ficha vendida hoje',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Quando os alunos comprarem fichas, os dados aparecerão neste relatório.',
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