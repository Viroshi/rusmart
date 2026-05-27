import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_box.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  void exportarRelatorio(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportação simulada no protótipo.'),
      ),
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
          'Relatórios',
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
                maxWidth: 1000,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Relatórios administrativos',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Acompanhe dados de vendas, validações, ausências e arrecadação do RU.',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'Os dados desta tela são simulados. Futuramente, serão gerados automaticamente a partir das compras, pagamentos e validações reais.',
                  ),

                  const SizedBox(height: 20),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double largura = constraints.maxWidth;

                      final double cardWidth = largura >= 900
                          ? (largura - 42) / 4
                          : largura >= 600
                              ? (largura - 14) / 2
                              : largura;

                      return Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: const ReportMetricCard(
                              icon: Icons.confirmation_number_outlined,
                              title: 'Fichas vendidas',
                              value: '450',
                              subtitle: 'Hoje',
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const ReportMetricCard(
                              icon: Icons.verified_outlined,
                              title: 'Fichas validadas',
                              value: '320',
                              subtitle: 'Refeições servidas',
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const ReportMetricCard(
                              icon: Icons.event_busy_outlined,
                              title: 'Ausências',
                              value: '63',
                              subtitle: 'Não compareceram',
                              color: AppColors.error,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const ReportMetricCard(
                              icon: Icons.payments_outlined,
                              title: 'Arrecadação',
                              value: 'R\$ 1.350',
                              subtitle: 'Pagamentos PIX',
                              color: AppColors.primaryContainer,
                            ),
                         ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool telaLarga = constraints.maxWidth >= 820;

                      if (telaLarga) {
                        return const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: MovementReportCard(),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: AbsenceReportCard(),
                            ),
                          ],
                        );
                      }

                      return const Column(
                        children: [
                          MovementReportCard(),
                          SizedBox(height: 16),
                          AbsenceReportCard(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  const PaymentReportCard(),

                  const SizedBox(height: 20),

                  const AutomaticReportsCard(),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        exportarRelatorio(context);
                      },
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('Exportar relatório'),
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

class ReportMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const ReportMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 25,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 27,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class MovementReportCard extends StatelessWidget {
  const MovementReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.query_stats_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Movimento da semana',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 6),

          Text(
            'Fichas vendidas por dia.',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

          SizedBox(height: 22),

          ReportBarChart(
            labels: [
              'Seg',
              'Ter',
              'Qua',
              'Qui',
              'Sex',
            ],
            values: [
              410,
              450,
              390,
              470,
              430,
            ],
          ),
        ],
      ),
    );
  }
}

class AbsenceReportCard extends StatelessWidget {
  const AbsenceReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(
                Icons.event_busy_outlined,
                color: AppColors.error,
              ),
              SizedBox(width: 8),
              Text(
                'Taxa de ausência',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          AbsenceLine(
            label: 'Segunda',
            percent: '11%',
            value: 0.11,
          ),

          AbsenceLine(
            label: 'Terça',
            percent: '14%',
            value: 0.14,
          ),

          AbsenceLine(
            label: 'Quarta',
            percent: '9%',
            value: 0.09,
          ),

          AbsenceLine(
            label: 'Quinta',
            percent: '16%',
            value: 0.16,
          ),

          AbsenceLine(
            label: 'Sexta',
            percent: '13%',
            value: 0.13,
          ),
        ],
      ),
    );
  }
}

class AbsenceLine extends StatelessWidget {
  final String label;
  final String percent;
  final double value;

  const AbsenceLine({
    super.key,
    required this.label,
    required this.percent,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                percent,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerLow,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentReportCard extends StatelessWidget {
  const PaymentReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pix_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Relatório de pagamentos',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          PaymentReportLine(
            title: 'Pagamentos confirmados',
            value: '450',
            icon: Icons.check_circle_outline_rounded,
          ),

          Divider(
            height: 28,
            color: AppColors.outlineVariant,
          ),

          PaymentReportLine(
            title: 'Valor bruto arrecadado',
            value: 'R\$ 1.350,00',
            icon: Icons.payments_outlined,
          ),

          Divider(
            height: 28,
            color: AppColors.outlineVariant,
          ),

          PaymentReportLine(
            title: 'Valor retido por ausência',
            value: 'R\$ 94,50',
            icon: Icons.savings_outlined,
          ),

          Divider(
            height: 28,
            color: AppColors.outlineVariant,
          ),

          PaymentReportLine(
            title: 'Reembolsos parciais estimados',
            value: 'R\$ 94,50',
            icon: Icons.keyboard_return_rounded,
          ),
        ],
      ),
    );
  }
}

class PaymentReportLine extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const PaymentReportLine({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class AutomaticReportsCard extends StatelessWidget {
  const AutomaticReportsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(
                Icons.auto_graph_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Relatórios automáticos',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          AutomaticReportItem(
            icon: Icons.restaurant_menu_rounded,
            title: 'Refeição mais consumida',
            description: 'Almoço teve maior procura nesta semana.',
          ),

          SizedBox(height: 12),

          AutomaticReportItem(
            icon: Icons.schedule_rounded,
            title: 'Horário de maior movimento',
            description: 'Pico registrado entre 12:00 e 12:30.',
          ),

          SizedBox(height: 12),

          AutomaticReportItem(
            icon: Icons.event_busy_outlined,
            title: 'Ausência acima do ideal',
            description: 'Terça e quinta tiveram maior taxa de não comparecimento.',
          ),
        ],
      ),
    );
  }
}

class AutomaticReportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AutomaticReportItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReportBarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;

  const ReportBarChart({
    super.key,
    required this.labels,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final double maxValue = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          values.length,
          (index) {
            final double barHeight = 125 * (values[index] / maxValue);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      values[index].toInt().toString(),
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      height: barHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      labels[index],
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}