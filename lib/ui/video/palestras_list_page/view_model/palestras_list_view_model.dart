import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '/data/repositories/video_repository.dart';
import '/domain/models/video/video_model.dart';

class PalestrasListViewModel extends ChangeNotifier {
  final VideoRepository _repository;
  final PagingController<String?, Video> pagingController = PagingController(firstPageKey: null);

  Channel? channel;
  int totalVideos = 0;
  bool isLoadingChannel = true;

  PalestrasListViewModel(this._repository) {
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
      totalVideos = await _repository.getTotalVideosPalestras();
    } catch (error) {
      // Handle error
    } finally {
      isLoadingChannel = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPage(String? pageKey) async {
    try {
      print('PalestrasListViewModel: Fetching page with pageKey: $pageKey');
      final newItems = await _repository.getVideosPalestras(pageToken: pageKey);
      print('PalestrasListViewModel: Received ${newItems.videos.length} videos');
      print('PalestrasListViewModel: Next page token: ${newItems.nextPageToken}');
      final isLastPage = newItems.nextPageToken == null;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.videos);
      } else {
        pagingController.appendPage(newItems.videos, newItems.nextPageToken);
      }
    } catch (error, stackTrace) {
      print('PalestrasListViewModel: Error fetching page: $error');
      print('PalestrasListViewModel: Stack trace: $stackTrace');
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
