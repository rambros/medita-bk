import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Pure Dart model for categories (replacing CategoryRecord)
class CategoryModel extends Equatable {
  final String id;
  final String nome;
  final String tipo;
  final String valor;

  const CategoryModel({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.valor,
  });

  CategoryModel copyWith({
    String? id,
    String? nome,
    String? tipo,
    String? valor,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
    );
  }

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CategoryModel(
      id: doc.id,
      nome: (data['nome'] as String?) ?? '',
      tipo: (data['tipo'] as String?) ?? '',
      valor: (data['valor'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'tipo': tipo,
      'valor': valor,
    };
  }

  @override
  List<Object?> get props => [id, nome, tipo, valor];
}
