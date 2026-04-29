import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/firebase_auth_errors.dart';
import '../../utils/google_sign_in_errors.dart';
import '../../widgets/cognix_widgets.dart';
import 'auth_theme.dart';
import 'helpers/auth_backend_bootstrap.dart';
import 'helpers/auth_google_sign_in.dart';
import 'helpers/email_validator.dart';
import 'widgets/auth_inline_prompt.dart';
import 'widgets/auth_intro.dart';
import 'widgets/auth_shell.dart';
import 'widgets/auth_social_section.dart';
import 'widgets/fields_label.dart';
import 'widgets/primary_buttons.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  int _step = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty) {
      _showMessage('Informe seu nome completo.');
      return;
    }
    if (!isValidEmail(email)) {
      _showMessage('Informe um e-mail válido.');
      return;
    }
    if (password.length < 6) {
      _showMessage('A senha deve ter no mínimo 6 caracteres.');
      return;
    }
    if (password != confirm) {
      _showMessage('As senhas não coincidem.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      if (mounted) {
        _showMessage('Cadastro realizado com sucesso.');
        Navigator.of(context).pushReplacementNamed('login');
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(authErrorMessage(e.code, action: AuthAction.signUp));
    } catch (_) {
      _showMessage('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await signInWithGoogle();
      if (userCredential == null) {
        _showMessage('Login cancelado.');
        return;
      }
      await prepareAuthenticatedBackendSession();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          'home',
          arguments: const HomeRouteArgs(showPlanOnStart: true),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'missing-google-id-token') {
        _showMessage('Não foi possível autenticar com o Google.');
      } else {
        _showMessage(authErrorMessage(e.code, action: AuthAction.signUp));
      }
    } on GoogleSignInException catch (e) {
      _showMessage(googleSignInErrorMessage(e.code.name));
    } catch (_) {
      _showMessage('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String text) {
    showCognixMessage(context, text);
  }

  void _goToPasswordStep() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      _showMessage('Informe seu nome completo.');
      _nameFocus.requestFocus();
      return;
    }
    if (!isValidEmail(email)) {
      _showMessage('Informe um e-mail válido.');
      _emailFocus.requestFocus();
      return;
    }

    setState(() => _step = 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _passwordFocus.requestFocus();
      }
    });
  }

  void _goBackToIdentityStep() {
    setState(() => _step = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nameFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authTheme = AuthTheme.of(context);

    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIntro(
            icon: Icons.auto_awesome_rounded,
            title: 'Inicie sua Jornada\nIntelectual',
            subtitle:
                'Junte-se a uma comunidade de estudiosos dedicados e transforme sua maneira de aprender.',
            useGlassBadge: false,
            showWordmark: true,
          ),
          const SizedBox(height: 22),
          _AuthStepIndicator(
            currentStep: _step,
            primary: authTheme.primary,
            muted: authTheme.onSurfaceMuted,
            surface: authTheme.surfaceLow,
          ),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _step == 0
                ? _IdentityStep(
                    key: const ValueKey('identity-step'),
                    authTheme: authTheme,
                    nameController: _nameController,
                    emailController: _emailController,
                    nameFocus: _nameFocus,
                    emailFocus: _emailFocus,
                  )
                : _PasswordStep(
                    key: const ValueKey('password-step'),
                    authTheme: authTheme,
                    passwordController: _passwordController,
                    confirmController: _confirmController,
                    passwordFocus: _passwordFocus,
                    confirmFocus: _confirmFocus,
                    obscurePassword: _obscurePassword,
                    obscureConfirm: _obscureConfirm,
                    onTogglePassword: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    onToggleConfirm: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
          ),
          const SizedBox(height: 22),
          if (_step == 0) ...[
            PrimaryButton(
              text: 'Continuar',
              gradient: authTheme.primaryGradient,
              onPressed: _isLoading ? null : _goToPasswordStep,
            ),
            const SizedBox(height: 18),
            AuthSocialSection(
              title: 'OU CONTINUE COM',
              onGooglePressed: _isLoading ? () {} : _handleGoogleSignIn,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _goBackToIdentityStep,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: BorderSide(
                        color: authTheme.onSurfaceMuted.withValues(alpha: 0.22),
                      ),
                      foregroundColor: authTheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Voltar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: 'Criar Conta',
                    gradient: authTheme.primaryGradient,
                    onPressed: _isLoading ? null : _handleSignUp,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          AuthInlinePrompt(
            prefix: 'Já tem uma conta?',
            actionLabel: 'Entre agora',
            onTap: () {
              Navigator.of(context).pushReplacementNamed('login');
            },
          ),
        ],
      ),
    );
  }
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({
    super.key,
    required this.authTheme,
    required this.nameController,
    required this.emailController,
    required this.nameFocus,
    required this.emailFocus,
  });

  final AuthTheme authTheme;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Etapa 1 de 2',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: authTheme.onSurfaceMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        const FieldLabel(text: 'NOME COMPLETO'),
        const SizedBox(height: 8),
        InputField(
          controller: nameController,
          focusNode: nameFocus,
          hintText: 'Seu nome',
          icon: Icons.person_outline_rounded,
          background: authTheme.surfaceLow,
          primary: authTheme.primary,
        ),
        const SizedBox(height: 16),
        const FieldLabel(text: 'E-MAIL'),
        const SizedBox(height: 8),
        InputField(
          controller: emailController,
          focusNode: emailFocus,
          hintText: 'seu@email.com',
          icon: Icons.mail_outline_rounded,
          background: authTheme.surfaceLow,
          primary: authTheme.primary,
        ),
      ],
    );
  }
}

