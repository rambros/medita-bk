// Automatic FlutterFlow imports
import '/core/structs/index.dart';
import '/core/enums/enums.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'seek_bar.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;

Stopwatch _watch = Stopwatch();

class PlaylistPlayerWidget extends StatefulWidget {
  const PlaylistPlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.audioTitle,
    required this.audioArt,
    this.colorButton,
    required this.listAudios,
  });

  final double? width;
  final double? height;
  final String audioTitle;
  final String audioArt;
  final Color? colorButton;
  final List<AudioModelStruct> listAudios;

  @override
  State<PlaylistPlayerWidget> createState() => _PlaylistPlayerWidgetState();
}

class _PlaylistPlayerWidgetState extends State<PlaylistPlayerWidget> {
  //static int _nextMediaId = 0;
  //int _addedCount = 0;
  late AudioPlayer _player;
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  // final isFirstSongNotifier = ValueNotifier<bool>(true);
  // final isLastSongNotifier = ValueNotifier<bool>(true);
  // final currentSongTitleNotifier = ValueNotifier<String>('');
  // final currentIndexTitleNotifier = ValueNotifier<int>(0);
  // final playlistNotifier = ValueNotifier<List<String>>([]);

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.durationStream,
      (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    _watch.stop();
    AppStateStore().addToMeditationLogList(
        MeditationLogStruct(duration: _watch.elapsed.inSeconds, date: DateTime.now(), type: 'guided'));
    _watch.reset();
    super.dispose();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await _loadPlaylist(widget.listAudios);
    //currentSongTitleNotifier.value = widget.listAudios[0].title;

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      logDebug('A stream error occurred: $e', stackTrace: stackTrace);
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      logDebug('Error loading playlist: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _loadPlaylist(List<AudioModelStruct> listAudios) async {
    final mediaItems = widget.listAudios
        .map((audio) => MediaItem(
              id: audio.id,
              album: audio.author,
              artist: audio.author,
              title: audio.title,
              duration: Duration(seconds: audio.duration),
              extras: {
                'url': audio.fileLocation,
                'audioType': audio.audioType,
                'fileType': audio.fileType,
              },
            ))
        .toList();
    final listAudioSource = mediaItems.map(_createAudioSource);
    await _playlist.addAll(listAudioSource.toList());
  }

  IndexedAudioSource _createAudioSource(MediaItem mediaItem) {
    if (mediaItem.extras!['fileType'] == FileType.asset) {
      var caminhoCompleto = mediaItem.extras!['url'];
      var nomeArquivo = path.basename(caminhoCompleto);
      return AudioSource.uri(
        //Uri.parse('asset:///assets/${mediaItem.extras!['url']}'),
        Uri.parse('asset:///assets/audios/$nomeArquivo'),
        tag: mediaItem,
      );
    }
    if (mediaItem.extras!['audioType'] == AudioType.silence) {
      return ClippingAudioSource(
          start: const Duration(seconds: 0),
          end: Duration(seconds: mediaItem.duration!.inSeconds),
          tag: mediaItem,
          child: AudioSource.uri(
            Uri.parse(
              'asset:///assets/audios/silence60.m4a',
            ),
            tag: mediaItem,
          ));
    }
    if (mediaItem.extras!['audioType'] == AudioType.device_music) {
      return ClippingAudioSource(
          start: const Duration(seconds: 0),
          end: Duration(seconds: mediaItem.duration!.inSeconds),
          tag: mediaItem,
          child: AudioSource.uri(
            Uri.file(mediaItem.extras!['url']),
            tag: mediaItem,
          ));
    }
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url']),
      tag: mediaItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0x00F2F3F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder<SequenceState?>(
            stream: _player.sequenceStateStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox();
              final index = snapshot.data!.currentIndex;
              return Text(
                widget.listAudios[index].title,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
              );
            },
          ),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                color: widget.colorButton,
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  _player.seek(newPosition);
                },
              );
            },
          ),
          PlaylistControlButtons(_player, colorButton: widget.colorButton),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class PlaylistControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final Color? colorButton;

  const PlaylistControlButtons(this.player, {super.key, this.colorButton});

  void _play() {
    player.play();
    _watch.start();
  }

  void _pause() {
    player.pause();
    _watch.stop();
  }

  void _skipToNext() async {
    await player.seekToNext();
  }

  void _skipToPrevious() async {
    await player.seekToPrevious();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder<int?>(
            stream: player.currentIndexStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox();
              if (snapshot.data! >= 0 && player.hasNext) {
                return IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 64.0,
                  color: Colors.white,
                  onPressed: _skipToNext,
                );
              } else {
                return const SizedBox(
                  width: 64.0,
                  height: 64.0,
                );
              }
            }),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(color: colorButton ?? Colors.black38),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow, color: colorButton ?? Colors.black38),
                iconSize: 64.0,
                onPressed: () => _play(),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause, color: colorButton ?? Colors.black38),
                iconSize: 64.0,
                onPressed: () => _pause(),
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay, color: colorButton ?? Colors.black38),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<int?>(
            stream: player.currentIndexStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox();
              if (snapshot.data! >= 0 && player.hasPrevious) {
                return IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 64.0,
                  color: Colors.white,
                  onPressed: _skipToPrevious,
                );
              } else {
                return const SizedBox(
                  width: 64.0,
                  height: 64.0,
                );
              }
            }),
      ],
    );
  }
}
