import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  String formatarData(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String formatarAtualizacao(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month às $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final MenuService menuService = MenuService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Cardápio',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<MenuModel?>(
          stream: menuService.watchTodayMenu(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final menu = snapshot.data;

            if (menu == null) {
              return const EmptyMenuView();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 520,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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

                      Text(
                        'Atualizado em ${formatarAtualizacao(menu.updatedAt)}',
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
                            MenuInfoCard(
                              icon: Icons.restaurant_menu_rounded,
                              title: 'Prato principal',
                              value: menu.mainDish,
                            ),

                            const SizedBox(height: 12),

                            MenuInfoCard(
                              icon: Icons.rice_bowl_outlined,
                              title: 'Acompanhamentos',
                              value: menu.sideDishes,
                            ),

                            const SizedBox(height: 12),

                            MenuInfoCard(
                              icon: Icons.eco_outlined,
                              title: 'Opção vegetariana',
                              value: menu.vegetarianOption.isEmpty
                                  ? 'Não informada'
                                  : menu.vegetarianOption,
                            ),

                            const SizedBox(height: 12),

                            MenuInfoCard(
                              icon: Icons.icecream_outlined,
                              title: 'Sobremesa',
                              value: menu.dessert.isEmpty
                                  ? 'Não informada'
                                  : menu.dessert,
                            ),

                            const SizedBox(height: 12),

                            MenuInfoCard(
                              icon: Icons.local_drink_outlined,
                              title: 'Bebida',
                              value: menu.drink.isEmpty
                                  ? 'Não informada'
                                  : menu.drink,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (menu.allergens.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Alergênicos: ${menu.allergens}',
                                  style: const TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (menu.allergens.isNotEmpty)
                        const SizedBox(height: 12),

                      if (menu.observations.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  menu.observations,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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

class MenuInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const MenuInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
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

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 16,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyMenuView extends StatelessWidget {
  const EmptyMenuView({super.key});

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
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.primary,
                  size: 56,
                ),
                SizedBox(height: 16),
                Text(
                  'Cardápio ainda não cadastrado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quando a gestão cadastrar o cardápio do dia, ele aparecerá aqui automaticamente.',
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