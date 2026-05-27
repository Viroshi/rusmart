import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/app_user_model.dart';
import '../../models/menu_model.dart';
import '../../models/ticket_model.dart';
import '../../services/auth_service.dart';
import '../../services/menu_service.dart';
import '../../services/ticket_service.dart';
import '../../services/user_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/food_line.dart';
import '../../widgets/info_box.dart';
import '../../widgets/status_chip.dart';
import '../auth/login_page.dart';
import 'buy_ticket_page.dart';
import 'feedback_page.dart';
import 'menu_page.dart';
import 'ticket_qr_page.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  Future<void> sairDoApp(BuildContext context) async {
    await AuthService().signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Stream<AppUserModel?> carregarPerfilAluno() {
    final user = AuthService().currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return UserService().watchUserProfile(user.uid);
  }

  Stream<TicketModel?> carregarFichaHoje() {
    final user = AuthService().currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return TicketService().watchTodayTicket(user.uid);
  }

  Stream<MenuModel?> carregarCardapioHoje() {
    return MenuService().watchTodayMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'RU Smart',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              sairDoApp(context);
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<AppUserModel?>(
                    stream: carregarPerfilAluno(),
                    builder: (context, snapshot) {
                      final aluno = snapshot.data;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const StudentHomeHeader(
                          nome: 'Carregando...',
                          matricula: '',
                        );
                      }

                      if (aluno == null) {
                        return const StudentHomeHeader(
                          nome: 'Estudante',
                          matricula: 'Matrícula não encontrada',
                        );
                      }

                      return StudentHomeHeader(
                        nome: aluno.name,
                        matricula: aluno.registration,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  StreamBuilder<TicketModel?>(
                    stream: carregarFichaHoje(),
                    builder: (context, snapshot) {
                      return StudentTicketSummaryCard(
                        ticket: snapshot.data,
                        loading:
                            snapshot.connectionState == ConnectionState.waiting,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  StreamBuilder<MenuModel?>(
                    stream: carregarCardapioHoje(),
                    builder: (context, snapshot) {
                      return StudentMenuPreviewCard(
                        menu: snapshot.data,
                        loading:
                            snapshot.connectionState == ConnectionState.waiting,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: HomeActionCard(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Comprar ficha',
                          subtitle: 'Pagamento via Pix',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BuyTicketPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: HomeActionCard(
                          icon: Icons.rate_review_outlined,
                          title: 'Avaliar refeição',
                          subtitle: 'Enviar feedback',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FeedbackPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'A janela de atendimento é apenas uma sugestão para reduzir filas. O aluno ainda poderá ir ao RU no horário que preferir.',
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

class StudentTicketSummaryCard extends StatelessWidget {
  final TicketModel? ticket;
  final bool loading;

  const StudentTicketSummaryCard({
    super.key,
    required this.ticket,
    required this.loading,
  });

  bool get hasTicket {
    return ticket != null;
  }

  String get statusText {
    if (loading) {
      return 'Verificando ficha';
    }

    if (ticket == null) {
      return 'Nenhuma ficha ativa';
    }

    switch (ticket!.status) {
      case 'validated':
        return 'Ficha validada';
      case 'paid':
        return 'Ficha ativa para hoje';
      default:
        return 'Ficha encontrada';
    }
  }

  Color get statusColor {
    if (ticket?.status == 'validated') {
      return AppColors.primary;
    }

    if (ticket?.status == 'paid') {
      return AppColors.secondary;
    }

    return AppColors.outline;
  }

  IconData get statusIcon {
    if (ticket?.status == 'validated') {
      return Icons.verified_rounded;
    }

    if (ticket?.status == 'paid') {
      return Icons.check_circle_rounded;
    }

    return Icons.confirmation_number_outlined;
  }

  String get windowText {
    if (loading) {
      return 'Carregando...';
    }

    if (ticket == null) {
      return 'Nenhuma ficha comprada';
    }

    return '${ticket!.suggestedStartTime} - ${ticket!.suggestedEndTime}';
  }

  String get infoText {
    if (loading) {
      return 'Buscando sua ficha no banco de dados.';
    }

    if (ticket == null) {
      return 'Compre uma ficha para gerar o QR Code de acesso ao RU.';
    }

    if (ticket!.status == 'validated') {
      return 'Sua ficha já foi utilizada. Você já pode avaliar a refeição.';
    }

    return 'Seu atendimento está se aproximando. Dirija-se ao RU dentro da janela sugerida se possível.';
  }

  void abrirAcao(BuildContext context) {
    if (ticket == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BuyTicketPage()),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketQrPage(ticketId: ticket!.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(
            icon: statusIcon,
            text: statusText,
            color: statusColor,
          ),

          const SizedBox(height: 18),

          Text(
            hasTicket ? 'Janela sugerida' : 'Ficha de hoje',
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            windowText,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 30,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          InfoBox(
            icon: hasTicket
                ? Icons.notifications_active_outlined
                : Icons.info_outline_rounded,
            color: hasTicket ? AppColors.secondary : AppColors.primary,
            text: infoText,
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: loading ? null : () => abrirAcao(context),
              icon: Icon(hasTicket ? Icons.qr_code_2_rounded : Icons.pix_rounded),
              label: Text(hasTicket ? 'Ver QR Code' : 'Comprar ficha'),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentMenuPreviewCard extends StatelessWidget {
  final MenuModel? menu;
  final bool loading;

  const StudentMenuPreviewCard({
    super.key,
    required this.menu,
    required this.loading,
  });

  String valueOrDefault(String value) {
    return value.trim().isEmpty ? 'Não informado' : value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.restaurant_menu_rounded,
                color: AppColors.primary,
              ),
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
              'Cardápio ainda não cadastrado pela gestão.',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ] else ...[
            FoodLine(
              label: 'Prato principal',
              value: valueOrDefault(menu!.mainDish),
            ),
            FoodLine(
              label: 'Acompanhamentos',
              value: valueOrDefault(menu!.sideDishes),
            ),
            FoodLine(
              label: 'Sobremesa',
              value: valueOrDefault(menu!.dessert),
            ),
          ],

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MenuPage(),
                  ),
                );
              },
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Abrir cardápio completo'),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const HomeActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 138,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),

                const Spacer(),

                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
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

class StudentHomeHeader extends StatelessWidget {
  final String nome;
  final String matricula;

  const StudentHomeHeader({
    super.key,
    required this.nome,
    required this.matricula,
  });

  String get primeiroNome {
    final partes = nome.trim().split(' ');

    if (partes.isEmpty || partes.first.isEmpty) {
      return 'estudante';
    }

    return partes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, $primeiroNome!',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          matricula.isEmpty
              ? 'Acompanhe sua ficha, cardápio e janela de atendimento.'
              : 'Matrícula: $matricula',
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 16,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Acompanhe sua ficha, cardápio e janela de atendimento.',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
