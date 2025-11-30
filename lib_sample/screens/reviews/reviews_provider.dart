import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/review.dart';
import '../../services/firebase_service.dart';

final allReviewsProvider = StateNotifierProvider.autoDispose<ReviewData, List<Review>>((ref) => ReviewData());

final hasReviewsProvider = StateProvider.autoDispose<bool>((ref) => false);

final isReviewsLoadingProvider = StateProvider.autoDispose<bool>((ref) => true);

class ReviewData extends StateNotifier<List<Review>> {
  ReviewData() : super([]);

  DocumentSnapshot? lastDocument;

  getData(String courseId, WidgetRef ref) async {
    if (lastDocument == null) {
      await FirebaseService().getReviewsSnapshot(courseId: courseId).then((QuerySnapshot snapshot) {
        state = snapshot.docs.map((e) => Review.fromFirebase(e)).toList();
        lastDocument = snapshot.docs.last;
        ref.read(isReviewsLoadingProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    } else {
      ref.read(hasReviewsProvider.notifier).update((state) => true);
      await FirebaseService().getReviewsSnapshot(courseId: courseId, lastDocument: lastDocument).then((QuerySnapshot? snapshot) {
        state.addAll(snapshot!.docs.map((e) => Review.fromFirebase(e)).toList());
        lastDocument = snapshot.docs.last;
        ref.read(hasReviewsProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    }
  }

  _handleError(ref, String error) {
    ref.read(isReviewsLoadingProvider.notifier).update((state) => false);
    ref.read(hasReviewsProvider.notifier).update((state) => false);
    debugPrint(error);
  }
}