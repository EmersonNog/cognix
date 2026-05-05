import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/ai_chat/ai_chat_api.dart';
import '../../services/core/api_client.dart'
    show isSubscriptionRequiredError, readableApiErrorMessage;
import '../../theme/cognix_theme_colors.dart';

part 'ai_chat_helpers.dart';
part 'widgets/ai_chat_bubble.dart';
part 'widgets/ai_chat_composer.dart';
part 'widgets/ai_chat_error_banner.dart';
part 'widgets/ai_chat_header.dart';
part 'widgets/ai_chat_typing_bubble.dart';
part 'widgets/ai_chat_welcome.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key, this.userName}) : embedded = false;

  const AiChatScreen.embedded({super.key, this.userName}) : embedded = true;

  final bool embedded;
  final String? userName;

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<AiChatMessage> _messages = [];

  bool _hasInput = false;
  bool _isSending = false;
  bool _requiresSubscription = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_handleInputChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_handleInputChanged);
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _handleInputChanged() {
    final hasInput = _inputController.text.trim().isNotEmpty;
    if (_hasInput == hasInput) {
      return;
    }

    setState(() {
      _hasInput = hasInput;
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _messages.add(
        AiChatMessage(
          role: AiChatRole.user,
          content: text,
          createdAt: DateTime.now(),
        ),
      );
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

    setState(() {
      _isSending = true;
      _errorText = null;
      _requiresSubscription = false;
    });

    try {
      final reply = await sendAiChatMessage(messages: List.of(_messages));
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.add(reply);
      });
      _queueScrollToBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = readableApiErrorMessage(error);
        _requiresSubscription = isSubscriptionRequiredError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _clearConversation() {
    setState(() {
      _messages.clear();
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

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final content = Column(
      children: [
        Expanded(child: _buildConversationList(colors)),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: _AiChatErrorBanner(
              message: _errorText!,
              actionLabel: _requiresSubscription ? 'Assinar' : 'Tentar',
              onAction: _requiresSubscription
                  ? _openPremiumPlans
                  : _isSending
                  ? null
                  : () => unawaited(_requestAssistantReply()),
            ),
          ),
        _AiChatComposer(
          controller: _inputController,
          focusNode: _inputFocusNode,
          isSending: _isSending,
          canSend: _hasInput && !_isSending,
          onSend: () => unawaited(_sendMessage()),
        ),
      ],
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Chat IA'),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              tooltip: 'Limpar conversa',
              onPressed: _clearConversation,
              icon: const Icon(Icons.delete_sweep_rounded),
            ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildConversationList(CognixThemeColors colors) {
    final includeHeader = widget.embedded;

    if (_messages.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20, includeHeader ? 0 : 12, 20, 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: _AiChatWelcomePanel(
                userName: widget.userName,
                isSending: _isSending,
                onPromptSelected: (prompt) => unawaited(_sendPrompt(prompt)),
              ),
            ),
          );
        },
      );
    }

    return ListView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20, includeHeader ? 0 : 12, 20, 16),
      children: [
        if (includeHeader) ...[
          _AiChatHeader(
            hasMessages: _messages.isNotEmpty,
            onClear: _clearConversation,
          ),
          const SizedBox(height: 12),
        ],
        ..._messages.map(
          (message) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _AiChatBubble(message: message),
          ),
        ),
        if (_isSending) ...[
          const SizedBox(height: 2),
          const _AiChatTypingBubble(),
        ],
      ],
    );
  }
}
