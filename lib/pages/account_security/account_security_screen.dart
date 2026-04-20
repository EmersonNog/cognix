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

part 'account_security_screen/account_security_actions.dart';
part 'account_security_screen/account_security_dialogs.dart';
part 'account_security_screen/account_security_layout.dart';

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
    AccountSecurityPalette.syncWithContext(context);
    return _buildAccountSecurityLayout(this);
  }

  void _applyState(VoidCallback update) {
    if (!mounted) {
      return;
    }
    setState(update);
  }

  void _showMessage(
    String text, {
    CognixMessageType type = CognixMessageType.info,
  }) {
    showCognixMessage(context, text, type: type);
  }
}
