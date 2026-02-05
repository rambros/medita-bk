import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/core/services/index.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart';

// Global instance
late AudioPlayerController globalAudioPlayerController;
late Stopwatch globalWatch;

Future<void> initAudioPlayerController() async {
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
  bool _listenersInitialized = false;

  void initPlaylistPlayer(PlaylistModel audios) async {
    _listAudios = audios.listAudios;
    await _loadPlaylist(audios);
    currentSongTitleNotifier.value = _listAudios[0].title;
    _initListeners();
    play();
  }

  void initAudioPlayer(PlayerModel model) async {
    // Parar e limpar a fila apenas se houver algo tocando
    try {
      final playbackState = _audioHandler.playbackState.value;
      if (playbackState.playing || playbackState.processingState != AudioProcessingState.idle) {
        await _audioHandler.stop();
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao parar player: $e');
    }

    await _loadMusic(model);

    // Só inicializa listeners uma vez
    if (!_listenersInitialized) {
      _initListeners();
      _listenersInitialized = true;
    }

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
              artist: audio.author,
              title: audio.title,
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
      if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
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

  void clearQueue() {
    try {
      // Sempre remove o primeiro item até a fila estar vazia
      // Adiciona proteção contra loop infinito
      int maxIterations = 100;
      int count = 0;
      while (_audioHandler.queue.value.isNotEmpty && count < maxIterations) {
        _audioHandler.removeQueueItemAt(0);
        count++;
      }
      if (count >= maxIterations) {
        debugPrint('⚠️ clearQueue: atingiu limite de iterações, forçando limpeza');
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao limpar fila: $e');
    }
  }

  void dispose() {
    globalWatch.stop();
    _audioHandler.stop();
    _audioHandler.customAction('dispose');
  }

  void stop() {
    globalWatch.stop();
    AppStateStore().addToMeditationLogList(
        MeditationLogStruct(duration: globalWatch.elapsed.inSeconds, date: DateTime.now(), type: 'guided'));
    clearMusicTitle();
    globalWatch.reset();
    _audioHandler.stop();
  }

  void clearMusicTitle() {
    currentSongTitleNotifier.value = 'Carregando...';
    _updateSkipButtons();
  }

  Future<bool> isCached(String url) async => await _audioHandler.customAction('isCached', {'url': url}) == true;

  Future<void> download(String url) => _audioHandler.customAction('cacheAudio', {'url': url});

  Future<void> clearDownloads() => _audioHandler.customAction('clearCache');
}
