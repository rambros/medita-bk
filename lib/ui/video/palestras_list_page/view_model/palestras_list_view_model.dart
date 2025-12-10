import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medita_b_k/data/repositories/video_repository.dart';
import 'package:medita_b_k/domain/models/video/video_model.dart';
import 'package:medita_b_k/core/utils/logger.dart';

class PalestrasListViewModel extends ChangeNotifier {
  final VideoRepository _repository;
  late final PagingController<int, Video> pagingController;
  String? _nextPageToken = '';
  bool _hasNextPage = true;
  int _nextPageKey = 0;

  Channel? channel;
  int totalVideos = 0;
  bool isLoadingChannel = true;

  PalestrasListViewModel(this._repository) {
    pagingController = PagingController<int, Video>(
      getNextPageKey: (_) => _hasNextPage ? _nextPageKey : null,
      fetchPage: _fetchPage,
    );
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

  Future<List<Video>> _fetchPage(int pageKey) async {
    try {
      logDebug('PalestrasListViewModel: Fetching page with pageKey: $pageKey');
      final pageToken = (_nextPageToken ?? '').isEmpty ? null : _nextPageToken;
      final newItems = await _repository.getVideosPalestras(pageToken: pageToken);
      logDebug('PalestrasListViewModel: Received ${newItems.videos.length} videos');
      logDebug('PalestrasListViewModel: Next page token: ${newItems.nextPageToken}');
      final isLastPage = newItems.nextPageToken == null;
      _nextPageToken = newItems.nextPageToken ?? '';
      _nextPageKey++;
      if (isLastPage) {
        _hasNextPage = false;
        pagingController.value = pagingController.value.copyWith(hasNextPage: false);
      }
      return newItems.videos;
    } catch (error, stackTrace) {
      logDebug('PalestrasListViewModel: Error fetching page: $error', stackTrace: stackTrace);
      rethrow;
    }
  }

  void refresh() {
    _nextPageToken = '';
    _hasNextPage = true;
    _nextPageKey = 0;
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
