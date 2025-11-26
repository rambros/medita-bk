import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for images collection (replaces ImagesRecord)
class ImageModel extends Equatable {
  final String id;
  final String imageUrl;

  const ImageModel({
    required this.id,
    required this.imageUrl,
  });

  ImageModel copyWith({
    String? id,
    String? imageUrl,
  }) {
    return ImageModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ImageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ImageModel(
      id: doc.id,
      imageUrl: (data['imageUrl'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, imageUrl];
}
