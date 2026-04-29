import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/cognix_theme_colors.dart';

part 'screen/plan_hub_screen_palette.dart';
part 'screen/plan_hub_screen_view.dart';
part 'widgets/plan_hub_hero_card.dart';
part 'widgets/plan_hub_section_title.dart';
part 'widgets/plan_hub_topic_card.dart';

class PlanHubScreen extends StatelessWidget {
  const PlanHubScreen({super.key});

  void _openPlanCatalog(BuildContext context) {
    Navigator.of(context).pushNamed('plan');
  }

  void _openSubscription(BuildContext context) {
    Navigator.of(context).pushNamed('subscription');
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlanHubScreenView(this, context);
  }
}
