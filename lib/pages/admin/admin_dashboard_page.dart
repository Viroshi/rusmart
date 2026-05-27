import 'package:flutter/material.dart';
import 'admin_menu_page.dart';
import 'admin_validation_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/food_line.dart';
import '../../widgets/info_box.dart';
import 'admin_reports_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  void mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void sair(BuildContext context) {
    Navigator.pop(context);
  }

  void abrirGerenciamentoCardapio(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminMenuPage()),
    );
  }

  void abrirValidacaoQrCode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminValidationPage()),
    );
  }

  void abrirRelatorios(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminReportsPage()),
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
          'RU Smart Gestão',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              sair(context);
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard administrativo',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Acompanhe os principais dados operacionais do Restaurante Universitário.',
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
                        'Os dados abaixo são simulados. Depois, eles serão alimentados pelo backend do sistema.',
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
                            child: const AdminMetricCard(
                              icon: Icons.confirmation_number_outlined,
                              title: 'Fichas vendidas',
                              value: '450',
                              description: '+12% em relação a ontem',
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const AdminMetricCard(
                              icon: Icons.restaurant_rounded,
                              title: 'Refeições servidas',
                              value: '320',
                              description: '71% das fichas vendidas',
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const AdminMetricCard(
                              icon: Icons.payments_outlined,
                              title: 'Arrecadação',
                              value: 'R\$ 1.350',
                              description: 'Pagamentos PIX simulados',
                              color: AppColors.primaryContainer,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const AdminMetricCard(
                              icon: Icons.event_busy_outlined,
                              title: 'Ausências',
                              value: '14%',
                              description: 'Alunos que não validaram',
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool telaLarga = constraints.maxWidth >= 780;

                      if (telaLarga) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: DashboardMovementCard()),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: DashboardMenuCard(
                                onManageMenu: () {
                                  abrirGerenciamentoCardapio(context);
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          const DashboardMovementCard(),
                          const SizedBox(height: 16),
                          DashboardMenuCard(
                            onManageMenu: () {
                              abrirGerenciamentoCardapio(context);
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.task_alt_rounded,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ações rápidas',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final bool doisBotoes = constraints.maxWidth >= 560;

                            final List<Widget> botoes = [
                              AdminActionButton(
                                icon: Icons.menu_book_outlined,
                                label: 'Gerenciar cardápio',
                                onPressed: () {
                                  abrirGerenciamentoCardapio(context);
                                },
                              ),
                              AdminActionButton(
                                icon: Icons.qr_code_scanner_rounded,
                                label: 'Validar QR Code',
                                onPressed: () {
                                  abrirValidacaoQrCode(context);
                                },
                              ),
                              AdminActionButton(
                                icon: Icons.analytics_outlined,
                                label: 'Ver relatórios',
                                onPressed: () {
                                  abrirRelatorios(context);
                                },
                              ),
                            ];

                            if (doisBotoes) {
                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: botoes
                                    .map(
                                      (botao) => SizedBox(
                                        width: (constraints.maxWidth - 12) / 2,
                                        child: botao,
                                      ),
                                    )
                                    .toList(),
                              );
                            }

                            return Column(
                              children: botoes
                                  .map(
                                    (botao) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: botao,
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ],
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

class AdminMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String description;
  final Color color;

  const AdminMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
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
            child: Icon(icon, color: color, size: 25),
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
              fontSize: 28,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardMovementCard extends StatelessWidget {
  const DashboardMovementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.query_stats_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Movimento por horário',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Estimativa de fichas compradas por intervalo.',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),

          const SizedBox(height: 22),

          const SimpleBarChart(
            labels: ['11:00', '11:30', '12:00', '12:30', '13:00', '13:30'],
            values: [35, 58, 86, 72, 50, 26],
          ),
        ],
      ),
    );
  }
}

class DashboardMenuCard extends StatelessWidget {
  final VoidCallback onManageMenu;

  const DashboardMenuCard({super.key, required this.onManageMenu});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_menu_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Cardápio de hoje',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const FoodLine(label: 'Principal', value: 'Strogonoff de frango'),

          const FoodLine(
            label: 'Acompanhamentos',
            value: 'Arroz, feijão, batata palha e salada',
          ),

          const FoodLine(
            label: 'Sobremesa',
            value: 'Gelatina de morango ou fruta',
          ),

          const FoodLine(label: 'Bebida', value: 'Suco de acerola'),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onManageMenu,
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Editar cardápio'),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;

  const SimpleBarChart({super.key, required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    final double maxValue = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final double barHeight = 120 * (values[index] / maxValue);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    values[index].toInt().toString(),
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AdminActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const AdminActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
