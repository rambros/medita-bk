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
      print('EntrevistasListViewModel: Loading channel info...');
      channel = await _repository.getCanalBrahmaKumaris();
      print('EntrevistasListViewModel: Channel loaded - ${channel?.title ?? "null"}');
    } catch (error) {
      print('EntrevistasListViewModel: Error loading channel - $error');
    } finally {
      isLoadingChannel = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPage(String? pageKey) async {
    try {
      print('EntrevistasListViewModel: Fetching page with key: $pageKey');
      final newItems = await _repository.getVideosEntrevistas(pageToken: pageKey);
      print('EntrevistasListViewModel: Received ${newItems.videos.length} videos, total: ${newItems.totalResults}');

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
      print('EntrevistasListViewModel: Error fetching page - $error');
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
