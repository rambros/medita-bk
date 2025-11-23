import 'package:flutter/material.dart';
import '/data/repositories/video_repository.dart';

class VideoHomeViewModel extends ChangeNotifier {
  // ignore: unused_field
  final VideoRepository _repository;

  VideoHomeViewModel(this._repository);
}
