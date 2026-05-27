import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/food_line.dart';
import '../../widgets/info_box.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  final TextEditingController pratoPrincipalController =
      TextEditingController(text: 'Strogonoff de frango');

  final TextEditingController acompanhamentosController =
      TextEditingController(
    text: 'Arroz branco, feijão, batata palha e salada',
  );

  final TextEditingController vegetarianoController =
      TextEditingController(text: 'Proteína de soja acebolada');

  final TextEditingController sobremesaController =
      TextEditingController(text: 'Gelatina de morango ou fruta');

  final TextEditingController bebidaController =
      TextEditingController(text: 'Suco de acerola');

  final TextEditingController observacoesController = TextEditingController(
    text: 'Contém lactose e soja. Consulte a equipe em caso de restrição.',
  );

  final Set<String> alergenosSelecionados = {
    'Lactose',
    'Soja',
  };

  final List<String> alergenos = [
    'Lactose',
    'Glúten',
    'Soja',
    'Ovo',
    'Amendoim',
    'Frutos do mar',
  ];

  @override
  void dispose() {
    pratoPrincipalController.dispose();
    acompanhamentosController.dispose();
    vegetarianoController.dispose();
    sobremesaController.dispose();
    bebidaController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  void salvarCardapio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cardápio salvo no protótipo.'),
      ),
    );
  }

  void atualizarPreview(String value) {
    setState(() {});
  }

  void alternarAlergeno(String alergeno, bool selecionado) {
    setState(() {
      if (selecionado) {
        alergenosSelecionados.add(alergeno);
      } else {
        alergenosSelecionados.remove(alergeno);
      }
    });
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool telaLarga = constraints.maxWidth >= 820;

                  if (telaLarga) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: FormularioCardapio(
                            pratoPrincipalController:
                                pratoPrincipalController,
                            acompanhamentosController:
                                acompanhamentosController,
                            vegetarianoController: vegetarianoController,
                            sobremesaController: sobremesaController,
                            bebidaController: bebidaController,
                            observacoesController: observacoesController,
                            alergenos: alergenos,
                            alergenosSelecionados: alergenosSelecionados,
                            onChanged: atualizarPreview,
                            onAlergenoChanged: alternarAlergeno,
                            onSalvar: salvarCardapio,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: PreviewCardapio(
                            pratoPrincipal: pratoPrincipalController.text,
                            acompanhamentos: acompanhamentosController.text,
                            vegetariano: vegetarianoController.text,
                            sobremesa: sobremesaController.text,
                            bebida: bebidaController.text,
                            observacoes: observacoesController.text,
                            alergenosSelecionados: alergenosSelecionados,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      FormularioCardapio(
                        pratoPrincipalController: pratoPrincipalController,
                        acompanhamentosController:
                            acompanhamentosController,
                        vegetarianoController: vegetarianoController,
                        sobremesaController: sobremesaController,
                        bebidaController: bebidaController,
                        observacoesController: observacoesController,
                        alergenos: alergenos,
                        alergenosSelecionados: alergenosSelecionados,
                        onChanged: atualizarPreview,
                        onAlergenoChanged: alternarAlergeno,
                        onSalvar: salvarCardapio,
                      ),
                      const SizedBox(height: 16),
                      PreviewCardapio(
                        pratoPrincipal: pratoPrincipalController.text,
                        acompanhamentos: acompanhamentosController.text,
                        vegetariano: vegetarianoController.text,
                        sobremesa: sobremesaController.text,
                        bebida: bebidaController.text,
                        observacoes: observacoesController.text,
                        alergenosSelecionados: alergenosSelecionados,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormularioCardapio extends StatelessWidget {
  final TextEditingController pratoPrincipalController;
  final TextEditingController acompanhamentosController;
  final TextEditingController vegetarianoController;
  final TextEditingController sobremesaController;
  final TextEditingController bebidaController;
  final TextEditingController observacoesController;

  final List<String> alergenos;
  final Set<String> alergenosSelecionados;

  final ValueChanged<String> onChanged;
  final void Function(String alergeno, bool selecionado) onAlergenoChanged;
  final VoidCallback onSalvar;

  const FormularioCardapio({
    super.key,
    required this.pratoPrincipalController,
    required this.acompanhamentosController,
    required this.vegetarianoController,
    required this.sobremesaController,
    required this.bebidaController,
    required this.observacoesController,
    required this.alergenos,
    required this.alergenosSelecionados,
    required this.onChanged,
    required this.onAlergenoChanged,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cadastro do cardápio do dia',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Atualize as informações que serão exibidas para os alunos.',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: pratoPrincipalController,
            onChanged: onChanged,
            decoration: const InputDecoration(
              labelText: 'Prato principal',
              prefixIcon: Icon(Icons.restaurant_rounded),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: acompanhamentosController,
            onChanged: onChanged,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Acompanhamentos',
              prefixIcon: Icon(Icons.rice_bowl_outlined),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: vegetarianoController,
            onChanged: onChanged,
            decoration: const InputDecoration(
              labelText: 'Opção vegetariana',
              prefixIcon: Icon(Icons.eco_rounded),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: sobremesaController,
            onChanged: onChanged,
            decoration: const InputDecoration(
              labelText: 'Sobremesa',
              prefixIcon: Icon(Icons.icecream_outlined),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: bebidaController,
            onChanged: onChanged,
            decoration: const InputDecoration(
              labelText: 'Bebida',
              prefixIcon: Icon(Icons.local_drink_outlined),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Alergênicos',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: alergenos.map(
              (alergeno) {
                final bool selecionado =
                    alergenosSelecionados.contains(alergeno);

                return FilterChip(
                  label: Text(alergeno),
                  selected: selecionado,
                  selectedColor: AppColors.primaryFixed.withOpacity(0.9),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selecionado
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight:
                        selecionado ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: selecionado
                        ? AppColors.primaryFixedDim
                        : AppColors.outlineVariant,
                  ),
                  onSelected: (value) {
                    onAlergenoChanged(alergeno, value);
                  },
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: observacoesController,
            onChanged: onChanged,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Observações',
              prefixIcon: Icon(Icons.info_outline_rounded),
            ),
          ),

          const SizedBox(height: 18),

          const InfoBox(
            icon: Icons.info_outline_rounded,
            text:
                'No sistema real, esse formulário atualizará o cardápio exibido no aplicativo dos alunos.',
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: onSalvar,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Salvar cardápio'),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewCardapio extends StatelessWidget {
  final String pratoPrincipal;
  final String acompanhamentos;
  final String vegetariano;
  final String sobremesa;
  final String bebida;
  final String observacoes;
  final Set<String> alergenosSelecionados;

  const PreviewCardapio({
    super.key,
    required this.pratoPrincipal,
    required this.acompanhamentos,
    required this.vegetariano,
    required this.sobremesa,
    required this.bebida,
    required this.observacoes,
    required this.alergenosSelecionados,
  });

  @override
  Widget build(BuildContext context) {
    final String alergenos = alergenosSelecionados.isEmpty
        ? 'Nenhum informado'
        : alergenosSelecionados.join(', ');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.smartphone_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Prévia para o aluno',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Almoço',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            '11:30 às 13:30',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 18),

          FoodLine(
            label: 'Prato principal',
            value: pratoPrincipal.isEmpty ? 'Não informado' : pratoPrincipal,
          ),

          FoodLine(
            label: 'Acompanhamentos',
            value:
                acompanhamentos.isEmpty ? 'Não informado' : acompanhamentos,
          ),

          FoodLine(
            label: 'Opção vegetariana',
            value: vegetariano.isEmpty ? 'Não informado' : vegetariano,
          ),

          FoodLine(
            label: 'Sobremesa',
            value: sobremesa.isEmpty ? 'Não informado' : sobremesa,
          ),

          FoodLine(
            label: 'Bebida',
            value: bebida.isEmpty ? 'Não informado' : bebida,
          ),

          FoodLine(
            label: 'Alergênicos',
            value: alergenos,
          ),

          const SizedBox(height: 10),

          InfoBox(
            icon: Icons.warning_amber_rounded,
            color: AppColors.secondary,
            text: observacoes.isEmpty
                ? 'Nenhuma observação informada.'
                : observacoes,
          ),
        ],
      ),
    );
  }
}