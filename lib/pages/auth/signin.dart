import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import '../../widgets/cognix_widgets.dart';
import '../../utils/firebase_auth_errors.dart';
import '../../utils/google_sign_in_errors.dart';

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
    try {
      setState(() => _isLoading = true);
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _showMessage('Login cancelado.');
        return;
      }
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        _showMessage('Não foi possível autenticar com o Google.');
        return;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user?.displayName == null ||
          userCredential.user!.displayName!.isEmpty) {
        final displayName =
            googleUser.displayName ?? googleUser.email.split('@').first;
        await userCredential.user?.updateDisplayName(displayName);
        await userCredential.user?.reload();
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('home');
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(authErrorMessage(e.code, action: AuthAction.signIn));
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
              right: -80,
              child: CognixGradientBlob(
                size: 260,
                colorA: secondaryDim.withOpacity(0.35),
                colorB: primaryDim.withOpacity(0.15),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -100,
              child: CognixGradientBlob(
                size: 300,
                colorA: primaryDim.withOpacity(0.25),
                colorB: secondaryDim.withOpacity(0.15),
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
                              Icons.auto_awesome_rounded,
                              color: primary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Bem-vindo de volta,\nMestre',
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
                          'Sua jornada rumo ao conhecimento continua aqui. '
                          'Prepare-se para elevar seu nivel hoje.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: onSurfaceMuted,
                            fontSize: 14.5,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),
                        CognixFieldLabel(text: 'E-MAIL', letterSpacing: 1.5),
                        const SizedBox(height: 8),
                        CognixInputField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          hintText: 'seu@email.com',
                          icon: Icons.mail_outline_rounded,
                          background: surfaceLow,
                          primary: primary,
                        ),
                        const SizedBox(height: 18),
                        CognixFieldLabel(
                          text: 'SENHA DE ACESSO',
                          letterSpacing: 1.5,
                        ),
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('forgot');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Esqueceu?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CognixPrimaryButton(
                          text: 'Entrar',
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primaryDim, primary],
                          ),
                          onPressed: _isLoading ? null : _handleSignIn,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Text(
                            'OU ACESSE COM',
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
                                onPressed: _isLoading
                                    ? () {}
                                    : _handleGoogleSignIn,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Novo por aqui?',
                                style: GoogleFonts.inter(
                                  color: onSurfaceMuted,
                                  fontSize: 12.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('register');
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
                                  'Criar conta',
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
