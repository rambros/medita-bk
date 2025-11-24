// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

Future<List<AudioModelStruct>> checkDeviceAudios(List<AudioModelStruct> audios) async {
  // Add your function code here!
  var tempAudios = audios;
  for (var index = 0; index < tempAudios.length; index++) {
    //print('${tempAudios[index].audioType}');
    if (tempAudios[index].audioType == AudioType.device_music) {
      if (await _existsDeviceSound(tempAudios[index]) == false) {
        tempAudios[index].audioType = AudioType.device_music_invalid;
      }
    }
  }
  return tempAudios;
}

Future<bool> _existsDeviceSound(AudioModelStruct audio) async {
  if (isWeb) return true;
  var syncPath = audio.fileLocation;
  return await File(syncPath).exists();
  //return io.File(syncPath).existsSync();
}
