part of '../ai_chat_screen.dart';

class _AiChatConversationList extends StatelessWidget {
  const _AiChatConversationList({
    required this.controller,
    required this.embedded,
    required this.messages,
    required this.isSending,
    required this.onClear,
    required this.onPromptSelected,
    this.userName,
  });

  final ScrollController controller;
  final bool embedded;
  final List<AiChatMessage> messages;
  final bool isSending;
  final String? userName;
  final VoidCallback onClear;
  final ValueChanged<String> onPromptSelected;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: controller,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20, embedded ? 0 : 12, 20, 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: _AiChatWelcomePanel(
                userName: userName,
                isSending: isSending,
                onPromptSelected: onPromptSelected,
              ),
            ),
          );
        },
      );
    }

    return ListView(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20, embedded ? 0 : 12, 20, 16),
      children: [
        if (embedded) ...[
          _AiChatHeader(hasMessages: messages.isNotEmpty, onClear: onClear),
          const SizedBox(height: 12),
        ],
        ...messages.map(
          (message) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _AiChatBubble(message: message),
          ),
        ),
        if (isSending) ...[
          const SizedBox(height: 2),
          const _AiChatTypingBubble(),
        ],
      ],
    );
  }
}
