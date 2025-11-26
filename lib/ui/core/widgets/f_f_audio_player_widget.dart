// Automatic FlutterFlow imports
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom widgets

import '/core/controllers/index.dart';
import 'audio_player_controls.dart';
import 'package:flutter/services.dart';

class FFAudioPlayerWidget extends StatefulWidget {
  const FFAudioPlayerWidget({
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
  FFAudioPlayerWidgetState createState() => FFAudioPlayerWidgetState();
}

class FFAudioPlayerWidgetState extends State<FFAudioPlayerWidget> {
  AudioPlayerController audioPlayerController = globalAudioPlayerController;
  bool _isDownloaded = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  @override
  void didUpdateWidget(FFAudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioUrl != oldWidget.audioUrl) {
      _initPlayer();
    }
  }

  void _initPlayer() {
    if (widget.audioUrl.isEmpty) return;

    final playerModel = PlayerModel(
      id: widget.audioTitle,
      title: widget.audioTitle,
      urlAudio: widget.audioUrl,
      urlImage: widget.audioArt,
    );
    audioPlayerController.initAudioPlayer(playerModel);
    _prepareAudioDownload();
  }

  void _prepareAudioDownload() {
    if (widget.audioUrl.isEmpty) return;

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
    if (!mounted || _isDownloading || widget.audioUrl.isEmpty) {
      return;
    }
    setState(() => _isDownloading = true);
    try {
      await audioPlayerController.download(widget.audioUrl);
    } catch (e) {
      debugPrint('Error downloading audio: $e');
    } finally {
      if (mounted) {
        final cached = await audioPlayerController.isCached(widget.audioUrl);
        if (mounted) {
          setState(() {
            _isDownloaded = cached;
            _isDownloading = false;
          });
        }
      }
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
          const SizedBox(
            height: 10,
          ),
          DownloadBanner(
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
          ),
          const SizedBox(height: 16),
          const AudioProgressBar(),
          const AudioControlButtons(),
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
