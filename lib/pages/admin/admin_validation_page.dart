import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/app_card.dart';
import '../../widgets/fake_qr_code.dart';
import '../../widgets/info_box.dart';
import '../../widgets/status_chip.dart';

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({super.key});

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  final TextEditingController codigoController = TextEditingController();

  bool validado = false;

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  void simularLeitura() {
    setState(() {
      validado = true;
      codigoController.text = 'RU-2024-0012';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code validado no protótipo.'),
      ),
    );
  }

  void limparValidacao() {
    setState(() {
      validado = false;
      codigoController.clear();
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
          'Validação de ficha',
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
                maxWidth: 900,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool telaLarga = constraints.maxWidth >= 780;

                  if (telaLarga) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ScannerSimuladoCard(
                            onSimularLeitura: simularLeitura,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              ResultadoValidacaoCard(
                                validado: validado,
                                onLimpar: limparValidacao,
                              ),
                              const SizedBox(height: 16),
                              EntradaManualCard(
                                controller: codigoController,
                                onValidar: simularLeitura,
                              ),
                              const SizedBox(height: 16),
                              const HistoricoValidacoesCard(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      ScannerSimuladoCard(
                        onSimularLeitura: simularLeitura,
                      ),
                      const SizedBox(height: 16),
                      ResultadoValidacaoCard(
                        validado: validado,
                        onLimpar: limparValidacao,
                      ),
                      const SizedBox(height: 16),
                      EntradaManualCard(
                        controller: codigoController,
                        onValidar: simularLeitura,
                      ),
                      const SizedBox(height: 16),
                      const HistoricoValidacoesCard(),
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

class ScannerSimuladoCard extends StatelessWidget {
  final VoidCallback onSimularLeitura;

  const ScannerSimuladoCard({
    super.key,
    required this.onSimularLeitura,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Text(
            'Leitor de QR Code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Simulação da leitura feita no atendimento.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          const FakeQrCode(
            size: 210,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: onSimularLeitura,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Simular leitura'),
            ),
          ),

          const SizedBox(height: 12),

          const InfoBox(
            icon: Icons.info_outline_rounded,
            text:
                'No sistema real, a câmera ou leitor validará o QR Code gerado pelo app do aluno.',
          ),
        ],
      ),
    );
  }
}

class ResultadoValidacaoCard extends StatelessWidget {
  final bool validado;
  final VoidCallback onLimpar;

  const ResultadoValidacaoCard({
    super.key,
    required this.validado,
    required this.onLimpar,
  });

  @override
  Widget build(BuildContext context) {
    if (!validado) {
      return const AppCard(
        child: Column(
          children: [
            Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.outline,
              size: 64,
            ),
            SizedBox(height: 12),
            Text(
              'Aguardando validação',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Escaneie um QR Code ou digite o código da ficha manualmente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.secondary,
              size: 72,
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Ficha validada!',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const StatusChip(
            icon: Icons.verified_rounded,
            text: 'Acesso liberado',
            color: AppColors.secondary,
          ),

          const SizedBox(height: 18),

          const ValidationInfoRow(
            icon: Icons.person_outline_rounded,
            title: 'Aluno',
            value: 'Estudante RU Smart',
          ),

          const Divider(
            height: 28,
            color: AppColors.outlineVariant,
          ),

          const ValidationInfoRow(
            icon: Icons.badge_outlined,
            title: 'Matrícula',
            value: '2024000000',
          ),

          const Divider(
            height: 28,
            color: AppColors.outlineVariant,
          ),

          const ValidationInfoRow(
            icon: Icons.restaurant_rounded,
            title: 'Refeição',
            value: 'Almoço',
          ),

          const Divider(
            height: 28,
            color: AppColors.outlineVariant,
          ),

          const ValidationInfoRow(
            icon: Icons.schedule_rounded,
            title: 'Horário validado',
            value: '12:24',
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onLimpar,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Nova validação'),
            ),
          ),
        ],
      ),
    );
  }
}

class EntradaManualCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onValidar;

  const EntradaManualCard({
    super.key,
    required this.controller,
    required this.onValidar,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entrada manual',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Use caso o QR Code não possa ser lido pela câmera.',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Código da ficha ou matrícula',
              prefixIcon: Icon(Icons.keyboard_outlined),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onValidar,
              icon: const Icon(Icons.verified_outlined),
              label: const Text('Validar manualmente'),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoricoValidacoesCard extends StatelessWidget {
  const HistoricoValidacoesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimas validações',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: 14),

          ValidationHistoryLine(
            aluno: 'Mariana Silva',
            horario: '12:24',
            codigo: 'RU-2024-0012',
          ),

          Divider(
            height: 24,
            color: AppColors.outlineVariant,
          ),

          ValidationHistoryLine(
            aluno: 'Carlos Eduardo',
            horario: '12:21',
            codigo: 'RU-2024-0011',
          ),

          Divider(
            height: 24,
            color: AppColors.outlineVariant,
          ),

          ValidationHistoryLine(
            aluno: 'Ana Beatriz',
            horario: '12:18',
            codigo: 'RU-2024-0010',
          ),
        ],
      ),
    );
  }
}

class ValidationInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ValidationInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ValidationHistoryLine extends StatelessWidget {
  final String aluno;
  final String horario;
  final String codigo;

  const ValidationHistoryLine({
    super.key,
    required this.aluno,
    required this.horario,
    required this.codigo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: AppColors.primaryFixed,
          child: Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                aluno,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                codigo,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        Text(
          horario,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}