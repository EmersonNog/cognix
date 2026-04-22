import 'package:image_picker/image_picker.dart';

class ImagePickerRecovery {
  ImagePickerRecovery._();

  static final ImagePickerRecovery instance = ImagePickerRecovery._();

  final ImagePicker _picker = ImagePicker();
  final List<String> _recoveredImagePaths = <String>[];

  Future<void> retrieveLostData() async {
    final response = await _picker.retrieveLostData();
    if (response.isEmpty) return;

    final files = response.files;
    if (files == null || files.isEmpty) return;

    for (final file in files) {
      final path = file.path.trim();
      if (path.isEmpty) continue;
      _recoveredImagePaths.add(path);
    }
  }

  List<String> takeRecoveredImagePaths() {
    final paths = List<String>.from(_recoveredImagePaths);
    _recoveredImagePaths.clear();
    return paths;
  }
}
