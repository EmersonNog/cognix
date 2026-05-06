part of '../ai_chat_screen.dart';

extension _AiChatAttachmentFlow on _AiChatScreenState {
  Future<void> _openAttachmentOptions() async {
    _inputFocusNode.unfocus();
    final action = await showModalBottomSheet<_AiChatAttachmentAction>(
      context: context,
      backgroundColor: context.cognixColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AiChatAttachmentOptionsSheet(),
    );

    if (action == null || !mounted) {
      return;
    }

    switch (action) {
      case _AiChatAttachmentAction.camera:
        await _pickImageAttachment(ImageSource.camera);
        break;
      case _AiChatAttachmentAction.gallery:
        await _pickImageAttachment(ImageSource.gallery);
        break;
      case _AiChatAttachmentAction.file:
        await _pickFileAttachments();
        break;
    }
  }

  Future<void> _pickImageAttachment(ImageSource source) async {
    if (!_canAddAnotherAttachment()) {
      return;
    }

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 88,
      );
      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      if (!mounted) {
        return;
      }
      await _addAttachment(
        name: _fileNameFromPath(
          image.name.isNotEmpty ? image.name : image.path,
        ),
        mimeType: image.mimeType ?? _mimeTypeFromName(image.path),
        bytes: bytes,
      );
    } catch (_) {
      if (!mounted) return;
      showCognixMessage(
        context,
        'Não foi possível adicionar a imagem.',
        type: CognixMessageType.error,
      );
    }
  }

  Future<void> _pickFileAttachments() async {
    if (!_canAddAnotherAttachment()) {
      return;
    }

    try {
      final remaining =
          _aiChatMaxPendingAttachments - _pendingAttachments.length;
      final result = await FilePicker.pickFiles(
        allowMultiple: remaining > 1,
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'txt',
          'md',
          'csv',
          'png',
          'jpg',
          'jpeg',
          'webp',
          'heic',
          'heif',
        ],
        withData: true,
      );
      if (result == null) {
        return;
      }
      if (!mounted) {
        return;
      }

      for (final file in result.files.take(remaining)) {
        final bytes = file.bytes ?? await _readPlatformFileBytes(file);
        if (!mounted) {
          return;
        }
        if (bytes == null) {
          showCognixMessage(
            context,
            'Não foi possível ler ${file.name}.',
            type: CognixMessageType.error,
          );
          continue;
        }
        await _addAttachment(
          name: file.name,
          mimeType: _mimeTypeFromName(file.name),
          bytes: bytes,
        );
      }
    } catch (_) {
      if (!mounted) return;
      showCognixMessage(
        context,
        'Não foi possível adicionar o arquivo.',
        type: CognixMessageType.error,
      );
    }
  }

  Future<List<int>?> _readPlatformFileBytes(PlatformFile file) async {
    final path = file.path;
    if (path == null || path.trim().isEmpty) {
      return null;
    }
    return File(path).readAsBytes();
  }

  Future<void> _addAttachment({
    required String name,
    required String mimeType,
    required List<int> bytes,
  }) async {
    if (!mounted) {
      return;
    }
    if (!_canAddAnotherAttachment()) {
      return;
    }

    if (!_isSupportedAttachmentMime(mimeType)) {
      showCognixMessage(
        context,
        'Formato não suportado. Use PDF, TXT, MD, CSV ou imagem.',
        type: CognixMessageType.error,
      );
      return;
    }

    if (bytes.length > _aiChatMaxAttachmentBytes) {
      showCognixMessage(
        context,
        'Arquivo muito grande. O limite é 6 MB por anexo.',
        type: CognixMessageType.error,
      );
      return;
    }

    final cleanName = name.trim().isEmpty ? 'anexo' : name.trim();
    _update(() {
      _pendingAttachments.add(
        AiChatAttachment(
          name: cleanName,
          mimeType: mimeType,
          dataBase64: base64Encode(bytes),
          sizeBytes: bytes.length,
        ),
      );
    });
  }

  bool _canAddAnotherAttachment() {
    if (!mounted) {
      return false;
    }
    if (_pendingAttachments.length < _aiChatMaxPendingAttachments) {
      return true;
    }
    showCognixMessage(
      context,
      'Você pode enviar até $_aiChatMaxPendingAttachments anexos por mensagem.',
      type: CognixMessageType.error,
    );
    return false;
  }

  void _removePendingAttachment(int index) {
    if (index < 0 || index >= _pendingAttachments.length) {
      return;
    }
    _update(() {
      _pendingAttachments.removeAt(index);
    });
  }
}
