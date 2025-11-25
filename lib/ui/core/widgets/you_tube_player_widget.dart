// Automatic FlutterFlow imports
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatefulWidget {
  const YouTubePlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
  });

  final double? width;
  final double? height;
  final String videoUrl;
  final bool? autoPlay;
  final bool? showControls;

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
// Extract video ID from URL using the official method
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: widget.autoPlay ?? false,
          mute: false,
          enableCaption: true,
          controlsVisibleAtStart: widget.showControls ?? true,
          hideControls: false,
          disableDragSeek: false,
          loop: false,
          forceHD: false,
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid YouTube URL';
      });
    }
  }

  void _listener() {
    if (mounted && _isPlayerReady) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
          onReady: () {
            _isPlayerReady = true;
            _controller.addListener(_listener);
          },
          onEnded: (data) {
            // Video ended
          },
          bottomActions: const [
            SizedBox(width: 14.0),
            CurrentPosition(),
            SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
              colors: ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.redAccent,
              ),
            ),
            RemainingDuration(),
            SizedBox(width: 8.0),
            FullScreenButton(),
          ],
        ),
        builder: (context, player) {
          return player;
        },
      ),
    );
  }
}
