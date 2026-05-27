import 'package:flutter/material.dart';
import 'admin_menu_page.dart';
import 'admin_validation_page.dart';
import '../../core/app_colors.dart';
import '../../models/daily_report_model.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';
import '../../services/report_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/food_line.dart';
import '../../widgets/info_box.dart';
import 'admin_reports_page.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

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

  Future<void> sairDaGestao(BuildContext context) async {
    await AuthService().signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
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
              sairDaGestao(context);
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
                        'Os dados abaixo são atualizados com as fichas, validações e cardápio salvos no Firebase.',
                  ),

                  const SizedBox(height: 20),

                  const DashboardMetricSection(),

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


class DashboardMetricSection extends StatelessWidget {
  const DashboardMetricSection({super.key});

  String formatarValor(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String formatarPercentual(double value) {
    return '${(value * 100).toStringAsFixed(0).replaceAll('.', ',')}%';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DailyReportModel>(
      stream: ReportService().watchTodayReport(),
      builder: (context, snapshot) {
        final report = snapshot.data;
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final totalTickets = report?.totalTickets ?? 0;
        final validatedTickets = report?.validatedTickets ?? 0;
        final validationRate = report?.validationRate ?? 0;

        return LayoutBuilder(
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
                  child: AdminMetricCard(
                    icon: Icons.confirmation_number_outlined,
                    title: 'Fichas vendidas',
                    value: loading ? '...' : totalTickets.toString(),
                    description: 'Total registrado hoje',
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: AdminMetricCard(
                    icon: Icons.restaurant_rounded,
                    title: 'Refeições servidas',
                    value: loading ? '...' : validatedTickets.toString(),
                    description: loading
                        ? 'Carregando validações'
                        : '${formatarPercentual(validationRate)} das fichas vendidas',
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: AdminMetricCard(
                    icon: Icons.payments_outlined,
                    title: 'Arrecadação',
                    value: loading ? '...' : formatarValor(report?.totalRevenue ?? 0),
                    description: 'Pagamentos PIX simulados no protótipo',
                    color: AppColors.primaryContainer,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: AdminMetricCard(
                    icon: Icons.event_busy_outlined,
                    title: 'Pendentes',
                    value: loading ? '...' : (report?.paidTickets ?? 0).toString(),
                    description: 'Fichas ainda não validadas',
                    color: AppColors.error,
                  ),
                ),
              ],
            );
          },
        );
      },
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

  List<double> valoresPorHorario(DailyReportModel? report) {
    final values = List<double>.filled(6, 0);

    if (report == null) {
      return values;
    }

    for (final ticket in report.tickets) {
      final hour = ticket.createdAt.hour;
      final minute = ticket.createdAt.minute;
      final totalMinutes = hour * 60 + minute;

      if (totalMinutes < 11 * 60) {
        values[0]++;
      } else if (totalMinutes < 11 * 60 + 30) {
        values[1]++;
      } else if (totalMinutes < 12 * 60) {
        values[2]++;
      } else if (totalMinutes < 12 * 60 + 30) {
        values[3]++;
      } else if (totalMinutes < 13 * 60) {
        values[4]++;
      } else {
        values[5]++;
      }
    }

    return values;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DailyReportModel>(
      stream: ReportService().watchTodayReport(),
      builder: (context, snapshot) {
        final values = valoresPorHorario(snapshot.data);

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
                'Fichas compradas por intervalo.',
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
              ),

              const SizedBox(height: 22),

              SimpleBarChart(
                labels: const ['11:00', '11:30', '12:00', '12:30', '13:00', '13:30'],
                values: values,
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardMenuCard extends StatelessWidget {
  final VoidCallback onManageMenu;

  const DashboardMenuCard({super.key, required this.onManageMenu});

  String valueOrDefault(String value) {
    return value.trim().isEmpty ? 'Não informado' : value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MenuModel?>(
      stream: MenuService().watchTodayMenu(),
      builder: (context, snapshot) {
        final menu = snapshot.data;
        final loading = snapshot.connectionState == ConnectionState.waiting;

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

              if (loading) ...[
                const Text(
                  'Carregando cardápio...',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ] else if (menu == null) ...[
                const Text(
                  'Cardápio ainda não cadastrado.',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ] else ...[
                FoodLine(label: 'Principal', value: valueOrDefault(menu.mainDish)),
                FoodLine(
                  label: 'Acompanhamentos',
                  value: valueOrDefault(menu.sideDishes),
                ),
                FoodLine(
                  label: 'Sobremesa',
                  value: valueOrDefault(menu.dessert),
                ),
                FoodLine(label: 'Bebida', value: valueOrDefault(menu.drink)),
              ],

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
      },
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;

  const SimpleBarChart({super.key, required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    final double highestValue = values.reduce((a, b) => a > b ? a : b);
    final double maxValue = highestValue <= 0 ? 1 : highestValue;

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
