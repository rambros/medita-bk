import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_app/models/app_settings_model.dart';
import 'package:lms_app/models/category.dart';
import 'package:lms_app/models/chart_model.dart';
import 'package:lms_app/models/course.dart';
import 'package:lms_app/models/lesson.dart';
import 'package:lms_app/models/purchase_history.dart';
import 'package:lms_app/models/review.dart';
import 'package:lms_app/models/section.dart';
import 'package:lms_app/models/subscription.dart';
import 'package:lms_app/models/tag.dart';
import 'package:lms_app/services/app_service.dart';
import 'package:lms_app/utils/toasts.dart';

import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String getUID(String collectionName) => FirebaseFirestore.instance.collection(collectionName).doc().id;

  Future updateStudentCountsOnCourse(bool isIncrement, String courseId) async {
    final DocumentReference docRef = firestore.collection('courses').doc(courseId);
    await firestore.runTransaction((transaction) {
      return transaction.get(docRef).then((DocumentSnapshot snapshot) {
        final Course course = Course.fromFirestore(snapshot);
        final int count = course.studentsCount;
        final int newCount = isIncrement ? (count + 1) : (count - 1);
        transaction.set(docRef, {'students': newCount}, SetOptions(merge: true));
      });
    }).then((value) => debugPrint('new count: $value'));
  }

  Future updateStudentCountsOnAuthor(bool isIncrement, String authorId) async {
    final DocumentReference docRef = firestore.collection('users').doc(authorId);
    await firestore.runTransaction((transaction) {
      return transaction.get(docRef).then((DocumentSnapshot snapshot) {
        final UserModel author = UserModel.fromFirebase(snapshot);
        final int count = author.authorInfo?.students ?? 0;
        final int newCount = isIncrement ? (count + 1) : (count - 1);
        final newData = {
          'author_info': {'students': newCount}
        };

        transaction.set(docRef, newData, SetOptions(merge: true));
      });
    }).then((value) => debugPrint('new count: $value'));
  }

  Future<List<Course>> getAllCourses() async {
    List<Course> data = [];
    await firestore
        .collection('courses')
        .where('status', isEqualTo: 'live')
        .orderBy('created_at', descending: true)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Course>> getLatestCourses(int limit) async {
    List<Course> data = [];
    await firestore
        .collection('courses')
        .where('status', isEqualTo: 'live')
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Course>> getRelatedCoursesByCategory(Course course, int limit) async {
    List<Course> data = [];
    await firestore
        .collection('courses')
        .where('cat_id', isEqualTo: course.categoryId)
        .where(FieldPath.documentId, isNotEqualTo: course.id)
        .where('status', isEqualTo: 'live')
        .limit(limit)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    }).catchError((e) {
      debugPrint(e);
    });
    return data;
  }

  Future<List<Course>> getFeaturedCourses() async {
    List<Course> data = [];
    await firestore.collection('courses').where('featured', isEqualTo: true).get().then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Course>> getFreeCourses() async {
    List<Course> data = [];
    await firestore
        .collection('courses')
        .where('price_status', isEqualTo: 'free')
        .where('status', isEqualTo: 'live')
        .limit(5)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Course>> getHomeCategoryCourses(String categoryId, int limit) async {
    List<Course> data = [];
    await firestore
        .collection('courses')
        .where('cat_id', isEqualTo: categoryId)
        .where('status', isEqualTo: 'live')
        .limit(5)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Course>> getCoursesByAuthorId({int limit = 3, required String authorId}) async {
    List<Course> data = [];
    await firestore
        .collection('courses')
        .where('author.id', isEqualTo: authorId)
        .where('status', isEqualTo: 'live')
        .limit(3)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Course.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Category>> getHomeCategories(int limit) async {
    List<Category> data = [];
    await firestore.collection('categories').orderBy('index', descending: false).limit(limit).get().then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Category.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Category>> getAllCategories() async {
    List<Category> data = [];
    await firestore.collection('categories').orderBy('index', descending: false).get().then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Category.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Tag>> getAllTags(int limit) async {
    List<Tag> data = [];
    await firestore.collection('tags').limit(limit).get().then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Tag.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<List<Section>> getSections(String courseId) async {
    List<Section> data = [];
    await firestore
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .orderBy('order', descending: false)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Section.fromFiresore(e)).toList();
    });
    return data;
  }

  Future<List<Lesson>> getLessons(String courseId, String sectionId) async {
    List<Lesson> data = [];
    await firestore
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .doc(sectionId)
        .collection('lessons')
        .orderBy('order', descending: false)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Lesson.fromFiresore(e)).toList();
    });
    return data;
  }

  Future<List<Review>> getLimitedReviews(String courseId, int limit) async {
    List<Review> data = [];
    await firestore
        .collection('reviews')
        .where('course_id', isEqualTo: courseId)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get()
        .then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Review.fromFirebase(e)).toList();
    });
    return data;
  }

  Future<QuerySnapshot?> getAllReviews(String courseId, DocumentSnapshot? lastDocument) async {
    QuerySnapshot? snapshot;
    final CollectionReference ref = firestore.collection('reviews');
    if (lastDocument == null) {
      await ref.orderBy('created_at', descending: false).get().then((QuerySnapshot? snapshot) {
        snapshot = snapshot;
      });
    } else {
      await ref.orderBy('created_at', descending: false).startAfterDocument(lastDocument).get().then((QuerySnapshot? snapshot) {
        snapshot = snapshot;
      });
    }

    return snapshot;
  }

  Future<List<Tag>> getCourseTags(List tagIds) async {
    final List ids = tagIds.length > 10 ? tagIds.take(10).toList() : tagIds;
    List<Tag> data = [];
    await firestore.collection('tags').where(FieldPath.documentId, whereIn: ids).get().then((QuerySnapshot? snapshot) {
      data = snapshot!.docs.map((e) => Tag.fromFirestore(e)).toList();
    });
    return data;
  }

  Future<UserModel?> getUserData() async {
    UserModel? user;
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot snap = await firestore.collection('users').doc(userId).get();
      user = UserModel.fromFirebase(snap);
    } catch (e) {
      debugPrint('error on getting user data: $e');
    }

    return user;
  }

  Future<UserModel?> getAuthorData(String authorId) async {
    final DocumentSnapshot snap = await firestore.collection('users').doc(authorId).get();
    UserModel? user = UserModel.fromFirebase(snap);
    return user;
  }

  Future<AppSettingsModel?> getAppSettingsData() async {
    AppSettingsModel? settings;
    try {
      final DocumentSnapshot snap = await firestore.collection('settings').doc('app').get();
      settings = AppSettingsModel.fromFirestore(snap);
    } catch (e) {
      debugPrint('error on getting app settings data');
    }
    return settings;
  }

  Future updateWishList(UserModel user, Course course) async {
    final DocumentReference ref = firestore.collection('users').doc(user.id);
    final newCourseId = course.id;
    final List courses = user.wishList ?? [];

    if (courses.contains(newCourseId)) {
      await ref.update({
        'wishlist': FieldValue.arrayRemove([newCourseId])
      });
    } else {
      courses.add(newCourseId);
      await ref.update({'wishlist': FieldValue.arrayUnion(courses)});
    }
  }

  Future updateEnrollment(UserModel user, Course course) async {
    final DocumentReference ref = firestore.collection('users').doc(user.id);
    final newCourseId = course.id;
    final List courses = user.enrolledCourses ?? [];

    if (courses.contains(newCourseId)) {
      await ref.update({
        'enrolled': FieldValue.arrayRemove([newCourseId])
      });
    } else {
      courses.add(newCourseId);
      await ref.update({'enrolled': FieldValue.arrayUnion(courses)});
    }
  }

  Future updateLessonMarkComplete(UserModel user, Course course, Lesson lesson) async {
    final DocumentReference ref = firestore.collection('users').doc(user.id);

    //course_id + lesson_id
    final newlessonId = '${course.id}_${lesson.id}';
    final List lessons = user.completedLessons ?? [];
    if (lessons.contains(newlessonId)) {
      await ref.update({
        'completed_lessons': FieldValue.arrayRemove([newlessonId])
      });
    } else {
      lessons.add(newlessonId);
      await ref.update({'completed_lessons': FieldValue.arrayUnion(lessons)});
    }
  }

  Future updateSubscription(UserModel user, Subscription subscription) async {
    final DocumentReference ref = firestore.collection('users').doc(user.id);
    final data = Subscription.getMap(subscription);
    await ref.update({'subscription': data});
  }

  Future savePurchaseHistory(UserModel user, PurchaseHistory history) async {
    final Map<String, dynamic> data = PurchaseHistory.getMap(history);
    final DocumentReference ref = firestore.collection('purchases').doc();
    await ref.set(data);
  }

  Future<List<UserModel>> getTopAuthors({int limit = 5}) async {
    List<UserModel> data = [];
    await firestore.collection('users').where('role', arrayContainsAny: ['author', 'admin']).limit(limit).get().then((QuerySnapshot? snapshot) {
          data = snapshot!.docs.map((e) => UserModel.fromFirebase(e)).toList();
        });
    return data;
  }

  Future<List<UserModel>> getAllAuthors() async {
    List<UserModel> data = [];
    await firestore.collection('users').where('role', arrayContainsAny: ['author', 'admin']).get().then((QuerySnapshot? snapshot) {
          data = snapshot!.docs.map((e) => UserModel.fromFirebase(e)).toList();
        });
    return data;
  }

  Future saveUserData(UserModel user) async {
    try {
      final data = UserModel.getMap(user);
      await firestore.collection('users').doc(user.id).set(data);
    } catch (e) {
      debugPrint('error on saving user data: $e');
    }
  }

  Future updateUserProfile(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).update({'name': user.name, 'image_url': user.imageUrl});
    } catch (e) {
      debugPrint('Error on updating user profile: $e');
      openToast('Failed to update data');
    }
  }

  Future<bool> isUserExists(String userId) async {
    DocumentSnapshot snap = await firestore.collection('users').doc(userId).get();
    if (snap.exists) {
      debugPrint('User Exists');
      return true;
    } else {
      debugPrint('New User');
      return false;
    }
  }

  //for wishlish and my courses
  Future<QuerySnapshot> getCoursesQuery(chunk) {
    Query itemsQuery = FirebaseFirestore.instance.collection('courses').where(FieldPath.documentId, whereIn: chunk);
    return itemsQuery.get();
  }

  Future saveReview(String courseId, Review review) async {
    final Map<String, dynamic> data = Review.getMap(review);
    final DocumentReference ref = firestore.collection('reviews').doc(review.id);
    await ref.set(data, SetOptions(merge: true));
  }

  Future<Review?> getUserReview(String courseId, String userId) async {
    Review? review;
    final QuerySnapshot snap =
        await firestore.collection('reviews').where('course_id', isEqualTo: courseId).where('user.id', isEqualTo: userId).limit(1).get();
    if (snap.size != 0) {
      review = Review.fromFirebase(snap.docs.first);
    }
    return review;
  }

  Future<QuerySnapshot> getCoursesSnapshotByCategory({required String categoryId, DocumentSnapshot? lastDocument}) async {
    QuerySnapshot snapshot;
    if (lastDocument == null) {
      snapshot = await firestore.collection('courses').where('cat_id', isEqualTo: categoryId).where('status', isEqualTo: 'live').limit(10).get();
    } else {
      snapshot = await firestore
          .collection('courses')
          .where('cat_id', isEqualTo: categoryId)
          .where('status', isEqualTo: 'live')
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return snapshot;
  }

  Future<QuerySnapshot> getCoursesSnapshotByLatest({DocumentSnapshot? lastDocument}) async {
    QuerySnapshot snapshot;
    if (lastDocument == null) {
      snapshot = await firestore.collection('courses').where('status', isEqualTo: 'live').orderBy('created_at', descending: true).limit(10).get();
    } else {
      snapshot = await firestore
          .collection('courses')
          .where('status', isEqualTo: 'live')
          .orderBy('created_at', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return snapshot;
  }

  Future<QuerySnapshot> getCoursesSnapshotByFreeCourses({DocumentSnapshot? lastDocument}) async {
    QuerySnapshot snapshot;
    if (lastDocument == null) {
      snapshot = await firestore.collection('courses').where('price_status', isEqualTo: 'free').where('status', isEqualTo: 'live').limit(10).get();
    } else {
      snapshot = await firestore
          .collection('courses')
          .where('price_status', isEqualTo: 'free')
          .where('status', isEqualTo: 'live')
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return snapshot;
  }

  Future<QuerySnapshot> getCoursesSnapshotByTag({required String tagId, DocumentSnapshot? lastDocument}) async {
    QuerySnapshot snapshot;
    if (lastDocument == null) {
      snapshot = await firestore.collection('courses').where('tag_ids', arrayContains: tagId).where('status', isEqualTo: 'live').limit(10).get();
    } else {
      snapshot = await firestore
          .collection('courses')
          .where('tag_ids', arrayContains: tagId)
          .where('status', isEqualTo: 'live')
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return snapshot;
  }

  Future<QuerySnapshot> getCoursesSnapshotByAuhtor({required String authorId, DocumentSnapshot? lastDocument}) async {
    QuerySnapshot snapshot;
    if (lastDocument == null) {
      snapshot = await firestore.collection('courses').where('author.id', isEqualTo: authorId).where('status', isEqualTo: 'live').limit(10).get();
    } else {
      snapshot = await firestore
          .collection('courses')
          .where('author.id', isEqualTo: authorId)
          .where('status', isEqualTo: 'live')
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return snapshot;
  }

  Future<QuerySnapshot> getReviewsSnapshot({required String courseId, DocumentSnapshot? lastDocument}) async {
    QuerySnapshot snapshot;
    if (lastDocument == null) {
      snapshot =
          await firestore.collection('reviews').where('course_id', isEqualTo: courseId).orderBy('created_at', descending: true).limit(10).get();
    } else {
      snapshot = await firestore
          .collection('reviews')
          .where('course_id', isEqualTo: courseId)
          .orderBy('created_at', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return snapshot;
  }

  Future<String?> uploadImageToHosting(XFile imageFile) async {
    String? imageUrl;
    final File image = File(imageFile.path);
    final String imageName = imageFile.name;
    final Reference storageReference = FirebaseStorage.instance.ref().child('user_images/$imageName');
    final UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() async {
      imageUrl = await storageReference.getDownloadURL();
    });
    return imageUrl;
  }

  Future<int> getAuthorReviewsCount(String auhtorId) async {
    final CollectionReference collectionReference = firestore.collection('reviews');
    final AggregateQuerySnapshot snap = await collectionReference.where('course_author_id', isEqualTo: auhtorId).count().get();
    int count = snap.count ?? 0;
    return count;
  }

  Future<int> getAuthorCourseCount(String auhtorId) async {
    final CollectionReference collectionReference = firestore.collection('courses');
    final AggregateQuerySnapshot snap =
        await collectionReference.where('author.id', isEqualTo: auhtorId).where('status', isEqualTo: 'live').count().get();
    int count = snap.count ?? 0;
    return count;
  }

  Future deleteUserDatafromDatabase(String userId) async {
    await firestore.collection('users').doc(userId).delete();
  }

  Future<double> getCourseAverageRating(String courseId) async {
    double averageRating = 0.0;
    final CollectionReference collectionReference = firestore.collection('reviews');
    final QuerySnapshot snapshot = await collectionReference.where('course_id', isEqualTo: courseId).get();
    final List<Review> reviews = snapshot.docs.map((e) => Review.fromFirebase(e)).toList();

    if (reviews.isEmpty) {
      averageRating = 0.0;
    } else if (reviews.length <= 1) {
      averageRating = reviews.first.rating;
    } else {
      final int totalRatingCount = reviews.length;
      double totalRatingValue = 0;
      reviews.forEach((element) => totalRatingValue = totalRatingValue + element.rating);
      averageRating = totalRatingValue / totalRatingCount;
    }

    return averageRating;
  }

  Future saveCourseRating(String courseId, double rating) async {
    final CollectionReference collectionReference = firestore.collection('courses');
    await collectionReference.doc(courseId).update({'rating': rating}).catchError((error) => openToast('Failed to update course rating'));
  }

  Future updateUserStats() async {
    final String id = AppService.getTodaysID();
    final DocumentReference docRef = firestore.collection('user_stats').doc(id);
    await firestore.runTransaction((transaction) {
      return transaction.get(docRef).then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          final ChartModel chartModel = ChartModel.fromFirestore(snapshot);
          final newChartModel = ChartModel(id: chartModel.id, count: chartModel.count + 1, timestamp: chartModel.timestamp);
          final Map<String, dynamic> data = ChartModel.getMap(newChartModel);
          transaction.set(docRef, data, SetOptions(merge: true));
        } else {
          final newChartModel = ChartModel(id: id, count: 1, timestamp: DateTime.now().toUtc());
          final Map<String, dynamic> data = ChartModel.getMap(newChartModel);
          transaction.set(docRef, data, SetOptions(merge: true));
        }
      });
    });
  }

  Future updatePurchaseStats() async {
    final String id = AppService.getTodaysID();
    final DocumentReference docRef = firestore.collection('purchase_stats').doc(id);
    await firestore.runTransaction((transaction) {
      return transaction.get(docRef).then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          final ChartModel chartModel = ChartModel.fromFirestore(snapshot);
          final newChartModel = ChartModel(id: chartModel.id, count: chartModel.count + 1, timestamp: chartModel.timestamp);
          final Map<String, dynamic> data = ChartModel.getMap(newChartModel);
          transaction.set(docRef, data, SetOptions(merge: true));
        } else {
          final newChartModel = ChartModel(id: id, count: 1, timestamp: DateTime.now().toUtc());
          final Map<String, dynamic> data = ChartModel.getMap(newChartModel);
          transaction.set(docRef, data, SetOptions(merge: true));
        }
      });
    });
  }

  Future updateUserReviewList(UserModel user, Course course) async {
    final DocumentReference ref = firestore.collection('users').doc(user.id);
    final newCourseId = course.id;
    final List reviews = user.reviews ?? [];
    reviews.add(newCourseId);
    await ref.update({'reviews': FieldValue.arrayUnion(reviews)});
  }
}
