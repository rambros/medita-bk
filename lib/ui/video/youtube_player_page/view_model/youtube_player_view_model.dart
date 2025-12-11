import 'package:flutter/material.dart';
import 'package:medita_bk/data/repositories/video_repository.dart';

class YoutubePlayerViewModel extends ChangeNotifier {
  // ignore: unused_field
  final VideoRepository _repository;

  YoutubePlayerViewModel(this._repository);
}
