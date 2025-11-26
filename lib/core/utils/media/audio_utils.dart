import 'dart:io';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '/core/structs/index.dart';
import '/core/enums/enums.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/controllers/index.dart';

/// Audio file management and playback utilities
class AudioUtils {
  /// Play a sound from an AudioModelStruct
  ///
  /// Creates a new AudioPlayer instance and plays the sound based on its file type.
  static Future<void> playSound(AudioModelStruct sound) async {
    final audioPlayer = AudioPlayer();
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

  /// Select an audio file from device
  ///
  /// Opens file picker for audio files and copies to app documents directory.
  /// Returns the filename if successful, null otherwise.
  static Future<String?> selectAudioFile() async {
    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['mp3', 'acc'],
      );

      if (result != null) {
        final selectedAudio = File(result.files.single.path!);
        final player = AudioPlayer();
        final audioDuration = await player.setFilePath(selectedAudio.path);
        await player.stop();
        await player.dispose();

        final nameAudioFile = selectedAudio.path.split('/').last;
        final appDocumentsDirectory = await getApplicationDocumentsDirectory();
        final appDocumentsPath = appDocumentsDirectory.path;
        final filePath = '$appDocumentsPath/$nameAudioFile';
        final newPermenentAudioFile = await selectedAudio.copy(filePath);

        final deviceMusic = AudioModelStruct(
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
      // ignore: avoid_print
      print('Unsupported operation$e');
      return null;
    }
  }

  /// Check if device audio files still exist
  ///
  /// Validates that audio files marked as device_music still exist on the device.
  /// Marks invalid files as device_music_invalid.
  static Future<List<AudioModelStruct>> checkDeviceAudios(
    List<AudioModelStruct> audios,
  ) async {
    final tempAudios = audios;
    for (var index = 0; index < tempAudios.length; index++) {
      if (tempAudios[index].audioType == AudioType.device_music) {
        if (await _existsDeviceSound(tempAudios[index]) == false) {
          tempAudios[index].audioType = AudioType.device_music_invalid;
        }
      }
    }
    return tempAudios;
  }

  static Future<bool> _existsDeviceSound(AudioModelStruct audio) async {
    if (isWeb) return true;
    final syncPath = audio.fileLocation;
    return await File(syncPath).exists();
  }

  /// Get list of instrument sounds
  ///
  /// Returns a predefined list of instrument sounds available in the app.
  static Future<List<AudioModelStruct>> getInstrumentSounds() async {
    final List<AudioModelStruct> sounds = [
      AudioModelStruct(
        id: '1',
        title: 'Sino Tibetano',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 18,
        fileLocation: 'audios/sino_tibetano.mp3',
        fileType: FileType.asset,
      ),
      AudioModelStruct(
        id: '2',
        title: 'Taça Tibetana',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 30,
        fileLocation: 'audios/taca_tibetana.mp3',
        fileType: FileType.asset,
      ),
      AudioModelStruct(
        id: '3',
        title: 'Flauta',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 30,
        fileLocation: 'audios/flauta.mp3',
        fileType: FileType.asset,
      ),
      AudioModelStruct(
        id: '4',
        title: 'Harpa',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 30,
        fileLocation: 'audios/harpa.mp3',
        fileType: FileType.asset,
      ),
      AudioModelStruct(
        id: '5',
        title: 'Chuva',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 30,
        fileLocation: 'audios/chuva.mp3',
        fileType: FileType.asset,
      ),
      AudioModelStruct(
        id: '6',
        title: 'Oceano',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 30,
        fileLocation: 'audios/oceano.mp3',
        fileType: FileType.asset,
      ),
      AudioModelStruct(
        id: '7',
        title: 'Pássaros',
        author: 'Brahma Kumaris',
        audioType: AudioType.instrument,
        duration: 30,
        fileLocation: 'audios/passaros.mp3',
        fileType: FileType.asset,
      ),
    ];
    return sounds;
  }

  /// Delete invalid device audio files
  ///
  /// Removes audio files from the list that are marked as device_music_invalid.
  static Future<List<AudioModelStruct>> deleteInvalidDeviceAudios(
    List<AudioModelStruct> audios,
  ) async {
    final tempAudios = audios;
    tempAudios.removeWhere(
      (audio) => audio.audioType == AudioType.device_music_invalid,
    );
    return tempAudios;
  }

  /// Check if an audio file is downloaded/cached
  ///
  /// Returns true if the audio URL is cached locally, false otherwise.
  static Future<bool> isAudioDownloaded(String audioUrl) async {
    if (audioUrl.trim().isEmpty) {
      return false;
    }

    try {
      return await globalAudioPlayerController.isCached(audioUrl);
    } catch (e) {
      return false;
    }
  }

  /// Clear all cached audio files
  ///
  /// Removes all downloaded audio files from the cache.
  static Future<void> clearAudioCache() async {
    try {
      await globalAudioPlayerController.clearDownloads();
    } catch (e) {
      // Silently fail - cache clearing is not critical
    }
  }
}
