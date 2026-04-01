import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/firebase_auth_errors.dart';
import '../../utils/google_sign_in_errors.dart';
import '../../widgets/cognix_widgets.dart';
import 'helpers/auth_google_sign_in.dart';
import 'auth_theme.dart';
import 'widgets/auth_inline_prompt.dart';
import 'widgets/auth_intro.dart';
import 'widgets/auth_shell.dart';
import 'widgets/auth_social_section.dart';
import 'widgets/fields_label.dart';
import 'widgets/primary_buttons.dart';

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
    if (email.isEmpty || !email.contains('@')) {
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
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('home');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'missing-google-id-token') {
        _showMessage('Não foi possível autenticar com o Google.');
      } else {
        _showMessage(authErrorMessage(e.code, action: AuthAction.signUp));
      }
    } on PlatformException catch (e) {
      _showMessage(googleSignInErrorMessage(e.code));
    } catch (_) {
      _showMessage('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String text) {
    showCognixMessage(context, text);
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 26),
          const FieldLabel(text: 'NOME COMPLETO'),
          const SizedBox(height: 8),
          InputField(
            controller: _nameController,
            focusNode: _nameFocus,
            hintText: 'Seu nome',
            icon: Icons.person_outline_rounded,
            background: AuthTheme.surfaceLow,
            primary: AuthTheme.primary,
          ),
          const SizedBox(height: 16),
          const FieldLabel(text: 'E-MAIL'),
          const SizedBox(height: 8),
          InputField(
            controller: _emailController,
            focusNode: _emailFocus,
            hintText: 'seu@email.com',
            icon: Icons.mail_outline_rounded,
            background: AuthTheme.surfaceLow,
            primary: AuthTheme.primary,
          ),
          const SizedBox(height: 16),
          const FieldLabel(text: 'SENHA'),
          const SizedBox(height: 8),
          InputField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            hintText: '********',
            icon: Icons.lock_outline_rounded,
            background: AuthTheme.surfaceLow,
            primary: AuthTheme.primary,
            obscure: _obscurePassword,
            suffix: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AuthTheme.onSurfaceMuted,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel(text: 'CONFIRMAR SENHA'),
          const SizedBox(height: 8),
          InputField(
            controller: _confirmController,
            focusNode: _confirmFocus,
            hintText: '********',
            icon: Icons.verified_user_outlined,
            background: AuthTheme.surfaceLow,
            primary: AuthTheme.primary,
            obscure: _obscureConfirm,
            suffix: IconButton(
              onPressed: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AuthTheme.onSurfaceMuted,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            text: 'Criar Conta',
            gradient: AuthTheme.primaryGradient,
            onPressed: _isLoading ? null : _handleSignUp,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 18),
          AuthSocialSection(
            title: 'OU CONTINUE COM',
            onGooglePressed: _isLoading ? () {} : _handleGoogleSignIn,
          ),
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
