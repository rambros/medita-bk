import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/utils/cache_image_filter.dart';
import '../../models/course.dart';
import '../../utils/custom_cached_image.dart';
import '../../utils/next_screen.dart';
import '../video_player_screen.dart';

class PreviewBox extends StatelessWidget {
  const PreviewBox({
    super.key,
    required this.course,
    required this.heroTag,
  });
  final Course course;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final bool hasVideoPreview = course.videoUrl != null && course.videoUrl!.isNotEmpty ? true : false;
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () {
            if (hasVideoPreview) {
              NextScreen.iOS(context, VideoPlayerScreen(videoUrl: course.videoUrl!));
            }
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            width: double.infinity,
            child: HeroMode(
              enabled: heroTag != null,
              child: Hero(
                tag: heroTag ?? '',
                child: hasVideoPreview
                    ? CustomCacheImageWithDarkFilterFull(imageUrl: course.thumbnailUrl, radius: 5)
                    : CustomCacheImage(imageUrl: course.thumbnailUrl, radius: 5),
              ),
            ),
          ),
        ),
        Visibility(
          visible: hasVideoPreview,
          child: const Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              child: Icon(
                CupertinoIcons.play,
                size: 45,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
