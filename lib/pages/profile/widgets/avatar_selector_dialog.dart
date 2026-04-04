import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../services/profile/profile_api.dart';
import 'profile_header_utils.dart';

class AvatarSelectorDialog extends StatefulWidget {
  const AvatarSelectorDialog({
    super.key,
    required this.primary,
    required this.onSurface,
    required this.surfaceContainer,
    required this.coinsBalance,
    required this.equippedAvatarSeed,
    required this.avatarStore,
  });

  final Color primary;
  final Color onSurface;
  final Color surfaceContainer;
  final double coinsBalance;
  final String equippedAvatarSeed;
  final List<ProfileAvatarStoreItem> avatarStore;

  @override
  State<AvatarSelectorDialog> createState() => _AvatarSelectorDialogState();
}

class _AvatarSelectorDialogState extends State<AvatarSelectorDialog> {
  late String _selectedSeed;
  late double _coinsBalance;
  late List<ProfileAvatarStoreItem> _avatarStore;
  bool _isSubmitting = false;
  String? _helperText;

  @override
  void initState() {
    super.initState();
    _selectedSeed = widget.equippedAvatarSeed.trim().isNotEmpty
        ? widget.equippedAvatarSeed
        : (widget.avatarStore.isNotEmpty
              ? widget.avatarStore.first.seed
              : 'avatar_1');
    _coinsBalance = widget.coinsBalance;
    _avatarStore = widget.avatarStore;
  }

  ProfileAvatarStoreItem? get _selectedItem {
    for (final item in _avatarStore) {
      if (item.seed == _selectedSeed) {
        return item;
      }
    }
    return null;
  }

  bool get _canSubmit {
    final item = _selectedItem;
    if (_isSubmitting || item == null) {
      return false;
    }
    if (item.equipped) {
      return false;
    }
    return item.owned || item.affordable;
  }

  String _primaryLabel(ProfileAvatarStoreItem? item) {
    if (_isSubmitting) {
      return 'Salvando...';
    }
    if (item == null) {
      return 'Selecionar';
    }
    if (item.equipped) {
      return 'Em uso';
    }
    if (item.owned) {
      return 'Usar avatar';
    }
    if (item.affordable) {
      return 'Comprar por ${formatCoinsLabel(item.costCoins)}';
    }
    return 'Saldo insuficiente';
  }

  String _compactCoins(double coins) {
    final normalized = coins < 0 ? 0.0 : coins;
    final scaled = (normalized * 10).round();
    final hasFraction = scaled % 10 != 0;
    return hasFraction
        ? '${normalized.toStringAsFixed(1)}c'
        : '${normalized.toStringAsFixed(0)}c';
  }

  Future<void> _submitSelection() async {
    final item = _selectedItem;
    if (!_canSubmit || item == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _helperText = null;
    });

    try {
      final result = await selectProfileAvatar(item.seed);
      if (!mounted) return;

      if (result.isSuccess) {
        Navigator.pop(context, true);
        return;
      }

      setState(() {
        _coinsBalance = result.coinsBalance;
        _avatarStore = result.avatarStore;
        _helperText = result.missingCoins != null
            ? 'Faltam ${formatCoinsLabel(result.missingCoins!)} para liberar esse avatar.'
            : 'Saldo insuficiente para esse avatar.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _helperText = 'Não foi possível atualizar seu avatar agora.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _selectedItem;
    final helperText =
        _helperText ??
        (selectedItem != null && !selectedItem.owned && !selectedItem.affordable
            ? 'Você precisa de ${formatCoinsLabel(selectedItem.costCoins)} para esse avatar.'
            : null);

    return Dialog(
      backgroundColor: widget.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loja de avatares',
              style: GoogleFonts.manrope(
                color: widget.onSurface,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Saldo atual: ${formatCoinsLabel(_coinsBalance)}',
              style: GoogleFonts.inter(
                color: widget.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              itemCount: _avatarStore.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final item = _avatarStore[index];
                final isSelected = _selectedSeed == item.seed;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSeed = item.seed;
                      _helperText = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? widget.primary
                            : (item.equipped
                                  ? const Color(0xFFFFC857)
                                  : Colors.white.withValues(alpha: 0.06)),
                        width: isSelected || item.equipped ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: item.owned
                                    ? Colors.transparent
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: ClipOval(child: RandomAvatar(item.seed)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: widget.onSurface,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.equipped
                                ? const Color(
                                    0xFFFFC857,
                                  ).withValues(alpha: 0.16)
                                : item.owned
                                ? widget.primary.withValues(alpha: 0.14)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.equipped
                                ? 'Em uso'
                                : item.owned
                                ? 'Comprado'
                                : item.costCoins <= 0
                                ? 'Grátis'
                                : _compactCoins(item.costCoins),
                            style: GoogleFonts.inter(
                              color: item.equipped
                                  ? const Color(0xFFFFD977)
                                  : item.owned
                                  ? widget.primary
                                  : widget.onSurface.withValues(alpha: 0.82),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (helperText != null) ...[
              const SizedBox(height: 16),
              Text(
                helperText,
                style: GoogleFonts.inter(
                  color: widget.onSurface.withValues(alpha: 0.82),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.manrope(
                        color: widget.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _submitSelection : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primary,
                      disabledBackgroundColor: widget.primary.withValues(
                        alpha: 0.35,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _primaryLabel(selectedItem),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
