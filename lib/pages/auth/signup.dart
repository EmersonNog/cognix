import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import '../../widgets/cognix_widgets.dart';
import '../../utils/firebase_auth_errors.dart';
import '../../utils/google_sign_in_errors.dart';

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
      if (name.isNotEmpty) {
        await credential.user?.updateDisplayName(name);
      }
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
    try {
      setState(() => _isLoading = true);
      final googleSignIn = GoogleSignIn();
      // Force account chooser instead of auto-signing last account.
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _showMessage('Login cancelado.');
        return;
      }
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        _showMessage('Nao foi possivel autenticar com o Google.');
        return;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('home');
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(authErrorMessage(e.code, action: AuthAction.signUp));
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
    const surface = Color(0xFF060E20);
    const surfaceLow = Color(0xFF091328);
    const surfaceContainer = Color(0xFF0F1930);
    const surfaceHighest = Color(0xFF192540);
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
                      vertical: 26,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: primary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Cognix',
                              style: GoogleFonts.plusJakartaSans(
                                color: onSurfaceMuted,
                                fontSize: 12.5,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Inicie sua Jornada\nIntelectual',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: onSurface,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Junte-se a uma comunidade de estudiosos dedicados e '
                          'transforme sua maneira de aprender.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: onSurfaceMuted,
                            fontSize: 14.2,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),
                        CognixFieldLabel(text: 'NOME COMPLETO'),
                        const SizedBox(height: 8),
                        CognixInputField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          hintText: 'Seu nome',
                          icon: Icons.person_outline_rounded,
                          background: surfaceLow,
                          primary: primary,
                        ),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 16),
                        CognixFieldLabel(text: 'SENHA'),
                        const SizedBox(height: 8),
                        CognixInputField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          hintText: '********',
                          icon: Icons.lock_outline_rounded,
                          background: surfaceLow,
                          primary: primary,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: onSurfaceMuted,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CognixFieldLabel(text: 'CONFIRMAR SENHA'),
                        const SizedBox(height: 8),
                        CognixInputField(
                          controller: _confirmController,
                          focusNode: _confirmFocus,
                          hintText: '********',
                          icon: Icons.verified_user_outlined,
                          background: surfaceLow,
                          primary: primary,
                          obscure: _obscureConfirm,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: onSurfaceMuted,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        CognixPrimaryButton(
                          text: 'Criar Conta',
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primaryDim, primary],
                          ),
                          onPressed: _isLoading ? null : _handleSignUp,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Text(
                            'OU CONTINUE COM',
                            style: GoogleFonts.plusJakartaSans(
                              color: onSurfaceMuted.withOpacity(0.7),
                              fontSize: 11,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CognixSocialButton(
                                icon: 'G',
                                label: 'Google',
                                background: surfaceHighest,
                                textColor: onSurface,
                                height: 44,
                                onPressed: _isLoading
                                    ? () {}
                                    : _handleGoogleSignIn,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Ja tem uma conta?',
                                style: GoogleFonts.inter(
                                  color: onSurfaceMuted,
                                  fontSize: 12.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('login');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Entre agora',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
