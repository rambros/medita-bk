import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for musics collection (replaces MusicsRecord)
class MusicModel extends Equatable {
  final String id;
  final String title;
  final String audioType;
  final String author;
  final String fileType;
  final String fileLocation;
  final int duration;
  final DocumentReference? reference;

  const MusicModel({
    required this.id,
    required this.title,
    required this.audioType,
    required this.author,
    required this.fileType,
    required this.fileLocation,
    required this.duration,
    this.reference,
  });

  MusicModel copyWith({
    String? id,
    String? title,
    String? audioType,
    String? author,
    String? fileType,
    String? fileLocation,
    int? duration,
    DocumentReference? reference,
  }) {
    return MusicModel(
      id: id ?? this.id,
      title: title ?? this.title,
      audioType: audioType ?? this.audioType,
      author: author ?? this.author,
      fileType: fileType ?? this.fileType,
      fileLocation: fileLocation ?? this.fileLocation,
      duration: duration ?? this.duration,
      reference: reference ?? this.reference,
    );
  }

  factory MusicModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MusicModel(
      id: doc.id,
      title: (data['title'] as String?) ?? '',
      audioType: (data['audioType'] as String?) ?? '',
      author: (data['author'] as String?) ?? '',
      fileType: (data['fileType'] as String?) ?? '',
      fileLocation: (data['fileLocation'] as String?) ?? '',
      duration: (data['duration'] as int?) ?? 0,
      reference: doc.reference,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'audioType': audioType,
      'author': author,
      'fileType': fileType,
      'fileLocation': fileLocation,
      'duration': duration,
      if (reference != null) 'id': reference,
    };
  }

  @override
  List<Object?> get props => [id, title, audioType, author, fileType, fileLocation, duration, reference];
}
