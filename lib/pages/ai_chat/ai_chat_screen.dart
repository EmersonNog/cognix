import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../services/ai_chat/ai_chat_api.dart';
import '../../services/core/api_client.dart'
    show isSubscriptionRequiredError, readableApiErrorMessage;
import '../../theme/cognix_theme_colors.dart';
import '../../widgets/cognix/cognix_messages.dart';

part 'ai_chat_helpers.dart';
part 'ai_chat_attachment_helpers.dart';
part 'state/ai_chat_attachment_flow.dart';
part 'state/ai_chat_message_flow.dart';
part 'state/ai_chat_voice_flow.dart';
part 'widgets/ai_chat_attachment_options_sheet.dart';
part 'widgets/ai_chat_attachment_preview.dart';
part 'widgets/ai_chat_bubble.dart';
part 'widgets/ai_chat_bubble_attachments.dart';
part 'widgets/ai_chat_composer.dart';
part 'widgets/ai_chat_conversation_list.dart';
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
  final List<AiChatAttachment> _pendingAttachments = [];
  final ImagePicker _imagePicker = ImagePicker();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _hasInput = false;
  bool _isSending = false;
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _requiresSubscription = false;
  String _speechBaseText = '';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_handleInputChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_handleInputChanged);
    unawaited(_speechToText.cancel());
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _update(VoidCallback callback) {
    if (!mounted) {
      return;
    }
    setState(callback);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final content = Column(
      children: [
        Expanded(
          child: _AiChatConversationList(
            controller: _scrollController,
            embedded: widget.embedded,
            messages: _messages,
            isSending: _isSending,
            userName: widget.userName,
            onClear: _clearConversation,
            onPromptSelected: (prompt) => unawaited(_sendPrompt(prompt)),
          ),
        ),
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
          isListening: _isListening,
          attachments: _pendingAttachments,
          canSend: _canSendMessage,
          onOpenAttachments: _isSending
              ? null
              : () => unawaited(_openAttachmentOptions()),
          onRemoveAttachment: _removePendingAttachment,
          onVoiceInput: _isSending
              ? null
              : () => unawaited(_toggleVoiceInput()),
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
}
