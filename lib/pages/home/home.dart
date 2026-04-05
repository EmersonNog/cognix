import 'package:cognix/widgets/cognix_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../navigation/app_route_observer.dart';
import '../../services/recommendations/home_recommendations_api.dart';
import '../../services/profile/profile_api.dart';
import '../../services/profile/profile_refresh_notifier.dart';
import '../../services/study_plan/study_plan_api.dart';
import '../../services/study_plan/study_plan_refresh_notifier.dart';
import 'home_tab.dart';
import 'widgets/shell/home_shell_widgets.dart';
import '../performance/performance_screen.dart';
import '../profile/profile.dart';
import '../training/training_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  bool _isLoading = false;
  int _currentIndex = 0;
  late Future<ProfileScoreData> _profileFuture;
  late Future<HomeRecommendationsData> _recommendationsFuture;
  late Future<StudyPlanData> _studyPlanFuture;
  bool _isRouteObserverSubscribed = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchSharedProfileScore();
    _recommendationsFuture = _fetchSharedRecommendations();
    _studyPlanFuture = _fetchSharedStudyPlan();
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

  Future<StudyPlanData> _fetchSharedStudyPlan() async {
    return fetchStudyPlan();
  }

  Future<HomeRecommendationsData> _fetchSharedRecommendations() async {
    return fetchHomeRecommendations();
  }

  Future<void> _refreshSharedHubData() async {
    final nextProfileFuture = _fetchSharedProfileScore();
    final nextRecommendationsFuture = _fetchSharedRecommendations();
    final nextStudyPlanFuture = _fetchSharedStudyPlan();
    if (mounted) {
      setState(() {
        _profileFuture = nextProfileFuture;
        _recommendationsFuture = nextRecommendationsFuture;
        _studyPlanFuture = nextStudyPlanFuture;
      });
    }

    try {
      await nextProfileFuture;
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
      _refreshSharedHubData();
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

  String get _userName {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.displayName ?? 'Usuário';
  }

  List<Widget> _buildTabs(_HomePalette palette) {
    return <Widget>[
      HomeTab(
        profileFuture: _profileFuture,
        recommendationsFuture: _recommendationsFuture,
        studyPlanFuture: _studyPlanFuture,
        surfaceContainer: palette.surfaceContainer,
        surfaceContainerHigh: palette.surfaceContainerHigh,
        onSurface: palette.onSurface,
        onSurfaceMuted: palette.onSurfaceMuted,
        primary: palette.primary,
        primaryDim: palette.primaryDim,
        userName: _userName,
        onRefresh: _refreshSharedHubData,
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
    const palette = _HomePalette();

    return Scaffold(
      backgroundColor: palette.surface,
      body: CognixPageLayout(
        title: 'Cognix Hub',
        backgroundColor: palette.surface,
        topBarColor: palette.surfaceContainerHigh,
        titleColor: palette.onSurface,
        leadingColor: palette.primary,
        trailing: HomeLogoutButton(
          isLoading: _isLoading,
          onPressed: _handleLogout,
          backgroundColor: palette.surfaceContainer,
          iconColor: palette.onSurfaceMuted,
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
}

class _HomePalette {
  const _HomePalette();

  final Color surface = const Color(0xFF060E20);
  final Color surfaceContainer = const Color(0xFF0F1930);
  final Color surfaceContainerHigh = const Color(0xFF141F38);
  final Color onSurface = const Color(0xFFDEE5FF);
  final Color onSurfaceMuted = const Color(0xFF9AA6C5);
  final Color primaryDim = const Color(0xFF6063EE);
  final Color primary = const Color(0xFFA3A6FF);
  final Color secondaryDim = const Color(0xFF8455EF);
}
