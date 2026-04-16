import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/multiplayer/multiplayer_api.dart';
import 'widgets/multiplayer_create_widgets.dart';
import 'widgets/multiplayer_dialogs.dart';
import 'widgets/multiplayer_lobby_widgets.dart';
import 'widgets/multiplayer_palette.dart';
import 'widgets/multiplayer_scaffold.dart';

class MultiplayerCreateRoomScreen extends StatefulWidget {
  const MultiplayerCreateRoomScreen({super.key});

  @override
  State<MultiplayerCreateRoomScreen> createState() =>
      _MultiplayerCreateRoomScreenState();
}

class _MultiplayerCreateRoomScreenState
    extends State<MultiplayerCreateRoomScreen> {
  Timer? _refreshTimer;
  MultiplayerRoom? _room;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isStarting = false;
  bool _isClosing = false;
  final Set<int> _removingParticipantIds = <int>{};

  @override
  void initState() {
    super.initState();
    _createRoom();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String? _currentDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    return null;
  }

  Future<void> _createRoom() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final room = await createMultiplayerRoom(
        displayName: _currentDisplayName(),
      );
      if (!mounted) return;
      setState(() {
        _room = room;
        _isLoading = false;
      });
      _startPolling();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = humanizeMultiplayerError(error);
        _isLoading = false;
      });
    }
  }

  void _startPolling() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _refreshRoom(silent: true),
    );
  }

  Future<void> _refreshRoom({bool silent = false}) async {
    final room = _room;
    if (room == null || _isRefreshing || room.isInProgress) {
      return;
    }

    _isRefreshing = true;
    if (!silent) {
      setState(() {});
    }
    try {
      final updatedRoom = await fetchMultiplayerRoom(room.id);
      if (!mounted) return;
      setState(() => _room = updatedRoom);
      if (updatedRoom.isInProgress) {
        _refreshTimer?.cancel();
      }
    } catch (error) {
      if (!silent) {
        _showError(error);
      }
    } finally {
      _isRefreshing = false;
      if (!silent && mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _removeParticipant(MultiplayerParticipant participant) async {
    final room = _room;
    if (room == null || participant.isHost) {
      return;
    }

    setState(() => _removingParticipantIds.add(participant.id));
    try {
      final updatedRoom = await removeMultiplayerParticipant(
        roomId: room.id,
        participantId: participant.id,
      );
      if (!mounted) return;
      setState(() => _room = updatedRoom);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _removingParticipantIds.remove(participant.id));
      }
    }
  }

  Future<void> _startRoom() async {
    final room = _room;
    if (room == null || !room.isWaiting || room.participants.length < 2) {
      return;
    }

    setState(() => _isStarting = true);
    try {
      final updatedRoom = await startMultiplayerRoom(room.id);
      if (!mounted) return;
      setState(() => _room = updatedRoom);
      _refreshTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Partida iniciada. A tela do jogo entra na próxima etapa.',
          ),
        ),
      );
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }

  Future<void> _handleBack() async {
    final room = _room;
    if (room == null || room.isInProgress) {
      Navigator.of(context).pop();
      return;
    }

    if (_isClosing) {
      return;
    }

    const palette = MultiplayerPalette();
    final shouldLeave = await showMultiplayerLeaveConfirmation(
      context,
      palette: palette,
      title: 'Encerrar sala?',
      message:
          'Se você sair agora, a sala sera encerrada para todos os participantes.',
      confirmLabel: 'Encerrar sala',
    );
    if (!mounted || !shouldLeave) {
      return;
    }

    setState(() => _isClosing = true);
    try {
      await leaveMultiplayerRoom(room.id);
      if (!mounted) return;
      _refreshTimer?.cancel();
      Navigator.of(context).pop();
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isClosing = false);
      }
    }
  }

  void _showError(Object error) {
    _showMessage(humanizeMultiplayerError(error));
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    const palette = MultiplayerPalette();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        backgroundColor: palette.surface,
        body: MultiplayerScaffold(
          title: 'Criar sala',
          subtitle: 'Compartilhe o PIN e aguarde os participantes.',
          leadingIcon: Icons.groups_2_rounded,
          palette: palette,
          onBack: _handleBack,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: _buildContent(palette),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(MultiplayerPalette palette) {
    final room = _room;
    if (_isLoading) {
      return [
        MultiplayerLoadingPanel(
          palette: palette,
          message: 'Criando sala multiplayer...',
        ),
      ];
    }

    if (room == null) {
      return [
        MultiplayerErrorPanel(
          palette: palette,
          title: 'Não conseguimos criar a sala',
          message: _errorMessage ?? 'Não foi possível criar a sala.',
          onRetry: _createRoom,
        ),
      ];
    }

    final canStart =
        room.isWaiting && room.participants.length > 1 && !_isStarting;

    return [
      MultiplayerPinHero(
        pin: room.pin,
        label: 'PIN da sala',
        caption: 'Quem tiver esse código pode entrar na partida.',
        palette: palette,
      ),
      const SizedBox(height: 16),
      MultiplayerRoomStatusCard(
        title: room.isInProgress ? 'Partida iniciada' : 'Sala em espera',
        subtitle: room.isInProgress
            ? 'O lobby ja foi fechado para iniciar o jogo.'
            : 'A lista atualiza automaticamente. Você pode remover participantes antes de iniciar.',
        icon: room.isInProgress
            ? Icons.play_circle_fill_rounded
            : Icons.hourglass_top_rounded,
        palette: palette,
      ),
      const SizedBox(height: 18),
      MultiplayerCreateParticipantsSection(
        participants: room.participants,
        maxParticipants: room.maxParticipants,
        palette: palette,
        removingParticipantIds: _removingParticipantIds,
        onRemove: _removeParticipant,
      ),
      const SizedBox(height: 14),
      OutlinedButton.icon(
        onPressed: _isRefreshing ? null : () => _refreshRoom(),
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary.withValues(alpha: 0.42)),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: _isRefreshing
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: palette.primary,
                ),
              )
            : const Icon(Icons.refresh_rounded, size: 18),
        label: Text(
          _isRefreshing ? 'Atualizando...' : 'Atualizar participantes',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
      ),
      const SizedBox(height: 10),
      FilledButton.icon(
        onPressed: canStart ? _startRoom : null,
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          disabledBackgroundColor: palette.surfaceContainerHigh,
          disabledForegroundColor: palette.onSurfaceMuted,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: _isStarting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                room.isInProgress
                    ? Icons.check_rounded
                    : Icons.play_arrow_rounded,
              ),
        label: Text(
          room.isInProgress
              ? 'Partida iniciada'
              : room.participants.length > 1
              ? 'Iniciar partida'
              : 'Aguardando jogadores',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
        ),
      ),
    ];
  }
}
