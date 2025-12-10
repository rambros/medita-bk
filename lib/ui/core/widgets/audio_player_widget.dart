// Automatic FlutterFlow imports
import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_b_k/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'seek_bar.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:medita_b_k/core/controllers/index.dart';

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
    this.showTitle = false,
  });

  final double? width;
  final double? height;
  final String audioTitle;
  final String audioUrl;
  final String audioArt;
  final Color? colorButton;
  final bool showTitle;

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  // Estado do download/cache
  bool _isDownloaded = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _prepareAudio();
  }

  /// Prepara o audio: verifica cache e baixa se necessario
  void _prepareAudio() {
    if (widget.audioUrl.isEmpty) return;

    Future.microtask(() async {
      // Verifica se ja esta em cache
      final cached = await globalAudioPlayerController.isCached(widget.audioUrl);
      if (!mounted) return;

      if (cached) {
        setState(() => _isDownloaded = true);
        await _init();
        return;
      }

      // Se nao esta em cache, baixa primeiro
      await _downloadAudio();
    });
  }

  /// Baixa o audio para o cache
  Future<void> _downloadAudio() async {
    if (!mounted || _isDownloading || widget.audioUrl.isEmpty) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      await globalAudioPlayerController.download(widget.audioUrl);
    } catch (e) {
      logDebug('Erro ao baixar audio: $e');
    } finally {
      if (mounted) {
        final cached = await globalAudioPlayerController.isCached(widget.audioUrl);
        if (mounted) {
          setState(() {
            _isDownloaded = cached;
            _isDownloading = false;
          });
          // Inicializa o player apos o download
          if (cached) {
            await _init();
          }
        }
      }
    }
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(
        Uri.parse(widget.audioUrl),
        tag: MediaItem(
          id: 'EAD_Audio',
          album: 'MeditaBK EAD',
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${duration.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final buttonColor = widget.colorButton ?? appTheme.primary;

    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Espaço superior para layout limpo
          const SizedBox(height: 32),

          // Titulo do audio (se showTitle = true)
          if (widget.showTitle && widget.audioTitle.isNotEmpty) ...[
            Text(
              widget.audioTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: appTheme.titleMedium.copyWith(
                color: appTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Banner de download (se estiver baixando)
          if (_isDownloading && !_isDownloaded) ...[
            _DownloadBanner(buttonColor: buttonColor),
            const SizedBox(height: 16),
          ],

          // Slider de progresso com tempos
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              final duration = positionData?.duration ?? Duration.zero;
              final position = positionData?.position ?? Duration.zero;

              return Column(
                children: [
                  // Slider customizado
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      activeTrackColor: buttonColor,
                      inactiveTrackColor: buttonColor.withOpacity(0.2),
                      thumbColor: buttonColor,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                      value: position.inMilliseconds.toDouble().clamp(0, duration.inMilliseconds.toDouble()),
                      onChanged: _isDownloaded
                          ? (value) {
                              _player.seek(Duration(milliseconds: value.round()));
                            }
                          : null,
                    ),
                  ),

                  // Tempos (posicao atual / duracao total)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: appTheme.bodySmall.copyWith(
                            color: appTheme.secondaryText,
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: appTheme.bodySmall.copyWith(
                            color: appTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Controles de audio (botoes grandes)
          _AudioControls(
            player: _player,
            buttonColor: buttonColor,
            isReady: _isDownloaded,
          ),
        ],
      ),
    );
  }
}

/// Banner de download mostrando progresso
class _DownloadBanner extends StatelessWidget {
  final Color buttonColor;

  const _DownloadBanner({required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Preparando áudio...',
            style: appTheme.bodySmall.copyWith(
              color: buttonColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioControls extends StatelessWidget {
  final AudioPlayer player;
  final Color buttonColor;
  final bool isReady;

  const _AudioControls({
    required this.player,
    required this.buttonColor,
    this.isReady = true,
  });

  void _play() {
    player.play();
    _watch.start();
  }

  void _pause() {
    player.pause();
    _watch.stop();
  }

  void _seekBackward() {
    final newPosition = player.position - const Duration(seconds: 10);
    player.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _seekForward() {
    final newPosition = player.position + const Duration(seconds: 10);
    final duration = player.duration ?? Duration.zero;
    player.seek(newPosition > duration ? duration : newPosition);
  }

  @override
  Widget build(BuildContext context) {
    // Se nao esta pronto, mostra loading
    if (!isReady) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.replay_10_rounded, color: buttonColor.withOpacity(0.3)),
            iconSize: 40,
          ),
          const SizedBox(width: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.forward_10_rounded, color: buttonColor.withOpacity(0.3)),
            iconSize: 40,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botao retroceder 10s
        IconButton(
          onPressed: _seekBackward,
          icon: Icon(Icons.replay_10_rounded, color: buttonColor),
          iconSize: 40,
          tooltip: 'Voltar 10 segundos',
        ),

        const SizedBox(width: 16),

        // Botao play/pause central (maior)
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            // Loading/Buffering
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              );
            }

            // Play
            if (playing != true) {
              return _PlayPauseButton(
                icon: Icons.play_arrow_rounded,
                onPressed: _play,
                buttonColor: buttonColor,
              );
            }

            // Pause
            if (processingState != ProcessingState.completed) {
              return _PlayPauseButton(
                icon: Icons.pause_rounded,
                onPressed: _pause,
                buttonColor: buttonColor,
              );
            }

            // Replay
            return _PlayPauseButton(
              icon: Icons.replay_rounded,
              onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first),
              buttonColor: buttonColor,
            );
          },
        ),

        const SizedBox(width: 16),

        // Botao avancar 10s
        IconButton(
          onPressed: _seekForward,
          icon: Icon(Icons.forward_10_rounded, color: buttonColor),
          iconSize: 40,
          tooltip: 'Avançar 10 segundos',
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color buttonColor;

  const _PlayPauseButton({
    required this.icon,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}

// Mantido para compatibilidade com outros usos
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
