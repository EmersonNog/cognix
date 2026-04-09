import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/local/onboarding_storage.dart';
import '../auth/helpers/auth_backend_bootstrap.dart';
import '../auth/signin.dart';
import '../home/home.dart';
import 'onboarding_screen.dart';

class OnboardingGate extends StatelessWidget {
  const OnboardingGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_OnboardingGateState>(
      future: _resolveGateState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _BootPlaceholder();
        }

        final gateState = snapshot.data ?? const _OnboardingGateState();
        if (!gateState.hasSeenOnboarding) {
          return const OnboardingScreen();
        }

        return gateState.hasAuthenticatedUser ? const Home() : const SignIn();
      },
    );
  }
}

Future<_OnboardingGateState> _resolveGateState() async {
  final hasSeenOnboarding = await OnboardingStorage.hasSeen();
  final hasAuthenticatedUser = FirebaseAuth.instance.currentUser != null;

  if (hasSeenOnboarding && hasAuthenticatedUser) {
    try {
      await prepareAuthenticatedBackendSession();
    } catch (_) {}
  }

  return _OnboardingGateState(
    hasSeenOnboarding: hasSeenOnboarding,
    hasAuthenticatedUser: hasAuthenticatedUser,
  );
}

class _OnboardingGateState {
  const _OnboardingGateState({
    this.hasSeenOnboarding = false,
    this.hasAuthenticatedUser = false,
  });

  final bool hasSeenOnboarding;
  final bool hasAuthenticatedUser;
}

class _BootPlaceholder extends StatelessWidget {
  const _BootPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF060E20),
      body: SizedBox.expand(),
    );
  }
}
