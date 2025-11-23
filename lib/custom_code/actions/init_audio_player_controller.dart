// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom actions

// Imports other custom actions

import 'init_audio_service.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

late Stopwatch globalWatch;
late AudioPlayerController globalAudioPlayerController;

Future initAudioPlayerController() async {
  globalWatch = Stopwatch();
  globalAudioPlayerController = AudioPlayerController();
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.speech());
}

class PlayButtonNotifier extends ValueNotifier<ButtonState> {
  PlayButtonNotifier() : super(_initialValue);
  static const _initialValue = ButtonState.paused;
}

enum ButtonState {
  paused,
  playing,
  loading,
}

class ProgressNotifier extends ValueNotifier<ProgressBarState> {
  ProgressNotifier() : super(_initialValue);
  static const _initialValue = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: playerController.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: playerController.seek,
          baseBarColor: Colors.white10,
          bufferedBarColor: Colors.white30,
          progressBarColor: Colors.white,
          thumbColor: Colors.white,
          timeLabelTextStyle: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        );
      },
    );
  }
}

class RepeatButtonNotifier extends ValueNotifier<RepeatState> {
  RepeatButtonNotifier() : super(_initialValue);
  static const _initialValue = RepeatState.off;

  void nextState() {
    final next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<ButtonState>(
      valueListenable: playerController.playButtonNotifier,
      // ignore: missing_return
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 56.0,
              height: 64.0,
              //color: Colors.black,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 68.0,
              color: Colors.white,
              onPressed: playerController.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 64.0,
              color: Colors.white,
              onPressed: playerController.pause,
            );
        }
      },
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<RepeatState>(
      valueListenable: playerController.repeatButtonNotifier,
      builder: (context, value, child) {
        late Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: playerController.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 56.0,
          color: Colors.white,
          onPressed: (isFirst) ? null : playerController.previous,
        );
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 56.0,
          color: Colors.white,
          onPressed: (isLast) ? null : playerController.next,
        );
      },
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    final listAudios = playerController.listAudios;
    return ValueListenableBuilder<int>(
      valueListenable: playerController.currentIndexTitleNotifier,
      builder: (_, index, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            listAudios[index].title ?? 'Carregando...',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      },
    );
  }
}

// class CompletedSongButton extends StatelessWidget {
//   const CompletedSongButton({super.key, required this.nextActionFunction});
//   final Function() nextActionFunction;
//   @override
//   Widget build(BuildContext context) {
//     final playerController = globalAudioPlayerController;
//     return ValueListenableBuilder<bool>(
//       valueListenable: playerController.completedSongNotifier,
//       builder: (_, isCompleted, __) {
//         return isCompleted
//             ? ElevatedButton(
//                 onPressed: nextActionFunction,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFF9A61A),
//                   elevation: 3.0,
//                   padding: const EdgeInsetsDirectional.fromSTEB(
//                       24.0, 0.0, 24.0, 0.0),
//                   fixedSize: const Size.fromHeight(40.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     side:
//                         const BorderSide(color: Colors.transparent, width: 1.0),
//                   ),
//                 ),
//                 child: Text(
//                   'Avançar',
//                   style: FlutterFlowTheme.of(context).titleSmall.override(
//                         fontFamily:
//                             FlutterFlowTheme.of(context).titleSmallFamily,
//                         color: Colors.white,
//                         letterSpacing: 0.0,
//                       ),
//                 ),
//               )
//             : const SizedBox();
//       },
//     );
//   }
// }

class PlaylistModel {
  final String? id;
  final String? urlAudio;
  final String? urlImage;
  final String? title;
  final String? duration;
  final List<AudioModelStruct> listAudios;

  PlaylistModel({
    this.id,
    this.urlAudio,
    this.urlImage,
    this.title,
    this.duration,
    required this.listAudios,
  });
}

class PlayerModel {
  final String? id;
  final String? urlAudio;
  final String? urlImage;
  final String? title;
  final String? duration;

