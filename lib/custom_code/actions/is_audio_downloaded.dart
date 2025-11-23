// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'init_audio_player_controller.dart';

Future<bool> isAudioDownloaded(
  String audioUrl,
) async {
  if (audioUrl.trim().isEmpty) {
    return false;
  }

  AudioPlayerController controller;
  try {
    controller = globalAudioPlayerController;
  } catch (_) {
    await initAudioPlayerController();
    controller = globalAudioPlayerController;
  }

  try {
    return await controller.isCached(audioUrl);
  } catch (e) {
    //debugPrint('isAudioDownloaded error: $e');
    return false;
  }
}
