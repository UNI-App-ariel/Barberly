import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageCompression {
  static Future<File> compressImage(
    File file, {
    required int width,
    int? height,
    bool? maintainAspectRatio = true,
  }) async {
    try {
      // Read file as bytes
      Uint8List bytes = await file.readAsBytes();

      // Decode image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Invalid image');
      }

      // Resize image (reduce resolution)
      img.Image resized = img.copyResize(
        image,
        width: width,
        height: height,
        maintainAspect: maintainAspectRatio,
      ); // Adjust width and height

      // Convert back to Uint8List with compression
      Uint8List compressedBytes = Uint8List.fromList(
          img.encodeJpg(resized, quality: 85)); // Adjust quality

      // Save compressed image
      final tempDir = await getTemporaryDirectory();
      final compressedFile = File(
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }
}
