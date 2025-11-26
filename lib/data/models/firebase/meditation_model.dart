import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/core/structs/comment_struct.dart';

/// Meditation data model for Firebase Firestore
///
/// This is a pure Dart model (DTO) that represents meditation data
/// without any FlutterFlow dependencies.
class MeditationModel extends Equatable {
  final String id; // Document ID
  final String documentId;
  final String title;
  final String authorId;
  final String authorName;
  final String authorText;
  final String authorMusic;
  final String date;
  final bool featured;
  final String imageFileName;
  final String audioFileName;
  final String audioDuration;
  final String callText;
  final String detailsText;
  final int numPlayed;
  final int numLiked;
  final List<String> category;
  final List<String> titleIndex;
  final List<CommentStruct> comments;
  final String imageUrl;
  final String audioUrl;
  final DocumentReference? reference;

  const MeditationModel({
    required this.id,
    this.documentId = '',
    this.title = '',
    this.authorId = '',
    this.authorName = '',
    this.authorText = '',
    this.authorMusic = '',
    this.date = '',
    this.featured = false,
    this.imageFileName = '',
    this.audioFileName = '',
    this.audioDuration = '',
    this.callText = '',
    this.detailsText = '',
    this.numPlayed = 0,
    this.numLiked = 0,
    this.category = const [],
    this.titleIndex = const [],
    this.comments = const [],
    this.imageUrl = '',
    this.audioUrl = '',
    this.reference,
  });

  // ========== FIRESTORE SERIALIZATION ==========

  /// Create MeditationModel from Firestore DocumentSnapshot
  factory MeditationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return MeditationModel(
      id: doc.id,
      documentId: data['documentId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      authorText: data['authorText'] as String? ?? '',
      authorMusic: data['authorMusic'] as String? ?? '',
      date: data['date'] as String? ?? '',
      featured: data['featured'] as bool? ?? false,
      imageFileName: data['imageFileName'] as String? ?? '',
      audioFileName: data['audioFileName'] as String? ?? '',
      audioDuration: data['audioDuration'] as String? ?? '',
      callText: data['callText'] as String? ?? '',
      detailsText: data['detailsText'] as String? ?? '',
      numPlayed: _getInt(data['numPlayed']),
      numLiked: _getInt(data['numLiked']),
      category: _getStringList(data['category']),
      titleIndex: _getStringList(data['titleIndex']),
      comments: _getCommentList(data['comments']),
      imageUrl: data['imageUrl'] as String? ?? '',
      audioUrl: data['audioUrl'] as String? ?? '',
      reference: data['id'] as DocumentReference?,
    );
  }

