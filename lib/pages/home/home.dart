import 'package:cognix/widgets/cognix_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navigation/app_route_observer.dart';
import '../../services/auth/auth_api.dart';
import '../../services/profile/profile_api.dart';
import '../../services/profile/profile_refresh_notifier.dart';
import 'home_tab.dart';
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
  late final Future<void> _userSyncFuture;
  late Future<ProfileScoreData> _profileFuture;
  bool _isRouteObserverSubscribed = false;

  @override
  void initState() {
    super.initState();
    _userSyncFuture = _syncUserAfterLogin();
    _profileFuture = _fetchSharedProfileScore();
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

  Future<void> _syncUserAfterLogin() async {
    try {
      await syncCurrentUserToBackend();
    } catch (_) {}
  }

  Future<ProfileScoreData> _fetchSharedProfileScore() async {
    await _userSyncFuture;
    return fetchProfileScore();
  }

  Future<void> _refreshSharedProfileData() async {
    final nextProfileFuture = _fetchSharedProfileScore();
    if (mounted) {
      setState(() {
        _profileFuture = nextProfileFuture;
      });
    }

    try {
      await nextProfileFuture;
    } catch (_) {}
  }

  @override
  void didPopNext() {
    if (profileRefreshNotifier.consumeDirty()) {
      _refreshSharedProfileData();
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

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF060E20);
    const surfaceContainer = Color(0xFF0F1930);
    const surfaceContainerHigh = Color(0xFF141F38);
    const onSurface = Color(0xFFDEE5FF);
    const onSurfaceMuted = Color(0xFF9AA6C5);
    const primaryDim = Color(0xFF6063EE);
    const primary = Color(0xFFA3A6FF);
    const secondaryDim = Color(0xFF8455EF);

    final currentUser = FirebaseAuth.instance.currentUser;
    final userName = currentUser?.displayName ?? 'Usu\u00E1rio';

    final tabs = [
      HomeTab(
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
        primaryDim: primaryDim,
        userName: userName,
        onRefresh: _refreshSharedProfileData,
      ),
      TrainingTab(
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
        onRefreshHubData: _refreshSharedProfileData,
      ),
      PerformanceScreen.embedded(
        profileFuture: _profileFuture,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
        onRefresh: _refreshSharedProfileData,
      ),
      ProfileTab(
        profileFuture: _profileFuture,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        onSurface: onSurface,
        onSurfaceMuted: onSurfaceMuted,
        primary: primary,
        primaryDim: primaryDim,
        userName: userName,
        onRefresh: _refreshSharedProfileData,
      ),
    ];

    return Scaffold(
      backgroundColor: surface,
      body: CognixPageLayout(
        title: 'Cognix Hub',
        backgroundColor: surface,
        topBarColor: surfaceContainerHigh,
        titleColor: onSurface,
        leadingColor: primary,
        trailing: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _isLoading ? null : _handleLogout,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.logout_rounded),
            color: onSurfaceMuted,
            iconSize: 18,
            padding: EdgeInsets.zero,
          ),
        ),
        backgroundLayers: [
          Positioned(
            top: -90,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [secondaryDim.withOpacity(0.55), Colors.transparent],
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
                  colors: [primary.withOpacity(0.28), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
        child: IndexedStack(index: _currentIndex, children: tabs),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                label: 'In\u00EDcio',
                icon: Icons.grid_view_rounded,
                selected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
                primary: primary,
                muted: onSurfaceMuted,
                selectedBackground: surfaceContainerHigh,
              ),
              _NavItem(
                label: 'Treino',
                icon: Icons.timer_rounded,
                selected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
                primary: primary,
                muted: onSurfaceMuted,
                selectedBackground: surfaceContainerHigh,
              ),
              _NavItem(
                label: 'An\u00E1lise',
                icon: Icons.insights_rounded,
                selected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
                primary: primary,
                muted: onSurfaceMuted,
                selectedBackground: surfaceContainerHigh,
              ),
              _NavItem(
                label: 'Perfil',
                icon: Icons.person_rounded,
                selected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
                primary: primary,
                muted: onSurfaceMuted,
                selectedBackground: surfaceContainerHigh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.primary,
    required this.muted,
    required this.selectedBackground,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;
  final Color muted;
  final Color selectedBackground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primary.withOpacity(0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: selected ? primary : muted),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? primary : muted,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
