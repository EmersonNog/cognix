import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/widgets/fields_label.dart';
import '../../auth/widgets/primary_buttons.dart';
import 'account_security_expandable_card.dart';
import 'account_security_palette.dart';

class AccountSecurityDeleteAccountPanel extends StatelessWidget {
  const AccountSecurityDeleteAccountPanel({
    super.key,
    required this.isExpanded,
    required this.supportsPasswordProvider,
    required this.supportsGoogleProvider,
    required this.isDeletingAccount,
    required this.obscureDeletePassword,
    required this.deleteConfirmationController,
    required this.deletePasswordController,
    required this.deleteConfirmationFocus,
    required this.deletePasswordFocus,
    required this.onToggle,
    required this.onToggleDeletePasswordVisibility,
    required this.onSubmit,
  });

  final bool isExpanded;
  final bool supportsPasswordProvider;
  final bool supportsGoogleProvider;
  final bool isDeletingAccount;
  final bool obscureDeletePassword;
  final TextEditingController deleteConfirmationController;
  final TextEditingController deletePasswordController;
  final FocusNode deleteConfirmationFocus;
  final FocusNode deletePasswordFocus;
  final VoidCallback onToggle;
  final VoidCallback onToggleDeletePasswordVisibility;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return AccountSecurityExpandableCard(
      title: 'Excluir conta',
      subtitle: isExpanded
          ? 'Toque para recolher os detalhes da exclusão'
          : 'Toque para revisar o impacto e confirmar a exclusão definitiva',
      accent: AccountSecurityPalette.danger,
      borderColor: AccountSecurityPalette.danger.withValues(alpha: 0.22),
      isExpanded: isExpanded,
      onToggle: onToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Esse processo remove seu acesso e limpa o histórico associado ao usuário.',
            style: GoogleFonts.inter(
              color: AccountSecurityPalette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const _AccountDangerBullet(
            text: 'encerra de forma permanente o acesso desta conta ao app',
          ),
          const _AccountDangerBullet(
            text: 'remove o histórico e os dados vinculados a este usuário',
          ),
          const _AccountDangerBullet(
            text: 'desconecta você imediatamente deste dispositivo',
          ),
          const SizedBox(height: 18),
          const FieldLabel(text: 'DIGITE EXCLUIR PARA CONFIRMAR'),
          const SizedBox(height: 8),
          _DeleteConfirmationField(
            controller: deleteConfirmationController,
            focusNode: deleteConfirmationFocus,
          ),
          const SizedBox(height: 8),
          Text(
            'Essa confirmação evita exclusões acidentais.',
            style: GoogleFonts.inter(
              color: AccountSecurityPalette.onSurfaceMuted,
              fontSize: 11.8,
              height: 1.35,
            ),
          ),
          if (supportsPasswordProvider) ...[
            const SizedBox(height: 16),
            const FieldLabel(text: 'CONFIRME SUA SENHA ATUAL'),
            const SizedBox(height: 8),
            InputField(
              controller: deletePasswordController,
              focusNode: deletePasswordFocus,
              hintText: '********',
              icon: Icons.lock_outline_rounded,
              background: AccountSecurityPalette.cardSoft,
              primary: AccountSecurityPalette.danger,
              obscure: obscureDeletePassword,
              suffix: IconButton(
                onPressed: onToggleDeletePasswordVisibility,
                icon: Icon(
                  obscureDeletePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AccountSecurityPalette.onSurfaceMuted,
                  size: 20,
                ),
              ),
            ),
          ] else if (supportsGoogleProvider) ...[
            const SizedBox(height: 16),
            Text(
              'Ao confirmar, você também vai validar sua conta Google para concluir a exclusão.',
              style: GoogleFonts.inter(
                color: AccountSecurityPalette.onSurfaceMuted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            text: 'Excluir minha conta',
            gradient: LinearGradient(
              colors: [
                AccountSecurityPalette.dangerSoft,
                AccountSecurityPalette.danger,
              ],
            ),
            onPressed: onSubmit,
            isLoading: isDeletingAccount,
          ),
        ],
      ),
    );
  }
}

class _DeleteConfirmationField extends StatelessWidget {
  const _DeleteConfirmationField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AccountSecurityPalette.danger.withValues(
                alpha: AccountSecurityPalette.isDark ? 0.08 : 0.06,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AccountSecurityPalette.danger.withValues(
                  alpha: isFocused ? 0.58 : 0.24,
                ),
                width: isFocused ? 1.4 : 1,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: AccountSecurityPalette.danger.withValues(
                          alpha: 0.16,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AccountSecurityPalette.danger.withValues(
                      alpha: 0.14,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: AccountSecurityPalette.danger,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.plusJakartaSans(
                      color: AccountSecurityPalette.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'EXCLUIR',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: AccountSecurityPalette.onSurfaceMuted.withValues(
                          alpha: 0.62,
                        ),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AccountDangerBullet extends StatelessWidget {
  const _AccountDangerBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AccountSecurityPalette.dangerSoft,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AccountSecurityPalette.onSurfaceMuted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
