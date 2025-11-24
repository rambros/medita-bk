// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom widgets

import '/custom_code/actions/init_audio_player_controller.dart';
import 'package:flutter/services.dart';

class FFDesafioAudioPlayerWidget extends StatefulWidget {
  const FFDesafioAudioPlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.audioTitle,
    required this.audioUrl,
    required this.audioArt,
    this.colorButton,
    required this.nextActionFunction,
  });

  final double? width;
  final double? height;
  final String audioTitle;
  final String audioUrl;
  final String audioArt;
  final Color? colorButton;
  final Future Function() nextActionFunction;

  @override
  FFDesafioAudioPlayerWidgetState createState() =>
      FFDesafioAudioPlayerWidgetState();
}

class FFDesafioAudioPlayerWidgetState
    extends State<FFDesafioAudioPlayerWidget> {
  late final AudioPlayerController audioPlayerController;
  bool _isDownloaded = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    audioPlayerController = globalAudioPlayerController;

    final playerModel = PlayerModel(
      id: widget.audioTitle,
      title: widget.audioTitle,
      urlAudio: widget.audioUrl,
      urlImage: widget.audioArt,
    );
    audioPlayerController.initAudioPlayer(playerModel);
    _prepareAudioDownload();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  void _prepareAudioDownload() {
    Future.microtask(() async {
      final cached = await audioPlayerController.isCached(widget.audioUrl);
      if (!mounted) {
        return;
      }
      if (cached) {
        setState(() => _isDownloaded = true);
        return;
      }
      await _downloadAudio();
    });
  }

  Future<void> _downloadAudio() async {
    if (!mounted || _isDownloading) {
      return;
    }
    setState(() => _isDownloading = true);
    try {
      await audioPlayerController.download(widget.audioUrl);
    } finally {
      final cached = await audioPlayerController.isCached(widget.audioUrl);
      if (!mounted) {
        return;
      }
      setState(() {
        _isDownloaded = cached;
        _isDownloading = false;
      });
    }
  }

  @override
  void dispose() {
    audioPlayerController.pause();
    audioPlayerController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      //color: Color(0x00F2F3F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          DownloadBanner(
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
          ),
          const SizedBox(height: 16),
          const AudioProgressBar(),
          const AudioControlButtons(),
          const SizedBox(height: 32),
          CompletedSongButton(nextActionFunction: widget.nextActionFunction),
        ],
      ),
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //RepeatButton(),
          //PreviousSongButton(),
          PlayButton(),
          //NextSongButton(),
          //ShuffleButton(),
        ],
      ),
    );
  }
}

class DownloadBanner extends StatelessWidget {
  const DownloadBanner({
    super.key,
    required this.isDownloaded,
    required this.isDownloading,
  });

  final bool isDownloaded;
  final bool isDownloading;

  @override
  Widget build(BuildContext context) {
    if (!isDownloading || isDownloaded) {
      return const SizedBox.shrink();
    }
    final theme = FlutterFlowTheme.of(context);
    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(theme.info),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Baixando...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CompletedSongButton extends StatefulWidget {
  // Mudado para StatefulWidget
  const CompletedSongButton({super.key, required this.nextActionFunction});
  final Function() nextActionFunction;

  @override
  State<CompletedSongButton> createState() => _CompletedSongButtonState();
}

class _CompletedSongButtonState extends State<CompletedSongButton> {
  bool _hasExecuted = false; // Flag para controlar a execução
  late final AudioPlayerController playerController;

  @override
  void initState() {
    super.initState();
    playerController = globalAudioPlayerController;
    // Reset the completedSongNotifier
    playerController.completedSongNotifier.value = false;
  }

  @override
  void dispose() {
    _hasExecuted = false;
    // Reset the completedSongNotifier
    playerController.completedSongNotifier.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.completedSongNotifier,
      builder: (_, isCompleted, __) {
        if (isCompleted && !_hasExecuted) {
          _hasExecuted = true; // Marca como executado
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.nextActionFunction();
          });
        }
        return const SizedBox();
      },
    );
  }
}
