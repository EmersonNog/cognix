part of '../requests.dart';

Future<WritingImageScanResult> scanWritingImage(XFile image) async {
  final bytes = await image.readAsBytes();
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/writing/scan-image'),
    body: {
      'image_base64': base64Encode(bytes),
      'mime_type': image.mimeType ?? _mimeTypeFromPath(image.path),
    },
    errorMessage: 'Não foi possível escanear a redação',
    timeout: const Duration(seconds: 75),
  );
  return parseWritingImageScanResult(payload);
}

String _mimeTypeFromPath(String path) {
  final normalized = path.toLowerCase().trim();
  if (normalized.endsWith('.png')) {
    return 'image/png';
  }
  if (normalized.endsWith('.webp')) {
    return 'image/webp';
  }
  return 'image/jpeg';
}
