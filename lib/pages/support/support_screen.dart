import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/core/api_client.dart' show readableApiErrorMessage;
import '../../services/profile/profile_api.dart';
import '../../services/subscription/google_play/billing_errors.dart';
import '../../services/subscription/google_play/billing_service.dart';
import '../../services/subscription/google_play/restore_purchases.dart';
import '../../theme/cognix_theme_colors.dart';
import '../../widgets/cognix/cognix_messages.dart';
import '../performance/performance_screen.dart';
import 'widgets/support_app_info_dialog.dart';

part 'support_screen/support_cards.dart';
part 'support_screen/support_faq.dart';
part 'support_screen/support_models.dart';
part 'support_screen/support_palette.dart';
part 'support_screen/support_restore_purchases.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key, this.initialFaqKey});

  final String? initialFaqKey;

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class SupportScreenArgs {
  const SupportScreenArgs({this.initialFaqKey});

  final String? initialFaqKey;
}

class _SupportScreenState extends State<SupportScreen> {
  late final GooglePlayBillingService _googlePlayBilling;
  final _initialFaqCardKey = GlobalKey();
  bool _isRestoringPurchases = false;
  int? _expandedFaqIndex;

  String? get _billingApplicationUserName =>
      FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _googlePlayBilling = GooglePlayBillingService();
    if (_googlePlayBilling.isSupported &&
        widget.initialFaqKey ==
            _SupportFaqKeys.googlePlayExistingSubscription) {
      _expandedFaqIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToInitialFaqCard();
      });
    }
  }

  void _scrollToInitialFaqCard() {
    if (!mounted) {
      return;
    }

    final faqCardContext = _initialFaqCardKey.currentContext;
    if (faqCardContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      faqCardContext,
      alignment: 0.30,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _openStudyPlan(BuildContext context) {
    Navigator.of(context).pushNamed('study-plan');
  }

  Future<void> _openPerformance(
    BuildContext context,
    _SupportPalette palette,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final profile = await fetchProfileScore();
      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PerformanceScreen(
            profile: profile,
            onSurface: palette.onSurface,
            onSurfaceMuted: palette.onSurfaceMuted,
            primary: palette.primary,
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      showCognixMessage(
        context,
        'Não foi possível abrir a análise agora. Tente novamente.',
        type: CognixMessageType.error,
      );
    }
  }

  Future<void> _restorePurchases() async {
    if (_isRestoringPurchases) {
      return;
    }

    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      final result = await restoreGooglePlayPurchases(
        applicationUserName: _billingApplicationUserName,
        billingService: _googlePlayBilling,
      );
      if (!mounted) {
        return;
      }
      _handleRestorePurchasesResult(result);
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showRestorePurchasesError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isRestoringPurchases = false;
        });
      }
    }
  }

  List<_SupportFaqItem> _buildFaqItems() {
    return [
      if (_googlePlayBilling.isSupported)
        const _SupportFaqItem(
          faqKey: _SupportFaqKeys.googlePlayExistingSubscription,
          question:
              'Por que aparece que a conta Google Play já tem assinatura?',
          answer:
              'Isso acontece quando a conta Google Play usada no checkout já possui uma assinatura ativa do Cognix.\n\n'
              'A assinatura fica vinculada a uma conta Cognix por vez. Para usar o Premium, entre na conta Cognix onde ela foi ativada.\n\n'
              'Se quiser assinar nesta conta, cancele a assinatura atual no Google Play e aguarde o fim do período pago antes de assinar novamente.',
        ),
      if (_googlePlayBilling.isSupported)
        _SupportFaqItem(
          question:
              'Comprei no Google Play, por que o acesso não foi liberado?',
          answer:
              'Se a compra já foi concluída, mas o acesso ainda não apareceu no app, você pode tentar restaurar a assinatura vinculada a está conta Google Play.',
          actionLabel: 'Restaurar compra agora',
          actionLoadingLabel: 'Restaurando compra...',
          actionIcon: Icons.restore_rounded,
          onActionTap: _isRestoringPurchases ? null : _restorePurchases,
          isActionLoading: _isRestoringPurchases,
        ),
      ..._supportFaqItems,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final palette = _SupportPalette.fromContext(context);
    final faqItems = _buildFaqItems();

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        backgroundColor: palette.surface,
        surfaceTintColor: palette.surface,
        foregroundColor: palette.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Suporte e Ajuda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SupportHeroCard(palette: palette),
            const SizedBox(height: 24),
            _SectionTitle(
              palette: palette,
              title: 'Temas principais',
              subtitle:
                  'Atalhos para os assuntos que mais ajudam no uso diário do app.',
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              palette: palette,
              icon: Icons.flag_rounded,
              title: 'Plano e metas',
              subtitle:
                  'Ritmo semanal, volume de estudo e prioridades do seu planejamento.',
              accent: palette.secondary,
              onTap: () => _openStudyPlan(context),
            ),
            const SizedBox(height: 12),
            _SupportTopicCard(
              palette: palette,
              icon: Icons.analytics_rounded,
              title: 'Treino e desempenho',
              subtitle:
                  'Simulados, recomendações e leitura dos seus indicadores recentes.',
              accent: palette.accent,
              onTap: () => _openPerformance(context, palette),
            ),
            const SizedBox(height: 24),
            _SectionTitle(
              palette: palette,
              title: 'Perguntas frequentes',
              subtitle:
                  'Respostas rápidas para os pontos mais comuns do seu uso diário.',
            ),
            const SizedBox(height: 12),
            ...faqItems.indexed.map(
              (entry) => Padding(
                key: entry.$2.faqKey == widget.initialFaqKey
                    ? _initialFaqCardKey
                    : null,
                padding: const EdgeInsets.only(bottom: 12),
                child: _SupportFaqCard(
                  palette: palette,
                  item: entry.$2,
                  isExpanded: _expandedFaqIndex == entry.$1,
                  onTap: () {
                    setState(() {
                      _expandedFaqIndex = _expandedFaqIndex == entry.$1
                          ? null
                          : entry.$1;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            _SupportInfoCard(
              palette: palette,
              onShowAbout: () => showSupportAppInfoDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
