// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

Future downloadFile(
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

    // Make HTTP request to download the PDF
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
        FFAppState().downloadStatus =
            "Failed to download PDF: ${response.statusCode}";
      });
    }
  } catch (e) {
    FFAppState().update(() {
      FFAppState().downloadStatus = "Error downloading PDF: $e";
    });
  }
}
