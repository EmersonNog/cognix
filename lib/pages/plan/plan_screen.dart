import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/plan_widgets.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  String _selectedBillingPeriod = 'mensal';

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF060E20);
    const surfaceContainer = Color(0xFF0F1930);
    const surfaceContainerHigh = Color(0xFF141F38);
    const onSurface = Color(0xFFDEE5FF);
    const onSurfaceMuted = Color(0xFF9AA6C5);
    const primary = Color(0xFFA3A6FF);
    const primaryDim = Color(0xFF6063EE);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            Row(
              children: [
                PlanTopIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).pop(),
                  background: surfaceContainerHigh,
                  iconColor: onSurfaceMuted,
                ),
                const SizedBox(width: 12),
                Text(
                  'COGNIX',
                  style: GoogleFonts.plusJakartaSans(
                    color: primary,
                    fontSize: 15,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                PlanTopIconButton(
                  icon: Icons.help_outline_rounded,
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.3),
                      builder: (BuildContext context) {
                        return PlanHelpModal(
                          primary: primary,
                          primaryDim: primaryDim,
                          onSurface: onSurface,
                          onSurfaceMuted: onSurfaceMuted,
                        );
                      },
                    );
                  },
                  background: surfaceContainerHigh,
                  iconColor: onSurfaceMuted,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Escolha seu Plano',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Eleve seu preparo a um novo patamar\n'
              'com acesso ilimitado e ferramentas\n'
              'exclusivas.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            PlanBillingToggle(
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              selectedPeriod: _selectedBillingPeriod,
              onChanged: (period) {
                setState(() {
                  _selectedBillingPeriod = period;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_selectedBillingPeriod == 'mensal')
              PlanCard(
                title: 'Mensal',
                price: '49,90',
                subtitle: '/mês',
                background: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
                features: const [
                  'Acesso a 20.000+ questões',
                  'Análise de desempenho',
                ],
                buttonStyle: PlanButtonStyle.secondary,
              ),
            if (_selectedBillingPeriod == 'semestral')
              PlanCard(
                title: 'Semestral',
                price: '39,90',
                subtitle: '/mês',
                badge: 'MAIS POPULAR',
                background: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
                primaryDim: primaryDim,
                features: const [
                  'Acesso a 20.000+ questões',
                  'Trilha de estudo personalizadas',
                  'Acesso offline completo',
                ],
                footer: 'TOTAL R\$ 239,40',
                buttonStyle: PlanButtonStyle.primary,
              ),
            if (_selectedBillingPeriod == 'anual')
              PlanCard(
                title: 'Anual',
                price: '29,90',
                subtitle: '/mês',
                background: surfaceContainer,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                primary: primary,
                primaryDim: primaryDim,
                features: const [
                  'Acesso a 20.000+ questões',
                  'Análise de desempenho detalhado',
                  'Trilha inteligente',
                  'Acesso offline completo',
                ],
                footer: 'TOTAL R\$ 318,40',
                buttonStyle: PlanButtonStyle.secondary,
              ),
            const SizedBox(height: 32),
            Text(
              'Benefícios Principais',
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            PlanBenefitItem(
              icon: Icons.library_books_rounded,
              title: '20k+ Questões',
              subtitle: 'Banco de dados completo',
              onSurfaceMuted: onSurfaceMuted,
              onSurface: onSurface,
              surfaceContainer: surfaceContainer,
            ),
            const SizedBox(height: 16),
            PlanBenefitItem(
              icon: Icons.trending_up_rounded,
              title: 'Analytics',
              subtitle: 'Desempenho detalhado',
              onSurfaceMuted: onSurfaceMuted,
              onSurface: onSurface,
              surfaceContainer: surfaceContainer,
            ),
            const SizedBox(height: 16),
            PlanBenefitItem(
              icon: Icons.school_rounded,
              title: 'Personalizado',
              subtitle: 'Trilhas inteligentes',
              onSurfaceMuted: onSurfaceMuted,
              onSurface: onSurface,
              surfaceContainer: surfaceContainer,
            ),
            const SizedBox(height: 16),
            PlanBenefitItem(
              icon: Icons.cloud_off_rounded,
              title: 'Acesso Offline',
              subtitle: 'Estude em qualquer lugar',
              onSurfaceMuted: onSurfaceMuted,
              onSurface: onSurface,
              surfaceContainer: surfaceContainer,
            ),
          ],
        ),
      ),
    );
  }
}
