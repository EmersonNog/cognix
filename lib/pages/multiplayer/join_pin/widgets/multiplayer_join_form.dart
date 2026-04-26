import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/widgets/palette.dart';
import '../../shared/widgets/room_widgets.dart';

class MultiplayerJoinForm extends StatelessWidget {
  const MultiplayerJoinForm({
    super.key,
    required this.controller,
    required this.palette,
    required this.canJoin,
    required this.isJoining,
    required this.errorMessage,
    required this.onChanged,
    required this.onJoin,
  });

  final TextEditingController controller;
  final MultiplayerPalette palette;
  final bool canJoin;
  final bool isJoining;
  final String? errorMessage;
  final VoidCallback onChanged;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PIN da sala',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Use o código de 6 dígitos para entrar no lobby multiplayer.',
            style: GoogleFonts.inter(
              color: palette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          _PinTextField(
            controller: controller,
            palette: palette,
            onChanged: onChanged,
            onJoin: onJoin,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              style: GoogleFonts.inter(
                color: palette.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _JoinButton(
            palette: palette,
            canJoin: canJoin,
            isJoining: isJoining,
            onJoin: onJoin,
          ),
        ],
      ),
    );
  }
}

class _PinTextField extends StatelessWidget {
  const _PinTextField({
    required this.controller,
    required this.palette,
    required this.onChanged,
    required this.onJoin,
  });

  final TextEditingController controller;
  final MultiplayerPalette palette;
  final VoidCallback onChanged;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      onChanged: (_) => onChanged(),
      onSubmitted: (_) => onJoin(),
      style: GoogleFonts.plusJakartaSans(
        color: palette.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: 9,
      ),
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: palette.surfaceContainerHigh.withValues(alpha: 0.68),
        hintText: '000000',
        hintStyle: GoogleFonts.plusJakartaSans(
          color: palette.onSurfaceMuted.withValues(alpha: 0.35),
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 9,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: palette.onSurfaceMuted.withValues(alpha: 0.14),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({
    required this.palette,
    required this.canJoin,
    required this.isJoining,
    required this.onJoin,
  });

  final MultiplayerPalette palette;
  final bool canJoin;
  final bool isJoining;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: canJoin ? onJoin : null,
      style: FilledButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        disabledBackgroundColor: palette.surfaceContainerHigh,
        disabledForegroundColor: palette.onSurfaceMuted,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: isJoining
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.meeting_room_rounded),
      label: Text(
        isJoining ? 'Entrando...' : 'Entrar na sala',
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
      ),
    );
  }
}
