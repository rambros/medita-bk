import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '/core/utils/logger.dart';

/// Utility class for UI-related operations like sharing content
class UIUtils {
  /// Shares an image from a URL along with text
  ///
  /// Downloads the image from [imageUrl], saves it temporarily,
  /// and shares it along with [textToShare].
  /// If image download fails, falls back to sharing only the text.
  static Future<void> shareImageAndText(
    String imageUrl,
    String textToShare,
  ) async {
    try {
      // Download image from URL
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;

      // Extract filename from URL, removing query parameters
      final fullPath = Uri.parse(imageUrl).path;
      final fileName = path.basename(fullPath).split('?')[0];

      // Create temporary file
      final filePath = path.join(tempPath, fileName);
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Share both image and text
      await Share.shareXFiles(
        [XFile(file.path)],
        text: textToShare,
      );
    } catch (e) {
      // If image sharing fails, fallback to sharing just the text
      await Share.share(textToShare);
      logDebug('Error sharing image: $e');
    }
  }
}
