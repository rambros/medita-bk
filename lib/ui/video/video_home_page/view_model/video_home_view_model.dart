import 'package:flutter/material.dart';
import 'package:medita_b_k/data/repositories/video_repository.dart';

class VideoHomeViewModel extends ChangeNotifier {
  // ignore: unused_field
  final VideoRepository _repository;

  VideoHomeViewModel(this._repository);
}