  /// Convert MeditationModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'documentId': documentId,
      'title': title,
      'authorId': authorId,
      'authorName': authorName,
      'authorText': authorText,
      'authorMusic': authorMusic,
      'date': date,
      'featured': featured,
      'imageFileName': imageFileName,
      'audioFileName': audioFileName,
      'audioDuration': audioDuration,
      'callText': callText,
      'detailsText': detailsText,
      'numPlayed': numPlayed,
      'numLiked': numLiked,
      'category': category,
      'titleIndex': titleIndex,
      'comments': comments.map((c) => c.toMap()).toList(),
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      if (reference != null) 'id': reference,
    };
  }

  // ========== JSON SERIALIZATION (for local storage, API, etc.) ==========

  /// Create MeditationModel from JSON
  factory MeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationModel(
      id: json['id'] as String? ?? '',
      documentId: json['documentId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorText: json['authorText'] as String? ?? '',
      authorMusic: json['authorMusic'] as String? ?? '',
      date: json['date'] as String? ?? '',
      featured: json['featured'] as bool? ?? false,
      imageFileName: json['imageFileName'] as String? ?? '',
      audioFileName: json['audioFileName'] as String? ?? '',
      audioDuration: json['audioDuration'] as String? ?? '',
      callText: json['callText'] as String? ?? '',
      detailsText: json['detailsText'] as String? ?? '',
      numPlayed: json['numPlayed'] as int? ?? 0,
      numLiked: json['numLiked'] as int? ?? 0,
      category: _getStringList(json['category']),
      titleIndex: _getStringList(json['titleIndex']),
      comments: _getCommentList(json['comments']),
      imageUrl: json['imageUrl'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
    );
  }

  /// Convert MeditationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'title': title,
      'authorId': authorId,
      'authorName': authorName,
      'authorText': authorText,
      'authorMusic': authorMusic,
      'date': date,
      'featured': featured,
      'imageFileName': imageFileName,
      'audioFileName': audioFileName,
      'audioDuration': audioDuration,
      'callText': callText,
      'detailsText': detailsText,
      'numPlayed': numPlayed,
      'numLiked': numLiked,
      'category': category,
      'titleIndex': titleIndex,
      'comments': comments.map((c) => c.toMap()).toList(),
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }

  // ========== HELPER METHODS ==========

  static int _getInt(dynamic data) {
    if (data == null) return 0;
    if (data is int) return data;
    if (data is String) return int.tryParse(data) ?? 0;
    return 0;
  }

  static List<String> _getStringList(dynamic data) {
    if (data == null) return const [];
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    return const [];
  }

  static List<CommentStruct> _getCommentList(dynamic data) {
    if (data == null) return const [];
    if (data is List) {
      return data
          .map((item) {
            if (item is Map<String, dynamic>) {
              return CommentStruct.maybeFromMap(item);
            }
            return null;
          })
          .whereType<CommentStruct>()
          .toList();
    }
    return const [];
  }

  // ========== COPYWIDTH FOR IMMUTABILITY ==========

  MeditationModel copyWith({
    String? id,
    String? documentId,
    String? title,
    String? authorId,
    String? authorName,
    String? authorText,
    String? authorMusic,
    String? date,
    bool? featured,
    String? imageFileName,
    String? audioFileName,
    String? audioDuration,
    String? callText,
    String? detailsText,
    int? numPlayed,
    int? numLiked,
    List<String>? category,
    List<String>? titleIndex,
    List<CommentStruct>? comments,
    String? imageUrl,
    String? audioUrl,
    DocumentReference? reference,
  }) {
    return MeditationModel(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorText: authorText ?? this.authorText,
      authorMusic: authorMusic ?? this.authorMusic,
      date: date ?? this.date,
      featured: featured ?? this.featured,
      imageFileName: imageFileName ?? this.imageFileName,
      audioFileName: audioFileName ?? this.audioFileName,
      audioDuration: audioDuration ?? this.audioDuration,
      callText: callText ?? this.callText,
      detailsText: detailsText ?? this.detailsText,
      numPlayed: numPlayed ?? this.numPlayed,
      numLiked: numLiked ?? this.numLiked,
      category: category ?? this.category,
      titleIndex: titleIndex ?? this.titleIndex,
      comments: comments ?? this.comments,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      reference: reference ?? this.reference,
    );
  }

  // ========== BUSINESS LOGIC HELPERS ==========

  /// Check if meditation is favorited by user
  bool isFavoritedBy(List<String> userFavorites) {
    return userFavorites.contains(id);
  }

  /// Increment play count
  MeditationModel incrementPlayCount() {
    return copyWith(numPlayed: numPlayed + 1);
  }

  /// Increment like count
  MeditationModel incrementLikeCount() {
    return copyWith(numLiked: numLiked + 1);
  }

  /// Decrement like count
  MeditationModel decrementLikeCount() {
    return copyWith(numLiked: numLiked > 0 ? numLiked - 1 : 0);
  }

  // ========== EQUATABLE ==========

  @override
  List<Object?> get props => [
        id,
        documentId,
        title,
        authorId,
        authorName,
        authorText,
        authorMusic,
        date,
        featured,
        imageFileName,
        audioFileName,
        audioDuration,
        callText,
        detailsText,
        numPlayed,
        numLiked,
        category,
        titleIndex,
        comments,
        imageUrl,
        audioUrl,
        reference,
      ];

  @override
  bool get stringify => true;
}
