import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medita_b_k/data/repositories/video_repository.dart';
import 'package:medita_b_k/domain/models/video/video_model.dart';
import 'package:medita_b_k/core/utils/logger.dart';

class EntrevistasListViewModel extends ChangeNotifier {
  final VideoRepository _repository;
  late final PagingController<int, Video> pagingController;
  String? _nextPageToken = '';
  bool _hasNextPage = true;
  int _nextPageKey = 0;

  Channel? channel;
  int totalVideos = 0;
  bool isLoadingChannel = true;

  EntrevistasListViewModel(this._repository) {
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
      logDebug('EntrevistasListViewModel: Loading channel info...');
      channel = await _repository.getCanalBrahmaKumaris();
      logDebug('EntrevistasListViewModel: Channel loaded - ${channel?.title ?? "null"}');
    } catch (error) {
      logDebug('EntrevistasListViewModel: Error loading channel - $error');
    } finally {
      isLoadingChannel = false;
      notifyListeners();
    }
  }

  Future<List<Video>> _fetchPage(int pageKey) async {
    try {
      logDebug('EntrevistasListViewModel: Fetching page with key: $pageKey');
      final pageToken = (_nextPageToken ?? '').isEmpty ? null : _nextPageToken;
      final newItems = await _repository.getVideosEntrevistas(pageToken: pageToken);
      logDebug(
          'EntrevistasListViewModel: Received ${newItems.videos.length} videos, total: ${newItems.totalResults}');

      if (pageKey == 0) {
        totalVideos = newItems.totalResults;
        notifyListeners();
      }

      _nextPageToken = newItems.nextPageToken ?? '';
      final isLastPage = newItems.nextPageToken == null;
      _nextPageKey++;
      if (isLastPage) {
        _hasNextPage = false;
        pagingController.value = pagingController.value.copyWith(hasNextPage: false);
      }
      return newItems.videos;
    } catch (error) {
      logDebug('EntrevistasListViewModel: Error fetching page - $error');
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
