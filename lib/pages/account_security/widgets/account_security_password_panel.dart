import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/widgets/fields_label.dart';
import '../../auth/widgets/primary_buttons.dart';
import 'account_security_expandable_card.dart';
import 'account_security_palette.dart';

class AccountSecurityPasswordPanel extends StatelessWidget {
  const AccountSecurityPasswordPanel({
    super.key,
    required this.isExpanded,
    required this.supportsPasswordProvider,
    required this.providerLabel,
    required this.isUpdatingPassword,
    required this.obscureCurrentPassword,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.currentPasswordFocus,
    required this.newPasswordFocus,
    required this.confirmPasswordFocus,
    required this.onToggle,
    required this.onToggleCurrentPasswordVisibility,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onSubmit,
  });

  final bool isExpanded;
  final bool supportsPasswordProvider;
  final String providerLabel;
  final bool isUpdatingPassword;
  final bool obscureCurrentPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final FocusNode currentPasswordFocus;
  final FocusNode newPasswordFocus;
  final FocusNode confirmPasswordFocus;
  final VoidCallback onToggle;
  final VoidCallback onToggleCurrentPasswordVisibility;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    if (!supportsPasswordProvider) {
      return AccountSecurityExpandableCard(
        title: 'Alterar senha',
        subtitle: isExpanded
            ? 'Toque para recolher as orientações'
            : 'Toque para ver como sua senha é gerenciada',
        accent: AccountSecurityPalette.secondary,
        isExpanded: isExpanded,
        onToggle: onToggle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AccountSecurityPalette.secondary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: AccountSecurityPalette.secondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Sua conta foi criada com $providerLabel. Por isso, a troca de senha não é feita por aqui. Para mudar sua senha, abra a conta vinculada a esse serviço e faça a alteração por lá.',
                style: GoogleFonts.inter(
                  color: AccountSecurityPalette.onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AccountSecurityExpandableCard(
      title: 'Alterar senha',
      subtitle: isExpanded
          ? 'Toque para recolher os campos'
          : 'Toque para confirmar sua senha atual e definir uma nova',
      accent: AccountSecurityPalette.primary,
      isExpanded: isExpanded,
      onToggle: onToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirme sua senha atual e defina uma nova combinação para proteger o acesso.',
            style: GoogleFonts.inter(
              color: AccountSecurityPalette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          const FieldLabel(text: 'SENHA ATUAL'),
          const SizedBox(height: 8),
          InputField(
            controller: currentPasswordController,
            focusNode: currentPasswordFocus,
            hintText: '********',
            icon: Icons.lock_outline_rounded,
            background: AccountSecurityPalette.cardSoft,
            primary: AccountSecurityPalette.primary,
            obscure: obscureCurrentPassword,
            suffix: IconButton(
              onPressed: onToggleCurrentPasswordVisibility,
              icon: Icon(
                obscureCurrentPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AccountSecurityPalette.onSurfaceMuted,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel(text: 'NOVA SENHA'),
          const SizedBox(height: 8),
          InputField(
            controller: newPasswordController,
            focusNode: newPasswordFocus,
            hintText: '********',
            icon: Icons.password_rounded,
            background: AccountSecurityPalette.cardSoft,
            primary: AccountSecurityPalette.primary,
            obscure: obscureNewPassword,
            suffix: IconButton(
              onPressed: onToggleNewPasswordVisibility,
              icon: Icon(
                obscureNewPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AccountSecurityPalette.onSurfaceMuted,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel(text: 'CONFIRMAR NOVA SENHA'),
          const SizedBox(height: 8),
          InputField(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocus,
            hintText: '********',
            icon: Icons.verified_user_outlined,
            background: AccountSecurityPalette.cardSoft,
            primary: AccountSecurityPalette.primary,
            obscure: obscureConfirmPassword,
            suffix: IconButton(
              onPressed: onToggleConfirmPasswordVisibility,
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AccountSecurityPalette.onSurfaceMuted,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            text: 'Atualizar senha',
            gradient: LinearGradient(
              colors: [
                AccountSecurityPalette.primary,
                AccountSecurityPalette.primaryDim,
              ],
            ),
            onPressed: onSubmit,
            isLoading: isUpdatingPassword,
          ),
        ],
      ),
    );
  }
}
