import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../pages/auth/helpers/auth_google_sign_in.dart';
import '../../services/account/account_api.dart';
import '../../services/local/avatar_service.dart';
import '../../utils/firebase_auth_errors.dart';
import '../../utils/google_sign_in_errors.dart';
import '../../widgets/cognix_widgets.dart';
import 'widgets/account_security_delete_account_panel.dart';
import 'widgets/account_security_header_card.dart';
import 'widgets/account_security_palette.dart';
import 'widgets/account_security_password_panel.dart';
import 'widgets/account_security_section_title.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  static const _deleteConfirmationText = 'EXCLUIR';

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _deletePasswordController =
      TextEditingController();
  final TextEditingController _deleteConfirmationController =
      TextEditingController();

  final FocusNode _currentPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _deletePasswordFocus = FocusNode();
  final FocusNode _deleteConfirmationFocus = FocusNode();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureDeletePassword = true;
  bool _isUpdatingPassword = false;
  bool _isDeletingAccount = false;
  bool _isPasswordExpanded = false;
  bool _isDangerExpanded = false;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  Set<String> get _providerIds {
    final providers =
        _currentUser?.providerData
            .map((provider) => provider.providerId)
            .where((providerId) => providerId.isNotEmpty)
            .toSet() ??
        <String>{};
    if (providers.isEmpty && _currentUser != null) {
      return <String>{'password'};
    }
    return providers;
  }

  bool get _supportsPasswordProvider => _providerIds.contains('password');
  bool get _supportsGoogleProvider => _providerIds.contains('google.com');

  String get _providerLabel {
    if (_supportsPasswordProvider && _supportsGoogleProvider) {
      return 'Email e Google';
    }
    if (_supportsPasswordProvider) {
      return 'Email e senha';
    }
    if (_supportsGoogleProvider) {
      return 'Google';
    }
    return 'Conta autenticada';
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _deletePasswordController.dispose();
    _deleteConfirmationController.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _deletePasswordFocus.dispose();
    _deleteConfirmationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;
    final email = user?.email?.trim();
    final displayName = user?.displayName?.trim();

    return Scaffold(
      backgroundColor: AccountSecurityPalette.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AccountSecurityPalette.onSurface,
        elevation: 0,
        title: const Text('Segurança da conta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountSecurityHeaderCard(
              providerLabel: _providerLabel,
              email: email,
              displayName: displayName,
            ),
            const SizedBox(height: 24),
            const AccountSecuritySectionTitle(
              title: 'Segurança da conta',
              subtitle:
                  'Atualize sua senha quando quiser reforçar a protecão do acesso.',
            ),
            const SizedBox(height: 12),
            AccountSecurityPasswordPanel(
              isExpanded: _isPasswordExpanded,
              supportsPasswordProvider: _supportsPasswordProvider,
              providerLabel: _providerLabel,
              isUpdatingPassword: _isUpdatingPassword,
              obscureCurrentPassword: _obscureCurrentPassword,
              obscureNewPassword: _obscureNewPassword,
              obscureConfirmPassword: _obscureConfirmPassword,
              currentPasswordController: _currentPasswordController,
              newPasswordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
              currentPasswordFocus: _currentPasswordFocus,
              newPasswordFocus: _newPasswordFocus,
              confirmPasswordFocus: _confirmPasswordFocus,
              onToggle: () {
                setState(() => _isPasswordExpanded = !_isPasswordExpanded);
              },
              onToggleCurrentPasswordVisibility: () {
                setState(
                  () => _obscureCurrentPassword = !_obscureCurrentPassword,
                );
              },
              onToggleNewPasswordVisibility: () {
                setState(() => _obscureNewPassword = !_obscureNewPassword);
              },
              onToggleConfirmPasswordVisibility: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              onSubmit: _isUpdatingPassword ? null : _handlePasswordUpdate,
            ),
            const SizedBox(height: 24),
            const AccountSecuritySectionTitle(
              title: 'Exclusão da conta',
              subtitle:
                  'Use essa área apenas quando quiser encerrar o acesso e limpar os dados vinculados ao seu usuário.',
            ),
            const SizedBox(height: 12),
            AccountSecurityDeleteAccountPanel(
              isExpanded: _isDangerExpanded,
              supportsPasswordProvider: _supportsPasswordProvider,
              supportsGoogleProvider: _supportsGoogleProvider,
              isDeletingAccount: _isDeletingAccount,
              obscureDeletePassword: _obscureDeletePassword,
              deleteConfirmationController: _deleteConfirmationController,
              deletePasswordController: _deletePasswordController,
              deleteConfirmationFocus: _deleteConfirmationFocus,
              deletePasswordFocus: _deletePasswordFocus,
              onToggle: () {
                setState(() => _isDangerExpanded = !_isDangerExpanded);
              },
              onToggleDeletePasswordVisibility: () {
                setState(
                  () => _obscureDeletePassword = !_obscureDeletePassword,
                );
              },
              onSubmit: _isDeletingAccount ? null : _handleDeleteAccount,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePasswordUpdate() async {
    final user = _currentUser;
    if (user == null) {
      _showMessage(
        'Sua sessão expirou. Entre novamente para atualizar a senha.',
        type: CognixMessageType.error,
      );
      return;
    }
    if (!_supportsPasswordProvider) {
      _showMessage(
        'Sua conta não usa senha local. O acesso e gerenciado pelo provedor atual.',
      );
      return;
    }

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.length < 6) {
      _showMessage('Informe sua senha atual para confirmar a alteração.');
      return;
    }
    if (newPassword.length < 6) {
      _showMessage('A nova senha precisa ter ao menos 6 caracteres.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showMessage('A confirmação da nova senha não confere.');
      return;
    }
    if (newPassword == currentPassword) {
      _showMessage('Escolha uma senha nova diferente da atual.');
      return;
    }

    setState(() => _isUpdatingPassword = true);
    try {
      await _reauthenticateWithPassword(currentPassword);
      await user.updatePassword(newPassword);
      if (!mounted) {
        return;
      }
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _showMessage(
        'Senha atualizada com sucesso.',
        type: CognixMessageType.success,
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(
        authErrorMessage(error.code, action: AuthAction.updatePassword),
        type: CognixMessageType.error,
      );
    } catch (_) {
      _showMessage(
        'Não foi possível atualizar sua senha agora. Tente novamente.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdatingPassword = false);
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    final user = _currentUser;
    if (user == null) {
      _showMessage(
        'Sua sessão expirou. Entre novamente para excluir a conta.',
        type: CognixMessageType.error,
      );
      return;
    }

    if (_deleteConfirmationController.text.trim().toUpperCase() !=
        _deleteConfirmationText) {
      _showMessage('Digite EXCLUIR para liberar a exclusão definitiva.');
      return;
    }

    if (_supportsPasswordProvider &&
        _deletePasswordController.text.trim().length < 6) {
      _showMessage('Confirme sua senha atual para continuar.');
      return;
    }

    final confirmed = await _showDeleteConfirmationDialog();
    if (!confirmed) {
      return;
    }

    setState(() => _isDeletingAccount = true);
    try {
      if (_supportsPasswordProvider) {
        await _reauthenticateWithPassword(_deletePasswordController.text);
      } else if (_supportsGoogleProvider) {
        final didReauthenticate = await reauthenticateWithGoogle(user);
        if (!didReauthenticate) {
          _showMessage('Confirmação com Google cancelada.');
          return;
        }
        await user.getIdToken(true);
      } else {
        await user.getIdToken(true);
      }

      await deleteCurrentAccountFromBackend();
      await AvatarService.clearAvatarSeed();
      await FirebaseAuth.instance.signOut();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
    } on AccountApiException catch (error) {
      _showMessage(error.message, type: CognixMessageType.error);
    } on FirebaseAuthException catch (error) {
      _showMessage(
        authErrorMessage(error.code, action: AuthAction.deleteAccount),
        type: CognixMessageType.error,
      );
    } on GoogleSignInException catch (error) {
      _showMessage(
        googleSignInErrorMessage(error.code.name),
        type: CognixMessageType.error,
      );
    } catch (_) {
      _showMessage(
        'Não foi possível excluir sua conta agora. Tente novamente.',
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isDeletingAccount = false);
      }
    }
  }

  Future<void> _reauthenticateWithPassword(String password) async {
    final user = _currentUser;
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      throw FirebaseAuthException(code: 'missing-email');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await user.getIdToken(true);
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AccountSecurityPalette.card,
          title: Text(
            'Excluir conta?',
            style: GoogleFonts.manrope(
              color: AccountSecurityPalette.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Ao confirmar, sua conta será encerrada e os dados vinculados a este usuário serão removidos de forma permanente. Essa ação não pode ser desfeita.',
            style: GoogleFonts.inter(
              color: AccountSecurityPalette.onSurfaceMuted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AccountSecurityPalette.danger,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _showMessage(
    String text, {
    CognixMessageType type = CognixMessageType.info,
  }) {
    showCognixMessage(context, text, type: type);
  }
}
