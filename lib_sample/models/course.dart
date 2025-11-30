import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms_app/models/author.dart';
import 'package:lms_app/models/course_meta.dart';

class Course {
  final String name, id, thumbnailUrl, status, priceStatus;
  DateTime createdAt;
  DateTime? updatedAt;
  List? tagIDs;
  String? videoUrl;
  String? categoryId;
  final Author author;
  final int studentsCount;
  final double rating;
  final CourseMeta courseMeta;
  final int lessonsCount;
  bool? isFeatured;

  Course({
    required this.name,
    required this.id,
    required this.thumbnailUrl,
    this.videoUrl,
    required this.createdAt,
    this.updatedAt,
    this.tagIDs,
    required this.categoryId,
    required this.status,
    required this.author,
    required this.studentsCount,
    required this.rating,
    required this.priceStatus,
    required this.courseMeta,
    required this.lessonsCount,
    this.isFeatured,
  });

  factory Course.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<String, dynamic>;
    return Course(
      id: snap.id,
      name: d['name'],
      thumbnailUrl: d['image_url'],
      createdAt: (d['created_at'] as Timestamp).toDate(),
      updatedAt: d['updated_at'] == null ? null : (d['updated_at'] as Timestamp).toDate(),
      videoUrl: d['video_url'],
      tagIDs: d['tag_ids'] ?? [],
      categoryId: d['cat_id'],
      status: d['status'],
      author: Author.fromMap(d['author']),
      priceStatus: d['price_status'],
      rating: d['rating'].toDouble(),
      studentsCount: d['students'],
      courseMeta: CourseMeta.fromMap(d['meta']),
      isFeatured: d['featured'] ?? false,
      lessonsCount: d['lessons_count'],
    );
  }
}
