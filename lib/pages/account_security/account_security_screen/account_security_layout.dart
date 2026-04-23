part of '../account_security_screen.dart';

Widget _buildAccountSecurityLayout(_AccountSecurityScreenState state) {
  final user = state._currentUser;
  final email = user?.email?.trim();
  final displayName = user?.displayName?.trim();

  return Scaffold(
    backgroundColor: AccountSecurityPalette.surface,
    appBar: AppBar(
      backgroundColor: AccountSecurityPalette.surface,
      surfaceTintColor: AccountSecurityPalette.surface,
      foregroundColor: AccountSecurityPalette.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text('Segurança da conta'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountSecurityHeaderCard(
            providerLabel: state._providerLabel,
            email: email,
            displayName: displayName,
          ),
          const SizedBox(height: 24),
          const AccountSecuritySectionTitle(
            title: 'Segurança da conta',
            subtitle:
                'Atualize sua senha quando quiser reforçar a proteção do acesso.',
          ),
          const SizedBox(height: 12),
          _AccountSecurityPasswordSection(state: state),
          const SizedBox(height: 24),
          const AccountSecuritySectionTitle(
            title: 'Exclusão da conta',
            subtitle:
                'Use essa área apenas quando quiser encerrar o acesso e limpar os dados vinculados ao seu usuário.',
          ),
          const SizedBox(height: 12),
          _AccountSecurityDangerSection(state: state),
        ],
      ),
    ),
  );
}

class _AccountSecurityPasswordSection extends StatelessWidget {
  const _AccountSecurityPasswordSection({required this.state});

  final _AccountSecurityScreenState state;

  @override
  Widget build(BuildContext context) {
    return AccountSecurityPasswordPanel(
      isExpanded: state._isPasswordExpanded,
      supportsPasswordProvider: state._supportsPasswordProvider,
      providerLabel: state._providerLabel,
      isUpdatingPassword: state._isUpdatingPassword,
      obscureCurrentPassword: state._obscureCurrentPassword,
      obscureNewPassword: state._obscureNewPassword,
      obscureConfirmPassword: state._obscureConfirmPassword,
      currentPasswordController: state._currentPasswordController,
      newPasswordController: state._newPasswordController,
      confirmPasswordController: state._confirmPasswordController,
      currentPasswordFocus: state._currentPasswordFocus,
      newPasswordFocus: state._newPasswordFocus,
      confirmPasswordFocus: state._confirmPasswordFocus,
      onToggle: () {
        state._applyState(() {
          state._isPasswordExpanded = !state._isPasswordExpanded;
        });
      },
      onToggleCurrentPasswordVisibility: () {
        state._applyState(() {
          state._obscureCurrentPassword = !state._obscureCurrentPassword;
        });
      },
      onToggleNewPasswordVisibility: () {
        state._applyState(() {
          state._obscureNewPassword = !state._obscureNewPassword;
        });
      },
      onToggleConfirmPasswordVisibility: () {
        state._applyState(() {
          state._obscureConfirmPassword = !state._obscureConfirmPassword;
        });
      },
      onSubmit: state._isUpdatingPassword ? null : state._handlePasswordUpdate,
    );
  }
}

class _AccountSecurityDangerSection extends StatelessWidget {
  const _AccountSecurityDangerSection({required this.state});

  final _AccountSecurityScreenState state;

  @override
  Widget build(BuildContext context) {
    return AccountSecurityDeleteAccountPanel(
      isExpanded: state._isDangerExpanded,
      supportsPasswordProvider: state._supportsPasswordProvider,
      supportsGoogleProvider: state._supportsGoogleProvider,
      isDeletingAccount: state._isDeletingAccount,
      obscureDeletePassword: state._obscureDeletePassword,
      deleteConfirmationController: state._deleteConfirmationController,
      deletePasswordController: state._deletePasswordController,
      deleteConfirmationFocus: state._deleteConfirmationFocus,
      deletePasswordFocus: state._deletePasswordFocus,
      onToggle: () {
        state._applyState(() {
          state._isDangerExpanded = !state._isDangerExpanded;
        });
      },
      onToggleDeletePasswordVisibility: () {
        state._applyState(() {
          state._obscureDeletePassword = !state._obscureDeletePassword;
        });
      },
      onSubmit: state._isDeletingAccount ? null : state._handleDeleteAccount,
    );
  }
}
