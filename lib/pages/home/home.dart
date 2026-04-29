import 'dart:async';

import 'package:cognix/widgets/cognix_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../navigation/app_route_observer.dart';
import '../../services/entitlements/entitlements_api.dart';
import '../../services/recommendations/home_recommendations_api.dart';
import '../../services/profile/profile_api.dart';
import '../../services/profile/profile_refresh_notifier.dart';
import '../../services/study_plan/study_plan_api.dart';
import '../../services/study_plan/study_plan_refresh_notifier.dart';
import '../../theme/app_theme_controller.dart';
import '../../theme/app_theme_scope.dart';
import '../../theme/cognix_theme_colors.dart';
import 'home_tab.dart';
import 'widgets/shell/home_shell_widgets.dart';
import '../performance/performance_screen.dart';
import '../plan/plan_screen.dart';
import '../profile/profile.dart';
import '../training/tab/training_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.showPlanOnStart = false});

  final bool showPlanOnStart;

  @override
  State<Home> createState() => _HomeState();
}

class HomeRouteArgs {
  const HomeRouteArgs({this.showPlanOnStart = false});

  final bool showPlanOnStart;
}

class _HomeState extends State<Home> with RouteAware {
  bool _isLoading = false;
  int _currentIndex = 0;
  late Future<ProfileScoreData> _profileFuture;
  late Future<EntitlementStatus> _entitlementsFuture;
  late Future<HomeRecommendationsData> _recommendationsFuture;
  late Future<StudyPlanData> _studyPlanFuture;
  bool _isRouteObserverSubscribed = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchSharedProfileScore();
    _entitlementsFuture = _fetchSharedEntitlements();
    _recommendationsFuture = _fetchSharedRecommendations();
    _studyPlanFuture = _fetchSharedStudyPlan();
    if (widget.showPlanOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushNamed(
          'plan',
          arguments: const PlanScreenArgs(showSkipAction: true),
        );
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isRouteObserverSubscribed) return;
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      appRouteObserver.subscribe(this, route);
      _isRouteObserverSubscribed = true;
    }
  }

  Future<ProfileScoreData> _fetchSharedProfileScore() async {
    return fetchProfileScore();
  }

  Future<EntitlementStatus> _fetchSharedEntitlements() async {
    return fetchCurrentEntitlements();
  }

  Future<StudyPlanData> _fetchSharedStudyPlan() async {
    return fetchStudyPlan();
  }

  Future<HomeRecommendationsData> _fetchSharedRecommendations() async {
    return fetchHomeRecommendations();
  }

  Future<void> _refreshSharedHubData() async {
    final nextProfileFuture = _fetchSharedProfileScore();
    final nextEntitlementsFuture = _fetchSharedEntitlements();
    final nextRecommendationsFuture = _fetchSharedRecommendations();
    final nextStudyPlanFuture = _fetchSharedStudyPlan();
    if (mounted) {
      setState(() {
        _profileFuture = nextProfileFuture;
        _entitlementsFuture = nextEntitlementsFuture;
        _recommendationsFuture = nextRecommendationsFuture;
        _studyPlanFuture = nextStudyPlanFuture;
      });
    }

    try {
      await nextProfileFuture;
    } catch (_) {}
    try {
      await nextEntitlementsFuture;
    } catch (_) {}
    try {
      await nextRecommendationsFuture;
    } catch (_) {}
    try {
      await nextStudyPlanFuture;
    } catch (_) {}
  }

  @override
  void didPopNext() {
    final shouldRefreshProfile = profileRefreshNotifier.consumeDirty();
    final shouldRefreshStudyPlan = studyPlanRefreshNotifier.consumeDirty();
    if (shouldRefreshProfile || shouldRefreshStudyPlan) {
      unawaited(_refreshSharedHubData());
      return;
    }

    if (mounted) {
      setState(() {
        _entitlementsFuture = _fetchSharedEntitlements();
      });
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('login');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    if (_isRouteObserverSubscribed) {
      appRouteObserver.unsubscribe(this);
    }
    super.dispose();
  }

  void _setCurrentIndex(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() => _currentIndex = index);
  }

  void _openPremiumPlans() {
    Navigator.of(context).pushNamed('plan');
  }

  void _openSubscriptionOverview() {
    Navigator.of(context).pushNamed('subscription');
  }

  String get _userName {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.displayName ?? 'Usuário';
  }

  List<Widget> _buildTabs(_HomePalette palette) {
    return <Widget>[
      HomeTab(
        profileFuture: _profileFuture,
        entitlementsFuture: _entitlementsFuture,
        recommendationsFuture: _recommendationsFuture,
        studyPlanFuture: _studyPlanFuture,
        surfaceContainer: palette.surfaceContainer,
        surfaceContainerHigh: palette.surfaceContainerHigh,
        onSurface: palette.onSurface,
        onSurfaceMuted: palette.onSurfaceMuted,
        primary: palette.primary,
        primaryDim: palette.primaryDim,
        accent: palette.accent,
        success: palette.success,
        danger: palette.danger,
        userName: _userName,
        onRefresh: _refreshSharedHubData,
        onOpenPremium: _openPremiumPlans,
        onManageSubscription: _openSubscriptionOverview,
      ),
      TrainingTab(
        surfaceContainer: palette.surfaceContainer,
        surfaceContainerHigh: palette.surfaceContainerHigh,
        onSurface: palette.onSurface,
        onSurfaceMuted: palette.onSurfaceMuted,
        primary: palette.primary,
        onRefreshHubData: _refreshSharedHubData,
      ),
      PerformanceScreen.embedded(
        profileFuture: _profileFuture,
        onSurface: palette.onSurface,
        onSurfaceMuted: palette.onSurfaceMuted,
        primary: palette.primary,
        onRefresh: _refreshSharedHubData,
      ),
      ProfileTab(
        profileFuture: _profileFuture,
        surfaceContainer: palette.surfaceContainer,
        surfaceContainerHigh: palette.surfaceContainerHigh,
        onSurface: palette.onSurface,
        onSurfaceMuted: palette.onSurfaceMuted,
        primary: palette.primary,
        primaryDim: palette.primaryDim,
        userName: _userName,
        onRefresh: _refreshSharedHubData,
      ),
    ];
  }

  List<Widget> _buildBackgroundLayers(_HomePalette palette) {
    return <Widget>[
      Positioned(
        top: -90,
        right: -40,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                palette.secondaryDim.withValues(alpha: 0.55),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 120,
        left: -60,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                palette.primary.withValues(alpha: 0.28),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final palette = _HomePalette.fromContext(context);
    final themeController = AppThemeScope.of(context);

    return Scaffold(
      backgroundColor: palette.surface,
      body: CognixPageLayout(
        title: 'Cognix Hub',
        backgroundColor: palette.surface,
        topBarColor: palette.surfaceContainerHigh,
        titleColor: palette.onSurface,
        leadingColor: palette.primary,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeThemeButton(
              preference: themeController.preference,
              onPressed: () => _showThemeSheet(context, themeController),
              backgroundColor: palette.surfaceContainer,
              iconColor: palette.onSurfaceMuted,
            ),
            const SizedBox(width: 8),
            HomeLogoutButton(
              isLoading: _isLoading,
              onPressed: _handleLogout,
              backgroundColor: palette.surfaceContainer,
              iconColor: palette.onSurfaceMuted,
            ),
          ],
        ),
        backgroundLayers: _buildBackgroundLayers(palette),
        child: IndexedStack(
          index: _currentIndex,
          children: _buildTabs(palette),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: _currentIndex,
        onSelected: _setCurrentIndex,
        surfaceContainer: palette.surfaceContainer,
        surfaceContainerHigh: palette.surfaceContainerHigh,
        primary: palette.primary,
        onSurfaceMuted: palette.onSurfaceMuted,
      ),
    );
  }

  Future<void> _showThemeSheet(
    BuildContext context,
    AppThemeController themeController,
  ) async {
    final theme = Theme.of(context);
    final colors = context.cognixColors;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aparência',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Escolha como o Cognix deve aparecer para você.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                for (final preference in AppThemePreference.values)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(switch (preference) {
                      AppThemePreference.system =>
                        Icons.brightness_auto_rounded,
                      AppThemePreference.light => Icons.light_mode_rounded,
                      AppThemePreference.dark => Icons.dark_mode_rounded,
                    }, color: colors.primary),
                    title: Text(
                      preference.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: themeController.preference == preference
                        ? Icon(Icons.check_rounded, color: colors.success)
                        : null,
                    onTap: () async {
                      await themeController.setPreference(preference);
                      if (!sheetContext.mounted) return;
                      Navigator.of(sheetContext).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomePalette {
  const _HomePalette({
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primaryDim,
    required this.primary,
    required this.secondaryDim,
    required this.accent,
    required this.success,
    required this.danger,
  });

  factory _HomePalette.fromContext(BuildContext context) {
    final colors = context.cognixColors;
    return _HomePalette(
      surface: colors.surface,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      onSurface: colors.onSurface,
      onSurfaceMuted: colors.onSurfaceMuted,
      primaryDim: colors.primaryDim,
      primary: colors.primary,
      secondaryDim: colors.secondaryDim,
      accent: colors.accent,
      success: colors.success,
      danger: colors.danger,
    );
  }

  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primaryDim;
  final Color primary;
  final Color secondaryDim;
  final Color accent;
  final Color success;
  final Color danger;
}
