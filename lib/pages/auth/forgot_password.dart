import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/firebase_auth_errors.dart';
import '../../widgets/cognix_widgets.dart';
import 'auth_theme.dart';
import 'helpers/email_validator.dart';
import 'widgets/auth_intro.dart';
import 'widgets/auth_shell.dart';
import 'widgets/fields_label.dart';
import 'widgets/primary_buttons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();
    if (!isValidEmail(email)) {
      _showMessage('Informe um e-mail válido.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: '__invalid_password__',
        );
        await FirebaseAuth.instance.signOut();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' ||
            e.code == 'invalid-email' ||
            e.code == 'user-disabled' ||
            e.code == 'too-many-requests') {
          _showMessage(authErrorMessage(e.code, action: AuthAction.reset));
          return;
        }
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        _showMessage('Enviamos um link para seu e-mail.');
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(authErrorMessage(e.code, action: AuthAction.reset));
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
    final authTheme = AuthTheme.of(context);

    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIntro(
            icon: Icons.lock_reset_rounded,
            title: 'Esqueceu a senha?',
            subtitle:
                'Não se preocupe, mestre. Insira seu e-mail cadastrado e enviaremos as instruções para recuperar seu acesso.',
          ),
          const SizedBox(height: 26),
          const FieldLabel(text: 'E-MAIL'),
          const SizedBox(height: 8),
          InputField(
            controller: _emailController,
            focusNode: _emailFocus,
            hintText: 'seu@email.com',
            icon: Icons.mail_outline_rounded,
            background: authTheme.surfaceLow,
            primary: authTheme.primary,
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            text: 'Enviar Instruções',
            gradient: authTheme.primaryGradient,
            onPressed: _isLoading ? null : _handleReset,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: authTheme.primary,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Voltar para o login'),
            ),
          ),
        ],
      ),
    );
  }
}
