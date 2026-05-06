part of '../ai_chat_screen.dart';

extension _AiChatVoiceFlow on _AiChatScreenState {
  Future<bool> _stopVoiceInputIfNeeded() async {
    if (!_isListening) {
      return true;
    }

    await _speechToText.stop();
    if (!mounted) {
      return false;
    }
    _update(() => _isListening = false);
    return true;
  }

  Future<void> _toggleVoiceInput() async {
    if (_isSending) {
      return;
    }

    if (_isListening) {
      await _stopVoiceInputIfNeeded();
      return;
    }

    final available = _speechAvailable || await _initializeSpeech();
    if (!mounted) {
      return;
    }
    if (!available) {
      showCognixMessage(
        context,
        'Não foi possível acessar o microfone neste dispositivo.',
        type: CognixMessageType.error,
      );
      return;
    }

    _speechBaseText = _inputController.text.trim();
    _update(() => _isListening = true);

    try {
      await _speechToText.listen(
        localeId: 'pt_BR',
        listenFor: const Duration(seconds: 35),
        pauseFor: const Duration(seconds: 4),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          listenMode: stt.ListenMode.dictation,
          cancelOnError: true,
          autoPunctuation: true,
        ),
        onResult: (result) {
          _applySpeechResult(result.recognizedWords);
          if (result.finalResult && mounted) {
            _update(() => _isListening = false);
          }
        },
      );
    } catch (_) {
      if (!mounted) return;
      _update(() => _isListening = false);
      showCognixMessage(
        context,
        'Não consegui iniciar o ditado agora.',
        type: CognixMessageType.error,
      );
    }
  }

  Future<bool> _initializeSpeech() async {
    try {
      final available = await _speechToText.initialize(
        onStatus: _handleSpeechStatus,
        onError: (_) {
          if (!mounted) return;
          _update(() => _isListening = false);
          showCognixMessage(
            context,
            'Não consegui ouvir agora. Tente novamente.',
            type: CognixMessageType.error,
          );
        },
      );
      _speechAvailable = available;
      return available;
    } catch (_) {
      _speechAvailable = false;
      return false;
    }
  }

  void _handleSpeechStatus(String status) {
    if (!mounted) {
      return;
    }
    if (status == 'done' || status == 'notListening') {
      _update(() => _isListening = false);
    }
  }

  void _applySpeechResult(String recognizedWords) {
    final spoken = recognizedWords.trim();
    if (spoken.isEmpty) {
      return;
    }

    final nextText = _speechBaseText.isEmpty
        ? spoken
        : '$_speechBaseText $spoken';
    _inputController.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: nextText.length),
    );
  }
}
