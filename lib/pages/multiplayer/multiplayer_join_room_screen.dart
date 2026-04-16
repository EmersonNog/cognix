import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/multiplayer/multiplayer_api.dart';
import 'widgets/multiplayer_join_widgets.dart';
import 'widgets/multiplayer_widgets.dart';

class MultiplayerJoinRoomScreen extends StatefulWidget {
  const MultiplayerJoinRoomScreen({super.key});

  @override
  State<MultiplayerJoinRoomScreen> createState() =>
      _MultiplayerJoinRoomScreenState();
}

class _MultiplayerJoinRoomScreenState extends State<MultiplayerJoinRoomScreen> {
  final TextEditingController _pinController = TextEditingController();
  Timer? _refreshTimer;
  MultiplayerRoom? _room;
  String? _errorMessage;
  bool _isJoining = false;
  bool _isRefreshing = false;
  bool _isLeaving = false;
  bool _wasRemoved = false;
  bool _handledRemovalRedirect = false;
  bool _handledRoomClosedRedirect = false;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  bool get _canJoin => _pinController.text.trim().length == 6 && !_isJoining;

  String? _currentDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    return null;
  }

  Future<void> _joinRoom() async {
    if (!_canJoin) return;

    setState(() {
      _isJoining = true;
      _errorMessage = null;
      _wasRemoved = false;
    });

    try {
      final room = await joinMultiplayerRoom(
        pin: _pinController.text.trim(),
        displayName: _currentDisplayName(),
      );
      if (!mounted) return;
      setState(() => _room = room);
      _startPolling();
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = humanizeMultiplayerError(error));
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
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
    if (room == null || _isRefreshing || room.isInProgress || _wasRemoved) {
      return;
    }

    _isRefreshing = true;
    if (!silent) {
      setState(() {});
    }
    try {
      final updatedRoom = await fetchMultiplayerRoom(room.id);
      if (!mounted) return;
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final wasRemoved =
          currentUid != null &&
          !updatedRoom.hasParticipantFirebaseUid(currentUid);
      setState(() {
        _room = updatedRoom;
        _wasRemoved = wasRemoved;
      });
      if (updatedRoom.isInProgress || wasRemoved) {
        _refreshTimer?.cancel();
      }
      if (wasRemoved) {
        _handleRemovedFromRoom();
      }
    } catch (error) {
      if (isMultiplayerNotFoundError(error)) {
        _handleRoomClosedByHost();
        return;
      }
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

  Future<void> _leaveRoom() async {
    final room = _room;
    if (room == null || _isLeaving) {
      return;
    }

    const palette = MultiplayerPalette();
    final shouldLeave = await showMultiplayerLeaveConfirmation(
      context,
      palette: palette,
      title: 'Sair da sala?',
      message: 'Você vai abandonar este lobby e sair da sala multiplayer.',
      confirmLabel: 'Sair da sala',
    );
    if (!mounted || !shouldLeave) {
      return;
    }

    setState(() => _isLeaving = true);
    try {
      await leaveMultiplayerRoom(room.id);
      if (!mounted) return;
      _refreshTimer?.cancel();
      Navigator.of(context).pop();
    } catch (error) {
      if (isMultiplayerNotFoundError(error)) {
        _handleRoomClosedByHost();
        return;
      }
      _showError(error);
    } finally {
      if (mounted) {
        setState(() => _isLeaving = false);
      }
    }
  }

  void _handleRemovedFromRoom() {
    if (_handledRemovalRedirect || !mounted) {
      return;
    }

    _handledRemovalRedirect = true;
    _notifyAndGoHome(
      message: 'Você foi removido da sala.',
      backgroundColor: const Color(0xFFB42318),
    );
  }

  void _handleRoomClosedByHost() {
    if (_handledRoomClosedRedirect || !mounted) {
      return;
    }

    _handledRoomClosedRedirect = true;
    _refreshTimer?.cancel();
    _notifyAndGoHome(
      message: 'O criador encerrou a sala.',
      backgroundColor: const Color(0xFFB42318),
    );
  }

  void _notifyAndGoHome({
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
    });
  }

  void _handleBack() {
    final room = _room;
    if (room == null || room.isInProgress || _wasRemoved) {
      Navigator.of(context).pop();
      return;
    }

    _leaveRoom();
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(humanizeMultiplayerError(error))));
  }

  @override
  Widget build(BuildContext context) {
    const palette = MultiplayerPalette();
    final room = _room;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: palette.surface,
        body: MultiplayerScaffold(
          title: room == null ? 'Entrar na sala' : 'Sala encontrada',
          subtitle: room == null
              ? 'Digite o PIN enviado pelo criador da sala.'
              : 'Aguarde o criador iniciar a partida.',
          leadingIcon: Icons.login_rounded,
          palette: palette,
          onBack: _handleBack,
          trailing: room == null
              ? null
              : MultiplayerLobbyRefreshAction(
                  palette: palette,
                  isRefreshing: _isRefreshing,
                  enabled: !room.isInProgress && !_wasRemoved,
                  onRefresh: () => _refreshRoom(),
                ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              if (room == null)
                MultiplayerJoinForm(
                  controller: _pinController,
                  palette: palette,
                  canJoin: _canJoin,
                  isJoining: _isJoining,
                  errorMessage: _errorMessage,
                  onChanged: () => setState(() {}),
                  onJoin: _joinRoom,
                )
              else
                MultiplayerJoinedRoomPreview(
                  room: room,
                  palette: palette,
                  isLeaving: _isLeaving,
                  wasRemoved: _wasRemoved,
                  onLeave: _leaveRoom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
