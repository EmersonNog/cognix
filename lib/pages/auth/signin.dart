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

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Informe um e-mail válido.');
      return;
    }
    if (password.length < 6) {
      _showMessage('Informe sua senha com ao menos 6 caracteres.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('home');
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(authErrorMessage(e.code, action: AuthAction.signIn));
    } catch (_) {
      _showMessage('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await signInWithGoogle(ensureDisplayName: true);
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
        _showMessage(authErrorMessage(e.code, action: AuthAction.signIn));
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
            title: 'Bem-vindo de volta,\nMestre',
            subtitle:
                'Sua jornada rumo ao conhecimento continua aqui. Prepare-se para elevar seu nível hoje.',
          ),
          const SizedBox(height: 28),
          const FieldLabel(text: 'E-MAIL', letterSpacing: 1.5),
          const SizedBox(height: 8),
          InputField(
            controller: _emailController,
            focusNode: _emailFocus,
            hintText: 'seu@email.com',
            icon: Icons.mail_outline_rounded,
            background: AuthTheme.surfaceLow,
            primary: AuthTheme.primary,
          ),
          const SizedBox(height: 18),
          const FieldLabel(text: 'SENHA DE ACESSO', letterSpacing: 1.5),
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
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('forgot'),
              style: TextButton.styleFrom(
                foregroundColor: AuthTheme.primary,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Esqueceu?'),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Entrar',
            gradient: AuthTheme.primaryGradient,
            onPressed: _isLoading ? null : _handleSignIn,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 22),
          AuthSocialSection(
            title: 'OU ACESSE COM',
            onGooglePressed: _isLoading ? () {} : _handleGoogleSignIn,
          ),
          const SizedBox(height: 22),
          AuthInlinePrompt(
            prefix: 'Novo por aqui?',
            actionLabel: 'Criar conta',
            onTap: () {
              Navigator.of(context).pushReplacementNamed('register');
            },
          ),
        ],
      ),
    );
  }
}
