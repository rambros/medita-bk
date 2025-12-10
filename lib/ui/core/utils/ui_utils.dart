import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/core/utils/logger.dart';

/// UI interaction utilities
class UIUtils {
  /// Reorder items in a list
  ///
  /// Moves an item from oldIndex to newIndex in the list.
  static Future<List<AudioModelStruct>> reorderItems(
    List<AudioModelStruct> list,
    int newIndex,
    int oldIndex,
  ) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    return list;
  }

  /// Share image and text
  ///
  /// Downloads an image from URL and shares it along with text.
  /// Falls back to sharing just text if image download fails.
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
