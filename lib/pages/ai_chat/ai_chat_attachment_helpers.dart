part of 'ai_chat_screen.dart';

const int _aiChatMaxPendingAttachments = 3;
const int _aiChatMaxAttachmentBytes = 6 * 1024 * 1024;

enum _AiChatAttachmentAction { camera, gallery, file }

String _fileNameFromPath(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    return 'anexo';
  }
  return normalized.split(RegExp(r'[\\/]')).last;
}

String _mimeTypeFromName(String name) {
  final normalized = name.toLowerCase().trim();
  if (normalized.endsWith('.png')) {
    return 'image/png';
  }
  if (normalized.endsWith('.jpg') || normalized.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (normalized.endsWith('.webp')) {
    return 'image/webp';
  }
  if (normalized.endsWith('.heic')) {
    return 'image/heic';
  }
  if (normalized.endsWith('.heif')) {
    return 'image/heif';
  }
  if (normalized.endsWith('.pdf')) {
    return 'application/pdf';
  }
  if (normalized.endsWith('.md')) {
    return 'text/markdown';
  }
  if (normalized.endsWith('.csv')) {
    return 'text/csv';
  }
  if (normalized.endsWith('.txt')) {
    return 'text/plain';
  }
  return 'application/octet-stream';
}

bool _isSupportedAttachmentMime(String mimeType) {
  return const {
    'image/png',
    'image/jpeg',
    'image/webp',
    'image/heic',
    'image/heif',
    'application/pdf',
    'text/plain',
    'text/markdown',
    'text/csv',
  }.contains(mimeType.toLowerCase().trim());
}

String _formatAttachmentSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  }
  final kb = bytes / 1024;
  if (kb < 1024) {
    return '${kb.toStringAsFixed(kb < 10 ? 1 : 0)} KB';
  }
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(mb < 10 ? 1 : 0)} MB';
}

IconData _attachmentIconFor(AiChatAttachment attachment) {
  final mimeType = attachment.mimeType.toLowerCase();
  if (mimeType == 'application/pdf') {
    return Icons.picture_as_pdf_rounded;
  }
  if (mimeType.startsWith('text/')) {
    return Icons.description_rounded;
  }
  if (attachment.isImage) {
    return Icons.image_rounded;
  }
  return Icons.attach_file_rounded;
}
