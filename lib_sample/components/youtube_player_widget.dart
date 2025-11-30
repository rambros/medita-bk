import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.body,
  });

  final String videoUrl;
  final String? thumbnailUrl;
  final Widget? body;

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        // thumbnail: CustomCacheImage(imageUrl: widget.thumbnailUrl, radius: 0),
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                FeatherIcons.chevronLeft,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  player,
                  widget.body ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