  PlayerModel({
    this.id,
    this.urlAudio,
    this.urlImage,
    this.title,
    this.duration,
  });
}

class AudioPlayerController {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final currentIndexTitleNotifier = ValueNotifier<int>(0);
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final completedSongNotifier = ValueNotifier<bool>(false);

  final AudioHandler _audioHandler = globalAudioHandler;
  var _listAudios = <AudioModelStruct>[];

  void initPlaylistPlayer(PlaylistModel audios) async {
    _listAudios = audios.listAudios;
    await _loadPlaylist(audios);
    currentSongTitleNotifier.value = _listAudios[0].title;
    _initListeners();
    play();
  }

  void initAudioPlayer(PlayerModel model) async {
    await _loadMusic(model);
    _initListeners();
    play();
  }

  void _initListeners() {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> _loadMusic(PlayerModel model) async {
    final mediaItem = MediaItem(
      id: 'Meditação',
      album: 'MeditaBk Meditações',
      title: model.title ?? 'Meditação',
      artUri: Uri.tryParse(model.urlImage!),
      extras: {'url': model.urlAudio},
    );
    await _audioHandler.addQueueItem(mediaItem);
    completedSongNotifier.value = false; //reset at each new song
  }

  Future<void> _loadPlaylist(PlaylistModel model) async {
    final mediaItems = model.listAudios
        .map((audio) => MediaItem(
              id: getRandom(99999).toString(),
              album: 'MeditaBk Meditações',
              artist: audio.author ?? 'Brahma Kumaris',
              title: audio.title ?? 'Meditação',
              artUri: Uri.tryParse(model.urlImage!),
              duration: Duration(seconds: audio.duration),
              extras: {
                'url': audio.fileLocation,
                'audioType': audio.audioType.toString(),
                'fileType': audio.fileType.toString(),
              },
            ))
        .toList();
    await _audioHandler.addQueueItems(mediaItems);
  }

  List<AudioModelStruct> get listAudios => _listAudios;

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      currentIndexTitleNotifier.value = playbackState.queueIndex ?? 0;
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      //print(processingState);
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        if (processingState == AudioProcessingState.completed) {
          completedSongNotifier.value = true;
        }
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      if (playlist.first == mediaItem) {
        isFirstSongNotifier.value = true;
      } else {
        isFirstSongNotifier.value = false;
      }
      //isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() {
    _audioHandler.play();
    globalWatch.start();
  }

  void pause() {
    _audioHandler.pause();
    globalWatch.stop();
  }

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    globalWatch.stop();
    _audioHandler.stop();
    _audioHandler.customAction('dispose');
  }

  void stop() {
    globalWatch.stop();
    FFAppState().addToMeditationLogList(MeditationLogStruct(
        duration: globalWatch.elapsed.inSeconds,
        date: DateTime.now(),
        type: 'guided'));
    clearMusicTitle();
    globalWatch.reset();
    _audioHandler.stop();
  }

  void clearMusicTitle() {
    currentSongTitleNotifier.value = 'Carregando...';
    _updateSkipButtons();
  }

  Future<bool> isCached(String url) async =>
      await _audioHandler.customAction('isCached', {'url': url}) == true;

  Future<void> download(String url) =>
      _audioHandler.customAction('cacheAudio', {'url': url});

  Future<void> clearDownloads() => _audioHandler.customAction('clearCache');

  // void saveStatistics(PlaylistModel model) async {
  //   var duration = watch.elapsed.inSeconds;
  //   final df = DateFormat('yyyy-MM-dd');
  //   final tf = DateFormat('hh:mm');
  //   final dateMeditation = df.format(DateTime.now());
  //   final timeMeditation = tf.format(DateTime.now());

  //   FFAppState().addToMeditationLogList(MeditationLogStruct(
  //       duration: globalWatch.elapsed.inSeconds,
  //       date: DateTime.now(),
  //       type: 'guided'));

  //   watch.stop();
  // }
}
