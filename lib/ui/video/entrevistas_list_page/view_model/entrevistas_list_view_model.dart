import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '/data/repositories/video_repository.dart';
import '/domain/models/video/video_model.dart';

class EntrevistasListViewModel extends ChangeNotifier {
  final VideoRepository _repository;
  final PagingController<String?, Video> pagingController = PagingController(firstPageKey: null);

  Channel? channel;
  int totalVideos = 0;
  bool isLoadingChannel = true;

  EntrevistasListViewModel(this._repository) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _loadChannelInfo();
  }

  Future<void> _loadChannelInfo() async {
    isLoadingChannel = true;
    notifyListeners();
    try {
      channel = await _repository.getCanalBrahmaKumaris();
    } catch (error) {
      // Handle error
    } finally {
      isLoadingChannel = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPage(String? pageKey) async {
    try {
      final newItems = await _repository.getVideosEntrevistas(pageToken: pageKey);

      if (pageKey == null) {
        totalVideos = newItems.totalResults;
        notifyListeners();
      }

      final isLastPage = newItems.nextPageToken == null;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.videos);
      } else {
        pagingController.appendPage(newItems.videos, newItems.nextPageToken);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
