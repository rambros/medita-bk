// Automatic FlutterFlow imports
import '/core/structs/index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'seek_bar.dart';
import '/ui/core/theme/app_theme.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

Stopwatch _watch = Stopwatch();

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.audioTitle,
    required this.audioUrl,
    required this.audioArt,
    this.colorButton,
  });

  final double? width;
  final double? height;
  final String audioTitle;
  final String audioUrl;
  final String audioArt;
  final Color? colorButton;

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(
        Uri.parse(widget.audioUrl),
        tag: MediaItem(
          id: 'GoodWishes',
          album: 'GoodWishes Album',
          title: widget.audioTitle,
          artUri: Uri.parse(widget.audioArt),
        ),
      ),
    ]);

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

  @override
  void dispose() {
    _player.dispose();
    _watch.stop();
    AppStateStore().addToMeditationLogList(
        MeditationLogStruct(duration: _watch.elapsed.inSeconds, date: DateTime.now(), type: 'guided'));
    _watch.reset();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.durationStream,
      (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero));

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
          AudioControlButtons(_player, colorButton: widget.colorButton),
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
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final Color? colorButton;

  const AudioControlButtons(this.player, {super.key, this.colorButton});

  void _play() {
    player.play();
    _watch.start();
  }

  void _pause() {
    player.pause();
    _watch.stop();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final buttonColor = colorButton ?? appTheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                child: CircularProgressIndicator(color: buttonColor),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow, color: buttonColor),
                iconSize: 64.0,
                onPressed: () => _play(),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause, color: buttonColor),
                iconSize: 64.0,
                onPressed: () => _pause(),
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay, color: buttonColor),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first),
              );
            }
          },
        ),
      ],
    );
  }
}
