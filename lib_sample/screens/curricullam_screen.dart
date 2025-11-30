import 'package:flutter/material.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/screens/course_details.dart/sections.dart';

class CurriculamScreen extends StatelessWidget {
  const CurriculamScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: false,
          titleSpacing: 0,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            course.name,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Sections(
                course: course,
                isInitialSectionOpen: false,
              )
            ],
          ),
        ));
  }
}
