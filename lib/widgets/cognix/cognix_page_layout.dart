import 'package:flutter/material.dart';

import 'cognix_top_bar.dart';

class CognixPageLayout extends StatelessWidget {
  const CognixPageLayout({
    super.key,
    required this.title,
    required this.child,
    required this.backgroundColor,
    required this.topBarColor,
    required this.titleColor,
    this.leadingIcon = Icons.school_rounded,
    this.leadingColor = const Color(0xFFA3A6FF),
    this.trailing,
    this.backgroundLayers = const [],
    this.topPadding = 20,
    this.spacing = 16,
  });

  final String title;
  final Widget child;
  final Color backgroundColor;
  final Color topBarColor;
  final Color titleColor;
  final IconData leadingIcon;
  final Color leadingColor;
  final Widget? trailing;
  final List<Widget> backgroundLayers;
  final double topPadding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            ...backgroundLayers,
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, topPadding, 20, 0),
                  child: CognixTopBar(
                    title: title,
                    containerColor: topBarColor,
                    titleColor: titleColor,
                    leadingIcon: leadingIcon,
                    leadingColor: leadingColor,
                    trailing: trailing,
                  ),
                ),
                SizedBox(height: spacing),
                Expanded(child: child),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
