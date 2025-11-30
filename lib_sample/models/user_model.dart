import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms_app/models/author_info.dart';
import 'package:lms_app/models/subscription.dart';

class UserModel {
  final String id, email, name;
  DateTime? createdAt;
  DateTime? updatedAt;
  final String? imageUrl;
  List? role;
  List? enrolledCourses;
  List? wishList;
  bool? isDisbaled;
  AuthorInfo? authorInfo;
  Subscription? subscription;
  List? completedLessons;
  String? platform;
  List? reviews;

  UserModel({
    required this.id,
    required this.email,
    this.imageUrl,
    required this.name,
    this.role,
    this.wishList,
    this.enrolledCourses,
    this.isDisbaled,
    this.createdAt,
    this.updatedAt,
    this.authorInfo,
    this.subscription,
    this.completedLessons,
    this.platform,
    this.reviews,
  });

  factory UserModel.fromFirebase(DocumentSnapshot snap) {
    Map d = snap.data() as Map<String, dynamic>;
    return UserModel(
      id: snap.id,
      email: d['email'],
      imageUrl: d['image_url'],
      name: d['name'],
      role: d['role'] ?? [],
      isDisbaled: d['disabled'] ?? false,
      createdAt: (d['created_at'] as Timestamp).toDate(),
      updatedAt: d['updated_at'] == null ? null : (d['updated_at'] as Timestamp).toDate(),
      authorInfo: d['author_info'] == null ? null : AuthorInfo.fromMap(d['author_info']),
      enrolledCourses: d['enrolled'] ?? [],
      wishList: d['wishlist'] ?? [],
      subscription: d['subscription'] == null ? null : Subscription.fromFirestore(d['subscription']),
      completedLessons: d['completed_lessons'] ?? [],
      platform: d['platform'],
      reviews: d['reviews'] ?? [],
    );
  }

  static Map<String, dynamic> getMap(UserModel user) {
    return {
      'email': user.email,
      'name': user.name,
      'image_url': user.imageUrl,
      'created_at': user.createdAt,
      'platform': user.platform,
    };
  }
}
