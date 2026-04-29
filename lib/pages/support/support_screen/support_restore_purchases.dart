part of '../support_screen.dart';

extension on _SupportScreenState {
  void _handleRestorePurchasesResult(GooglePlayRestorePurchasesResult result) {
    if (!result.purchaseRestored) {
      showCognixMessage(
        context,
        'Nenhuma compra ativa foi encontrada para restaurar nesta conta Google Play.',
        type: CognixMessageType.info,
      );
      return;
    }

    if (!result.restoredAccessGranted) {
      showCognixMessage(
        context,
        'Encontramos sua compra no Google Play, mas ela já expirou ou não possui acesso ativo.',
        type: CognixMessageType.info,
      );
      return;
    }

    if (result.restoredSubscriptionIsCancelled) {
      showCognixMessage(
        context,
        _cancelledRestoreMessage(result.restoredSubscription?.accessEndsAt),
        type: CognixMessageType.info,
      );
      _openSubscription();
      return;
    }

    showCognixMessage(
      context,
      'Compra restaurada com sucesso.',
      type: CognixMessageType.success,
    );
    _openSubscription();
  }

  void _showRestorePurchasesError(Object error) {
    final rawMessage = readableApiErrorMessage(error).trim();
    final message = isGooglePlaySubscriptionConflictMessage(rawMessage)
        ? 'Essa assinatura do Google Play já está vinculada a outra conta do Cognix. Entre na conta Cognix onde ela foi ativada para recuperar o acesso.'
        : rawMessage;
    showCognixMessage(
      context,
      message.isEmpty
          ? 'Não foi possível restaurar sua compra agora.'
          : message,
      type: CognixMessageType.error,
    );
  }

  void _openSubscription() {
    Navigator.of(context).pushNamed('subscription');
  }

  String _cancelledRestoreMessage(DateTime? accessEndsAt) {
    final accessEndLabel = _formatDate(accessEndsAt);
    if (accessEndLabel == null) {
      return 'Assinatura cancelada encontrada. Seu acesso permanece ativo até o fim do período pago.';
    }
    return 'Assinatura cancelada encontrada. Seu acesso permanece até $accessEndLabel.';
  }

  String? _formatDate(DateTime? value) {
    if (value == null) {
      return null;
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }
}
