import 'dart:math' as math;

import 'package:flutter/material.dart';

class OnboardingLayout {
  const OnboardingLayout({
    required this.shortScreen,
    required this.denseScreen,
    required this.compactScreen,
    required this.denseWidth,
    required this.illustrationHeight,
    required this.illustrationHaloSize,
    required this.illustrationBaseWidth,
    required this.illustrationBaseHeight,
    required this.illustrationImageWidth,
    required this.illustrationStackWidth,
    required this.illustrationHaloTop,
    required this.bodyFontSize,
    required this.bodySpacing,
    required this.panelHorizontalPadding,
    required this.panelTopPadding,
    required this.panelBottomPadding,
    required this.highlightsHeaderSpacing,
    required this.highlightsSpacing,
    required this.horizontalMargin,
    required this.titleFontSize,
    required this.pageBodyFontSize,
    required this.imageFlex,
    required this.bodyFlex,
    required this.imageTopPadding,
    required this.imageBottomPadding,
    required this.titleTopPadding,
    required this.titleBottomPadding,
    required this.safeArea,
    required this.controlsTopPadding,
    required this.controlsBottomPadding,
  });

  factory OnboardingLayout.fromSize(Size size) {
    final shortScreen = size.height < 760;
    final denseScreen = size.height < 700;
    final compactScreen = size.width < 380;
    final denseWidth = size.width < 360;

    final illustrationHeight = denseScreen
        ? 176.0
        : shortScreen
        ? 216.0
        : 260.0;
    final illustrationHaloSize = denseScreen
        ? 150.0
        : shortScreen
        ? 186.0
        : 220.0;
    final illustrationBaseWidth = denseScreen
        ? 208.0
        : shortScreen
        ? 234.0
        : 260.0;
    final illustrationBaseHeight = denseScreen
        ? 100.0
        : shortScreen
        ? 118.0
        : 140.0;
    final illustrationImageWidth = denseScreen
        ? 188.0
        : shortScreen
        ? 228.0
        : 280.0;

    return OnboardingLayout(
      shortScreen: shortScreen,
      denseScreen: denseScreen,
      compactScreen: compactScreen,
      denseWidth: denseWidth,
      illustrationHeight: illustrationHeight,
      illustrationHaloSize: illustrationHaloSize,
      illustrationBaseWidth: illustrationBaseWidth,
      illustrationBaseHeight: illustrationBaseHeight,
      illustrationImageWidth: illustrationImageWidth,
      illustrationStackWidth: math.max(
        illustrationBaseWidth,
        math.max(illustrationHaloSize, illustrationImageWidth),
      ),
      illustrationHaloTop: denseScreen ? 2.0 : 10.0,
      bodyFontSize: denseWidth
          ? 16.0
          : compactScreen || shortScreen
          ? 16.0
          : 18.0,
      bodySpacing: shortScreen ? 14.0 : 18.0,
      panelHorizontalPadding: denseWidth ? 12.0 : 14.0,
      panelTopPadding: shortScreen ? 12.0 : 14.0,
      panelBottomPadding: shortScreen
          ? 12.0
          : compactScreen
          ? 14.0
          : 16.0,
      highlightsHeaderSpacing: shortScreen ? 8.0 : 10.0,
      highlightsSpacing: denseWidth ? 6.0 : 8.0,
      horizontalMargin: size.width < 360
          ? 16.0
          : size.width < 390
          ? 20.0
          : 28.0,
      titleFontSize: denseScreen
          ? 26.0
          : shortScreen
          ? 28.0
          : 30.0,
      pageBodyFontSize: shortScreen ? 17.0 : 18.0,
      imageFlex: shortScreen ? 4 : 1,
      bodyFlex: shortScreen ? 5 : 1,
      imageTopPadding: denseScreen
          ? 8.0
          : shortScreen
          ? 16.0
          : 32.0,
      imageBottomPadding: shortScreen ? 8.0 : 12.0,
      titleTopPadding: denseScreen
          ? 8.0
          : shortScreen
          ? 10.0
          : 16.0,
      titleBottomPadding: shortScreen ? 16.0 : 24.0,
      safeArea: shortScreen ? 72.0 : 60.0,
      controlsTopPadding: shortScreen ? 8.0 : 16.0,
      controlsBottomPadding: shortScreen ? 10.0 : 16.0,
    );
  }

  final bool shortScreen;
  final bool denseScreen;
  final bool compactScreen;
  final bool denseWidth;
  final double illustrationHeight;
  final double illustrationHaloSize;
  final double illustrationBaseWidth;
  final double illustrationBaseHeight;
  final double illustrationImageWidth;
  final double illustrationStackWidth;
  final double illustrationHaloTop;
  final double bodyFontSize;
  final double bodySpacing;
  final double panelHorizontalPadding;
  final double panelTopPadding;
  final double panelBottomPadding;
  final double highlightsHeaderSpacing;
  final double highlightsSpacing;
  final double horizontalMargin;
  final double titleFontSize;
  final double pageBodyFontSize;
  final int imageFlex;
  final int bodyFlex;
  final double imageTopPadding;
  final double imageBottomPadding;
  final double titleTopPadding;
  final double titleBottomPadding;
  final double safeArea;
  final double controlsTopPadding;
  final double controlsBottomPadding;

  bool get compactHighlights => compactScreen || shortScreen;
}
