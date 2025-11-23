// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'init_audio_player_controller.dart';

Future<void> clearAudioCache() async {
  AudioPlayerController controller;
  try {
    controller = globalAudioPlayerController;
  } catch (_) {
    await initAudioPlayerController();
    controller = globalAudioPlayerController;
  }

  try {
    await controller.clearDownloads();
  } catch (e) {
    //debugPrint('clearAudioCache error: $e');
  }
}
