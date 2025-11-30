import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import 'package:lms_app/models/user_model.dart';

mixin CourseMixin {

  bool isLessonCompleted(Lesson lesson, UserModel? user) {
    if (user != null && user.completedLessons!.isNotEmpty && user.completedLessons!.any((element) => element.toString().contains(lesson.id))) {
      return true;
    } else {
      return false;
    }
  }

  static String enrollButtonText(Course course, UserModel? user) {
    if (user == null || !user.enrolledCourses!.contains(course.id)) {
      return 'enroll-now';
    } else {
      List validIds = user.completedLessons!.where((element) => element.toString().contains(course.id)).toList();
      final double courseProgess = validIds.isEmpty ? 0 : (validIds.length / course.lessonsCount);
      if (courseProgess == 0) {
        return 'start-course';
      } else if (courseProgess > 0 && courseProgess < 1) {
        return 'continue-course';
      } else {
        return 'restart-course';
      }
    }
  }
}
