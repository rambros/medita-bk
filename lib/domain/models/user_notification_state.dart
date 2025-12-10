import 'package:cloud_firestore/cloud_firestore.dart';

/// Estado de uma notificação específica para um usuário
/// Armazenado em subcollection user_states/{userId} de cada notificação
class UserNotificationState {
  final String userId;
  final bool lido;
  final bool ocultado;
  final DateTime? dataLeitura;
  final DateTime? dataOcultacao;

  const UserNotificationState({
    required this.userId,
    this.lido = false,
    this.ocultado = false,
    this.dataLeitura,
    this.dataOcultacao,
  });

  factory UserNotificationState.fromMap(Map<String, dynamic> map, String userId) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return UserNotificationState(
      userId: userId,
      lido: map['lido'] as bool? ?? false,
      ocultado: map['ocultado'] as bool? ?? false,
      dataLeitura: parseDate(map['dataLeitura']),
      dataOcultacao: parseDate(map['dataOcultacao']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lido': lido,
      'ocultado': ocultado,
      if (dataLeitura != null) 'dataLeitura': Timestamp.fromDate(dataLeitura!),
      if (dataOcultacao != null) 'dataOcultacao': Timestamp.fromDate(dataOcultacao!),
    };
  }

  UserNotificationState copyWith({
    String? userId,
    bool? lido,
    bool? ocultado,
    DateTime? dataLeitura,
    DateTime? dataOcultacao,
  }) {
    return UserNotificationState(
      userId: userId ?? this.userId,
      lido: lido ?? this.lido,
      ocultado: ocultado ?? this.ocultado,
      dataLeitura: dataLeitura ?? this.dataLeitura,
      dataOcultacao: dataOcultacao ?? this.dataOcultacao,
    );
  }

  /// Marca como lida
  UserNotificationState marcarComoLida() {
    return copyWith(
      lido: true,
      dataLeitura: DateTime.now(),
    );
  }

  /// Marca como ocultada (deletada pelo usuário)
  UserNotificationState marcarComoOcultada() {
    return copyWith(
      ocultado: true,
      dataOcultacao: DateTime.now(),
    );
  }

  @override
  String toString() => 'UserNotificationState(userId: $userId, lido: $lido, ocultado: $ocultado)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserNotificationState && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
