import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for application settings (replacing SettingsRecord)
class SettingsModel extends Equatable {
  final String id;
  final bool habilitaDesafio21;
  final DateTime? diaInicioDesafio21;

  const SettingsModel({
    required this.id,
    required this.habilitaDesafio21,
    this.diaInicioDesafio21,
  });

  SettingsModel copyWith({
    String? id,
    bool? habilitaDesafio21,
    DateTime? diaInicioDesafio21,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      habilitaDesafio21: habilitaDesafio21 ?? this.habilitaDesafio21,
      diaInicioDesafio21: diaInicioDesafio21 ?? this.diaInicioDesafio21,
    );
  }

  factory SettingsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final timestamp = data['diaInicioDesafio21'];
    return SettingsModel(
      id: doc.id,
      habilitaDesafio21: (data['habilitaDesafio21'] as bool?) ?? false,
      diaInicioDesafio21: timestamp is Timestamp ? timestamp.toDate() : timestamp as DateTime?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habilitaDesafio21': habilitaDesafio21,
      'diaInicioDesafio21': diaInicioDesafio21 != null ? Timestamp.fromDate(diaInicioDesafio21!) : null,
    }..removeWhere((_, value) => value == null);
  }

  @override
  List<Object?> get props => [id, habilitaDesafio21, diaInicioDesafio21];
}
