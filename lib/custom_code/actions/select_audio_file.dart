// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:file_picker/file_picker.dart' as fp;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String?> selectAudioFile() async {
  try {
    var result = await fp.FilePicker.platform.pickFiles(
      type: fp.FileType.custom,
      allowedExtensions: ['mp3', 'acc'],
    );
    if (result != null) {
      File? selectedAudio = File(result.files.single.path!);
      final player = AudioPlayer();
      Duration? audioDuration = await player.setFilePath(selectedAudio.path);
      await player.stop();
      await player.dispose();

      var nameAudioFile = selectedAudio.path.split('/').last;
      var appDocumentsDirectory = await getApplicationDocumentsDirectory();
      var appDocumentsPath = appDocumentsDirectory.path;
      var filePath = '$appDocumentsPath/$nameAudioFile';
      File newPermenentAudioFile = await selectedAudio.copy(filePath);

      var deviceMusic = AudioModelStruct(
        id: DateTime.now().toIso8601String(),
        title: 'Não especificado',
        author: 'Não especificado',
        audioType: AudioType.device_music,
        duration: audioDuration!.inSeconds,
        fileLocation: newPermenentAudioFile.path,
        fileType: FileType.file,
      );
      FFAppState().tempAudioModel = deviceMusic;
      return nameAudioFile;
    }
    return null;
  } catch (e) {
    print('Unsupported operation$e');
    return null;
  }
}