class _PasswordStep extends StatelessWidget {
  const _PasswordStep({
    super.key,
    required this.authTheme,
    required this.passwordController,
    required this.confirmController,
    required this.passwordFocus,
    required this.confirmFocus,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.onTogglePassword,
    required this.onToggleConfirm,
  });

  final AuthTheme authTheme;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final FocusNode passwordFocus;
  final FocusNode confirmFocus;
  final bool obscurePassword;
  final bool obscureConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Etapa 2 de 2',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: authTheme.onSurfaceMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        const FieldLabel(text: 'SENHA'),
        const SizedBox(height: 8),
        InputField(
          controller: passwordController,
          focusNode: passwordFocus,
          hintText: '********',
          icon: Icons.lock_outline_rounded,
          background: authTheme.surfaceLow,
          primary: authTheme.primary,
          obscure: obscurePassword,
          suffix: IconButton(
            onPressed: onTogglePassword,
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: authTheme.onSurfaceMuted,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const FieldLabel(text: 'CONFIRMAR SENHA'),
        const SizedBox(height: 8),
        InputField(
          controller: confirmController,
          focusNode: confirmFocus,
          hintText: '********',
          icon: Icons.verified_user_outlined,
          background: authTheme.surfaceLow,
          primary: authTheme.primary,
          obscure: obscureConfirm,
          suffix: IconButton(
            onPressed: onToggleConfirm,
            icon: Icon(
              obscureConfirm
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: authTheme.onSurfaceMuted,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthStepIndicator extends StatelessWidget {
  const _AuthStepIndicator({
    required this.currentStep,
    required this.primary,
    required this.muted,
    required this.surface,
  });

  final int currentStep;
  final Color primary;
  final Color muted;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(2, (index) {
        final isActive = index == currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 8,
            margin: EdgeInsets.only(right: index == 0 ? 8 : 0),
            decoration: BoxDecoration(
              color: isActive ? primary : surface,
              borderRadius: BorderRadius.circular(999),
              border: isActive
                  ? null
                  : Border.all(color: muted.withValues(alpha: 0.18)),
            ),
          ),
        );
      }),
    );
  }
}
