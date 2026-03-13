import 'dart:convert';

/// Entidade de domínio para alarmes do Traffic Control
class TcAlarmEntity {
  final String id;
  final String title;
  final int hour; // 0-23
  final int minute; // 0-59
  final String musicId;
  final String musicTitle;
  final String musicUrl;
  final int musicDurationSec; // Duração da música em segundos
  final int maxDurationSec; // 0 = sem limite (até fim do áudio)
  final bool isEnabled;
  final List<int> daysOfWeek; // 1=seg, 7=dom. Vazio = diário
  final DateTime createdAt;

  const TcAlarmEntity({
    required this.id,
    required this.title,
    required this.hour,
    required this.minute,
    required this.musicId,
    required this.musicTitle,
    required this.musicUrl,
    this.musicDurationSec = 60, // Padrão 1 min
    this.maxDurationSec = 0,
    this.isEnabled = true,
    this.daysOfWeek = const [],
    required this.createdAt,
  });

  /// Cria uma entidade vazia com valores padrão
  factory TcAlarmEntity.empty() {
    return TcAlarmEntity(
      id: '',
      title: '',
      hour: 7,
      minute: 0,
      musicId: '',
      musicTitle: '',
      musicUrl: '',
      musicDurationSec: 60,
      maxDurationSec: 0,
      isEnabled: true,
      daysOfWeek: const [],
      createdAt: DateTime.now(),
    );
  }

  /// Deserializa de Map (SharedPreferences)
  factory TcAlarmEntity.fromMap(Map<String, dynamic> map) {
    return TcAlarmEntity(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      hour: map['hour'] as int? ?? 7,
      minute: map['minute'] as int? ?? 0,
      musicId: map['musicId'] as String? ?? '',
      musicTitle: map['musicTitle'] as String? ?? '',
      musicUrl: map['musicUrl'] as String? ?? '',
      musicDurationSec: map['musicDurationSec'] as int? ?? 60,
      maxDurationSec: map['maxDurationSec'] as int? ?? 0,
      isEnabled: map['isEnabled'] as bool? ?? true,
      daysOfWeek: (map['daysOfWeek'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Serializa para Map (SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'hour': hour,
      'minute': minute,
      'musicId': musicId,
      'musicTitle': musicTitle,
      'musicUrl': musicUrl,
      'musicDurationSec': musicDurationSec,
      'maxDurationSec': maxDurationSec,
      'isEnabled': isEnabled,
      'daysOfWeek': daysOfWeek,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Cria uma cópia com modificações
  TcAlarmEntity copyWith({
    String? id,
    String? title,
    int? hour,
    int? minute,
    String? musicId,
    String? musicTitle,
    String? musicUrl,
    int? musicDurationSec,
    int? maxDurationSec,
    bool? isEnabled,
    List<int>? daysOfWeek,
    DateTime? createdAt,
  }) {
    return TcAlarmEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      musicId: musicId ?? this.musicId,
      musicTitle: musicTitle ?? this.musicTitle,
      musicUrl: musicUrl ?? this.musicUrl,
      musicDurationSec: musicDurationSec ?? this.musicDurationSec,
      maxDurationSec: maxDurationSec ?? this.maxDurationSec,
      isEnabled: isEnabled ?? this.isEnabled,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Horário formatado (HH:MM)
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Descrição dos dias da semana
  String get daysDescription {
    if (daysOfWeek.isEmpty) return 'Todos os dias';

    if (daysOfWeek.length == 7) return 'Todos os dias';

    final dayNames = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return daysOfWeek.map((day) => dayNames[day - 1]).join(', ');
  }

  /// Duração formatada
  String get formattedDuration {
    if (maxDurationSec == 0) return 'Até o fim do áudio';

    final minutes = maxDurationSec ~/ 60;
    final seconds = maxDurationSec % 60;

    if (seconds == 0) {
      return '$minutes min';
    }

    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }

  /// Duração da música formatada
  String get formattedMusicDuration {
    final minutes = musicDurationSec ~/ 60;
    final seconds = musicDurationSec % 60;

    if (seconds == 0) {
      return '$minutes min';
    }

    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }

  @override
  String toString() {
    return 'TcAlarmEntity(id: $id, title: $title, time: $formattedTime, enabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TcAlarmEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
