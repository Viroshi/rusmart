import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/menu_model.dart';
import '../../services/auth_service.dart';
import '../../services/menu_service.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  final MenuService menuService = MenuService();

  final TextEditingController pratoPrincipalController =
      TextEditingController();
  final TextEditingController acompanhamentosController =
      TextEditingController();
  final TextEditingController vegetarianoController = TextEditingController();
  final TextEditingController sobremesaController = TextEditingController();
  final TextEditingController bebidaController = TextEditingController();
  final TextEditingController alergenicosController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  bool carregando = true;
  bool salvando = false;

  @override
  void initState() {
    super.initState();
    carregarCardapio();
  }

  @override
  void dispose() {
    pratoPrincipalController.dispose();
    acompanhamentosController.dispose();
    vegetarianoController.dispose();
    sobremesaController.dispose();
    bebidaController.dispose();
    alergenicosController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  Future<void> carregarCardapio() async {
    try {
      final MenuModel? menu = await menuService.getTodayMenu();

      if (menu != null) {
        pratoPrincipalController.text = menu.mainDish;
        acompanhamentosController.text = menu.sideDishes;
        vegetarianoController.text = menu.vegetarianOption;
        sobremesaController.text = menu.dessert;
        bebidaController.text = menu.drink;
        alergenicosController.text = menu.allergens;
        observacoesController.text = menu.observations;
      }
    } catch (erro) {
      mostrarMensagem('Erro ao carregar cardápio: $erro');
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  Future<void> salvarCardapio() async {
    final pratoPrincipal = pratoPrincipalController.text.trim();
    final acompanhamentos = acompanhamentosController.text.trim();

    if (pratoPrincipal.isEmpty || acompanhamentos.isEmpty) {
      mostrarMensagem('Preencha pelo menos o prato principal e os acompanhamentos.');
      return;
    }

    setState(() {
      salvando = true;
    });

    try {
      final user = AuthService().currentUser;

      await menuService.saveTodayMenu(
        mainDish: pratoPrincipal,
        sideDishes: acompanhamentos,
        vegetarianOption: vegetarianoController.text,
        dessert: sobremesaController.text,
        drink: bebidaController.text,
        allergens: alergenicosController.text,
        observations: observacoesController.text,
        updatedBy: user?.uid ?? 'admin-demo',
      );

      mostrarMensagem('Cardápio salvo com sucesso.');
    } catch (erro) {
      mostrarMensagem('Erro ao salvar cardápio: $erro');
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  void preencherExemplo() {
    pratoPrincipalController.text = 'Frango grelhado ao molho';
    acompanhamentosController.text = 'Arroz branco, feijão carioca e salada';
    vegetarianoController.text = 'Omelete de legumes';
    sobremesaController.text = 'Banana';
    bebidaController.text = 'Suco de acerola';
    alergenicosController.text = 'Ovo, leite e derivados';
    observacoesController.text =
        'Cardápio sujeito a alterações conforme disponibilidade do RU.';
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  String dataDeHojeFormatada() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        title: const Text(
          'Gerenciar cardápio',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: carregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                          'Cardápio do dia',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 28,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Data: ${dataDeHojeFormatada()}',
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
                              AdminMenuField(
                                controller: pratoPrincipalController,
                                label: 'Prato principal',
                                icon: Icons.restaurant_menu_rounded,
                                enabled: !salvando,
                              ),

                              const SizedBox(height: 14),

                              AdminMenuField(
                                controller: acompanhamentosController,
                                label: 'Acompanhamentos',
                                icon: Icons.rice_bowl_outlined,
                                enabled: !salvando,
                                maxLines: 2,
                              ),

                              const SizedBox(height: 14),

                              AdminMenuField(
                                controller: vegetarianoController,
                                label: 'Opção vegetariana',
                                icon: Icons.eco_outlined,
                                enabled: !salvando,
                              ),

                              const SizedBox(height: 14),

                              AdminMenuField(
                                controller: sobremesaController,
                                label: 'Sobremesa',
                                icon: Icons.icecream_outlined,
                                enabled: !salvando,
                              ),

                              const SizedBox(height: 14),

                              AdminMenuField(
                                controller: bebidaController,
                                label: 'Bebida',
                                icon: Icons.local_drink_outlined,
                                enabled: !salvando,
                              ),

                              const SizedBox(height: 14),

                              AdminMenuField(
                                controller: alergenicosController,
                                label: 'Alergênicos',
                                icon: Icons.warning_amber_rounded,
                                enabled: !salvando,
                                maxLines: 2,
                              ),

                              const SizedBox(height: 14),

                              AdminMenuField(
                                controller: observacoesController,
                                label: 'Observações',
                                icon: Icons.notes_rounded,
                                enabled: !salvando,
                                maxLines: 3,
                              ),

                              const SizedBox(height: 22),

                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: OutlinedButton.icon(
                                        onPressed:
                                            salvando ? null : preencherExemplo,
                                        icon: const Icon(
                                          Icons.auto_fix_high_rounded,
                                        ),
                                        label: const Text('Preencher exemplo'),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: FilledButton.icon(
                                        onPressed:
                                            salvando ? null : salvarCardapio,
                                        icon: salvando
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(Icons.save_rounded),
                                        label: Text(
                                          salvando ? 'Salvando...' : 'Salvar',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'O cardápio salvo aqui aparece automaticamente para os alunos na tela de cardápio.',
                                  style: TextStyle(
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
              ),
      ),
    );
  }
}

class AdminMenuField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final int maxLines;

  const AdminMenuField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}