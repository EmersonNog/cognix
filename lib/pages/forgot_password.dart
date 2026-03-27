import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/cognix_widgets.dart';
import '../utils/firebase_auth_errors.dart';

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
    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Informe um e-mail válido.');
      return;
    }

    try {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: '__invalid_password__',
        );
        await FirebaseAuth.instance.signOut();
      } on FirebaseAuthException catch (e) {
        final code = e.code;
        if (code == 'user-not-found' ||
            code == 'invalid-email' ||
            code == 'user-disabled' ||
            code == 'too-many-requests') {
          _showMessage(authErrorMessage(code, action: AuthAction.reset));
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
    const surface = Color(0xFF060E20);
    const surfaceLow = Color(0xFF091328);
    const surfaceContainer = Color(0xFF0F1930);
    const onSurface = Color(0xFFDEE5FF);
    const onSurfaceMuted = Color(0xFF9AA6C5);
    const primaryDim = Color(0xFF6063EE);
    const primary = Color(0xFFA3A6FF);
    const secondaryDim = Color(0xFF8455EF);

    final media = MediaQuery.of(context);
    final cardWidth = media.size.width.clamp(0, 420).toDouble();

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -90,
              child: CognixGradientBlob(
                size: 260,
                colorA: secondaryDim.withOpacity(0.35),
                colorB: primaryDim.withOpacity(0.15),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -110,
              child: CognixGradientBlob(
                size: 320,
                colorA: primaryDim.withOpacity(0.22),
                colorB: secondaryDim.withOpacity(0.12),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: onSurface.withOpacity(0.06),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CognixGlassBadge(
                            child: Icon(
                              Icons.lock_reset_rounded,
                              color: primary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Esqueceu a senha?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Nao se preocupe, mestre. Insira seu e-mail cadastrado e '
                          'enviaremos as instrucoes para recuperar seu acesso.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: onSurfaceMuted,
                            fontSize: 14.2,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),
                        CognixFieldLabel(text: 'E-MAIL'),
                        const SizedBox(height: 8),
                        CognixInputField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          hintText: 'seu@email.com',
                          icon: Icons.mail_outline_rounded,
                          background: surfaceLow,
                          primary: primary,
                        ),
                        const SizedBox(height: 22),
                        CognixPrimaryButton(
                          text: 'Enviar Instrucoes',
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primaryDim, primary],
                          ),
                          onPressed: _isLoading ? null : _handleReset,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Voltar para o login',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
