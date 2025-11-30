import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/components/html_body.dart';
import 'package:lms_app/components/mark_complete_button.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';

import '../services/content_security_service.dart';

class ArticleLesson extends ConsumerStatefulWidget {
  const ArticleLesson({super.key, required this.lesson, required this.course});

  final Course course;
  final Lesson lesson;

  @override
  ConsumerState<ArticleLesson> createState() => _ArticleLessonState();
}

class _ArticleLessonState extends ConsumerState<ArticleLesson> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.name),
        titleSpacing: 0,
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      bottomNavigationBar: MarkCompleteButton(course: widget.course, lesson: widget.lesson),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HtmlBody(description: widget.lesson.description.toString()),
      ),
    );
  }
}
