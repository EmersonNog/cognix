part of '../ai_chat_screen.dart';

extension _AiChatMessageFlow on _AiChatScreenState {
  bool get _canSendMessage =>
      (_hasInput || _pendingAttachments.isNotEmpty) && !_isSending;

  void _handleInputChanged() {
    final hasInput = _inputController.text.trim().isNotEmpty;
    if (_hasInput == hasInput) {
      return;
    }

    _update(() {
      _hasInput = hasInput;
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    final attachments = List<AiChatAttachment>.of(_pendingAttachments);
    if ((text.isEmpty && attachments.isEmpty) || _isSending) {
      return;
    }
    if (!await _stopVoiceInputIfNeeded()) {
      return;
    }

    final content = text.isNotEmpty
        ? text
        : 'Leia os anexos enviados e me explique os pontos principais.';
    _update(() {
      _messages.add(
        AiChatMessage(
          role: AiChatRole.user,
          content: content,
          createdAt: DateTime.now(),
          attachments: attachments,
        ),
      );
      _pendingAttachments.clear();
      _errorText = null;
      _requiresSubscription = false;
    });
    _inputController.clear();
    _queueScrollToBottom();

    await _requestAssistantReply();
  }

  Future<void> _sendPrompt(String prompt) async {
    _inputController.text = prompt;
    await _sendMessage();
  }

  Future<void> _requestAssistantReply() async {
    if (_isSending || _messages.isEmpty) {
      return;
    }

    _update(() {
      _isSending = true;
      _errorText = null;
      _requiresSubscription = false;
    });

    try {
      final reply = await sendAiChatMessage(messages: List.of(_messages));
      if (!mounted) {
        return;
      }
      _update(() {
        _messages.add(reply);
      });
      _queueScrollToBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _update(() {
        _errorText = readableApiErrorMessage(error);
        _requiresSubscription = isSubscriptionRequiredError(error);
      });
    } finally {
      if (mounted) {
        _update(() {
          _isSending = false;
        });
      }
    }
  }

  void _clearConversation() {
    _update(() {
      _messages.clear();
      _pendingAttachments.clear();
      _errorText = null;
      _requiresSubscription = false;
    });
    _inputFocusNode.unfocus();
  }

  void _openPremiumPlans() {
    Navigator.of(context).pushNamed('plan');
  }

  void _queueScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }
}
