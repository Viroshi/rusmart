import 'package:flutter/material.dart';
import 'buy_ticket_page.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/food_line.dart';
import '../../widgets/info_box.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  void mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Cardápio do dia',
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cardápio de hoje',
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Confira as refeições disponíveis no Restaurante Universitário.',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const MealSectionCard(
                    icon: Icons.lunch_dining_rounded,
                    title: 'Almoço',
                    time: '11:30 às 13:30',
                    children: [
                      FoodLine(
                        label: 'Prato principal',
                        value: 'Strogonoff de frango',
                      ),
                      FoodLine(
                        label: 'Acompanhamentos',
                        value: 'Arroz branco, feijão, batata palha e salada',
                      ),
                      FoodLine(
                        label: 'Sobremesa',
                        value: 'Gelatina de morango ou fruta do dia',
                      ),
                      FoodLine(label: 'Bebida', value: 'Suco de acerola'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const MealSectionCard(
                    icon: Icons.eco_rounded,
                    title: 'Opção vegetariana',
                    time: 'Disponível durante o almoço',
                    children: [
                      FoodLine(
                        label: 'Prato principal',
                        value: 'Proteína de soja acebolada',
                      ),
                      FoodLine(
                        label: 'Acompanhamentos',
                        value: 'Arroz, feijão, salada de folhas e legumes',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const MealSectionCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Informações alimentares',
                    time: 'Alergênicos e observações',
                    children: [
                      FoodLine(label: 'Contém', value: 'Lactose e soja'),
                      FoodLine(
                        label: 'Observação',
                        value:
                            'Em caso de restrição alimentar, consulte a equipe do RU.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const InfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'O cardápio poderá ser atualizado pela administração do RU. Esta versão ainda usa dados simulados.',
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BuyTicketPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_rounded),
                      label: const Text('Comprar ficha'),
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

class MealSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final List<Widget> children;

  const MealSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }
}
