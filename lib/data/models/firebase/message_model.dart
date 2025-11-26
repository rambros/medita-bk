import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for messages collection (replaces MessagesRecord)
class MessageModel extends Equatable {
  final String id;
  final String mensagem;
  final String tema;
  final int orderId;

  const MessageModel({
    required this.id,
    required this.mensagem,
    required this.tema,
    required this.orderId,
  });

  MessageModel copyWith({
    String? id,
    String? mensagem,
    String? tema,
    int? orderId,
  }) {
    return MessageModel(
      id: id ?? this.id,
      mensagem: mensagem ?? this.mensagem,
      tema: tema ?? this.tema,
      orderId: orderId ?? this.orderId,
    );
  }

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MessageModel(
      id: doc.id,
      mensagem: (data['mensagem'] as String?) ?? '',
      tema: (data['tema'] as String?) ?? '',
      orderId: (data['id'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mensagem': mensagem,
      'tema': tema,
      'id': orderId,
    };
  }

  @override
  List<Object?> get props => [id, mensagem, tema, orderId];
}
