import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '/backend/backend.dart';
import '/data/repositories/user_repository.dart';

class AboutAuthorsViewModel extends ChangeNotifier {
  final UserRepository _repository;
  final PagingController<DocumentSnapshot?, UsersRecord> pagingController;

  bool _isDisposed = false;

  AboutAuthorsViewModel({required UserRepository repository})
      : _repository = repository,
        pagingController = PagingController(firstPageKey: null) {
    pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(DocumentSnapshot? pageKey) async {
    if (_isDisposed) return;

    try {
      final authors = await _repository.getAuthors(
        pageSize: 25,
        startAfter: pageKey,
      );

      if (_isDisposed) return;

      final isLastPage = authors.length < 25;
      if (isLastPage) {
        pagingController.appendLastPage(authors);
      } else {
        // Get the last document as the next page key
        final lastDoc = authors.last;
        final nextPageKey = await FirebaseFirestore.instance.collection('users').doc(lastDoc.reference.id).get();
        pagingController.appendPage(authors, nextPageKey);
      }
    } catch (error) {
      if (_isDisposed) return;
      print('Error loading authors page: $error');
      pagingController.error = error;
    }
  }

  void refresh() {
    if (!_isDisposed) {
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
