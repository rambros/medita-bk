import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '/ui/core/flutter_flow/flutter_flow_util.dart';

/// Network utilities for connectivity and file downloads
class NetworkUtils {
  /// Check if device has internet access
  ///
  /// Returns true if connected to network and can reach the internet.
  static Future<bool> hasInternetAccess() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none)) return false;

    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Download a file from URL
  ///
  /// [url] - URL of the file to download
  /// [suggestedFileName] - Suggested name for the downloaded file
  ///
  /// Updates FFAppState().downloadStatus with the result.
  static Future<void> downloadFile(
    String url,
    String suggestedFileName,
  ) async {
    try {
      // Prompt the user to pick a directory to save the file
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        FFAppState().update(() {
          FFAppState().downloadStatus = "Nenhum diretório selecionado";
        });
        return;
      }

      // Make HTTP request to download the file
      final response = await http.get(Uri.parse(url));

      // Check if the download was successful
      if (response.statusCode == 200) {
        // Define the full file path with user-selected directory and suggested file name
        final filePath = '$selectedDirectory/$suggestedFileName.pdf';

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        FFAppState().update(() {
          FFAppState().downloadStatus = "PDF salvo em: $filePath";
        });
      } else {
        FFAppState().update(() {
          FFAppState().downloadStatus = "Failed to download PDF: ${response.statusCode}";
        });
      }
    } catch (e) {
      FFAppState().update(() {
        FFAppState().downloadStatus = "Error downloading PDF: $e";
      });
    }
  }
}
