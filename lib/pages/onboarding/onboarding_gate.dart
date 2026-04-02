import 'package:flutter/material.dart';
import '../../services/local/onboarding_storage.dart';
import '../auth/signin.dart';
import 'onboarding_screen.dart';

class OnboardingGate extends StatelessWidget {
  const OnboardingGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: OnboardingStorage.hasSeen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _BootPlaceholder();
        }
        final hasSeen = snapshot.data ?? false;
        return hasSeen ? const SignIn() : const OnboardingScreen();
      },
    );
  }
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
