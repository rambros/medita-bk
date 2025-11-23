// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:just_audio/just_audio.dart';

Future playSound(AudioModelStruct sound) async {
  var audioPlayer = AudioPlayer();
  switch (sound.fileType) {
    case FileType.asset:
      await audioPlayer.setAsset('assets/${sound.fileLocation}');
      break;
    case FileType.file:
      await audioPlayer.setFilePath(sound.fileLocation);
      break;
    case FileType.url:
      await audioPlayer.setUrl(sound.fileLocation);
      break;
    default:
  }
  await audioPlayer.play();
}
