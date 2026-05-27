import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController pageController = PageController();

  int paginaAtual = 0;

  final List<OnboardingItem> itens = const [
    OnboardingItem(
      icon: Icons.restaurant_menu_rounded,
      title: 'Veja o cardápio do dia',
      description:
          'Consulte as refeições disponíveis antes de ir ao Restaurante Universitário.',
    ),
    OnboardingItem(
      icon: Icons.pix_rounded,
      title: 'Compre sua ficha pelo app',
      description:
          'Gere o pagamento via Pix antecipadamente e evite a fila física de compra.',
    ),
    OnboardingItem(
      icon: Icons.qr_code_2_rounded,
      title: 'Use o QR Code no atendimento',
      description:
          'Após o pagamento, apresente o QR Code no RU para validar sua refeição.',
    ),
    OnboardingItem(
      icon: Icons.rate_review_rounded,
      title: 'Avalie sua refeição',
      description:
          'Depois de comer, envie um feedback para ajudar a gestão a melhorar o serviço.',
    ),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void avancar() {
    final bool ultimaPagina = paginaAtual == itens.length - 1;

    if (ultimaPagina) {
      Navigator.pop(context);
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void pular() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool ultimaPagina = paginaAtual == itens.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: pular,
                  child: const Text('Pular'),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: itens.length,
                  onPageChanged: (index) {
                    setState(() {
                      paginaAtual = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingSlide(
                      item: itens[index],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  itens.length,
                  (index) {
                    final bool selecionado = index == paginaAtual;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: selecionado ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selecionado
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: avancar,
                  icon: Icon(
                    ultimaPagina
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                  label: Text(
                    ultimaPagina ? 'Entendi' : 'Próximo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingSlide({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 430,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryFixedDim.withOpacity(0.35),
                    blurRadius: 28,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                item.icon,
                size: 82,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 36),

            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 26,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              item.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 17,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}