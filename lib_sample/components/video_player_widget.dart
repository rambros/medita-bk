import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last_pod_player/last_pod_player.dart';
import 'package:lms_app/services/app_service.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  final String videoUrl;
  final String? thumbnailUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final PodPlayerController controller;

  @override
  void initState() {
    final String videoType = AppService.getVideoType(widget.videoUrl);
    controller = PodPlayerController(
        playVideoFrom: videoType == 'network'
            ? PlayVideoFrom.network(widget.videoUrl)
            : videoType == 'vimeo'
                ? PlayVideoFrom.vimeo(widget.videoUrl)
                : PlayVideoFrom.youtube(widget.videoUrl),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ))
      ..initialise();
    super.initState();
  }


  @override
  void dispose() {

    // temporary fix to solve status bar issue on iOS
    if (Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
      controller: controller,
      alwaysShowProgressBar: true,
      videoThumbnail: widget.thumbnailUrl == null
          ? null
          : DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                widget.thumbnailUrl.toString(),
              ),
            ),
    );
  }
}
