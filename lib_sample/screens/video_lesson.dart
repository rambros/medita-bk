import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/youtube_player_widget.dart';
import 'package:lms_app/services/app_service.dart';
import 'package:lms_app/services/content_security_service.dart';
import '../components/mark_complete_button.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import 'video_player_screen.dart';

class VideoLesson extends ConsumerStatefulWidget {
  const VideoLesson({super.key, required this.course, required this.lesson});

  final Course course;
  final Lesson lesson;

  @override
  ConsumerState<VideoLesson> createState() => _VideoLessonState();
}

class _VideoLessonState extends ConsumerState<VideoLesson> {
  @override
  void initState() {
    ContentSecurityService().initContentSecurity(ref);
    super.initState();
  }

  @override
  void dispose() {
    ContentSecurityService().disposeContentSecurity();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String videoType = AppService.getVideoType(widget.lesson.videoUrl.toString());
    if (videoType == 'youtube') {
      return YoutubePlayerWidget(
        videoUrl: widget.lesson.videoUrl.toString(),
        body: _button(),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          VideoPlayerScreen(videoUrl: widget.lesson.videoUrl.toString()),
          _button(),
        ],
      ),
    );
  }

  Widget _button() {
    return Align(
      alignment: Alignment.bottomCenter,
      // Visible after 1 sec for video loading time
      child: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MarkCompleteButton(course: widget.course, lesson: widget.lesson);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
