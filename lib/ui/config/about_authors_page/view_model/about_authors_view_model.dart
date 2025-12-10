import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medita_b_k/data/models/firebase/user_model.dart';
import 'package:medita_b_k/data/repositories/user_repository.dart';
import 'package:medita_b_k/core/utils/logger.dart';

class AboutAuthorsViewModel extends ChangeNotifier {
  final UserRepository _repository;
  late final PagingController<int, UserModel> pagingController;

  bool _isDisposed = false;
  DocumentSnapshot? _lastDocument;
  bool _hasNextPage = true;
  int _nextPageKey = 0;
  static const _pageSize = 25;

  AboutAuthorsViewModel({required UserRepository repository})
      : _repository = repository {
    pagingController = PagingController<int, UserModel>(
      getNextPageKey: (_) => _hasNextPage ? _nextPageKey : null,
      fetchPage: _fetchPage,
    );
  }

  Future<List<UserModel>> _fetchPage(int pageKey) async {
    if (_isDisposed) return [];

    try {
      final authors = await _repository.getAuthors(
        pageSize: _pageSize,
        startAfter: _lastDocument,
      );

      if (_isDisposed) return [];

      final isLastPage = authors.length < _pageSize;
      if (!isLastPage && authors.isNotEmpty) {
        final lastAuthor = authors.last;
        _lastDocument = await FirebaseFirestore.instance.collection('users').doc(lastAuthor.uid).get();
      } else {
        _hasNextPage = false;
      }
      _nextPageKey++;
      if (!_hasNextPage) {
        pagingController.value = pagingController.value.copyWith(hasNextPage: false);
      }
      return authors;
    } catch (error) {
      logDebug('Error loading authors page: $error');
      rethrow;
    }
  }

  void refresh() {
    if (!_isDisposed) {
      _hasNextPage = true;
      _nextPageKey = 0;
      _lastDocument = null;
      pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    pagingController.dispose();
    super.dispose();
  }
}
