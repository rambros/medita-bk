import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidade de domínio para músicas do Traffic Control
class TcMusicEntity {
  final String id;
  final String title;
  final String? artist;
  final String audioUrl;
  final String? thumbnailUrl;
  final int durationSec;
  final String? category;
  final bool isActive;

  const TcMusicEntity({
    required this.id,
    required this.title,
    this.artist,
    required this.audioUrl,
    this.thumbnailUrl,
    required this.durationSec,
    this.category,
    this.isActive = true,
  });

  /// Cria uma entidade vazia
  factory TcMusicEntity.empty() {
    return const TcMusicEntity(
      id: '',
      title: '',
      artist: null,
      audioUrl: '',
      thumbnailUrl: null,
      durationSec: 0,
      category: null,
      isActive: true,
    );
  }

  /// Deserializa de Firestore
  factory TcMusicEntity.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return TcMusicEntity.fromMap(map, doc.id);
  }

  /// Deserializa de Map
  factory TcMusicEntity.fromMap(Map<String, dynamic> map, String id) {
    return TcMusicEntity(
      id: id,
      title: map['title'] as String? ?? '',
      artist: map['artist'] as String?,
      audioUrl: map['audioUrl'] as String? ?? '',
      thumbnailUrl: map['thumbnailUrl'] as String?,
      durationSec: map['durationSec'] as int? ?? 0,
      category: map['category'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  /// Serializa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
      'thumbnailUrl': thumbnailUrl,
      'durationSec': durationSec,
      'category': category,
      'isActive': isActive,
    };
  }

  /// Serializa para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      ...toFirestore(),
    };
  }

  /// Cria uma cópia com modificações
  TcMusicEntity copyWith({
    String? id,
    String? title,
    String? artist,
    String? audioUrl,
    String? thumbnailUrl,
    int? durationSec,
    String? category,
    bool? isActive,
  }) {
    return TcMusicEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      audioUrl: audioUrl ?? this.audioUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      durationSec: durationSec ?? this.durationSec,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Duração formatada (MM:SS)
  String get formattedDuration {
    final minutes = durationSec ~/ 60;
    final seconds = durationSec % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Informações concatenadas para exibição
  String get subtitle {
    final parts = <String>[];

    if (artist != null && artist!.isNotEmpty) {
      parts.add(artist!);
    }

    parts.add(formattedDuration);

    return parts.join(' • ');
  }

  @override
  String toString() {
    return 'TcMusicEntity(id: $id, title: $title, duration: $formattedDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TcMusicEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
