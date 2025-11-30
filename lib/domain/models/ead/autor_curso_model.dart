/// Model para informações do autor (denormalizado)
/// Compatível com AutorCursoModel do Web Admin
class AutorCursoModel {
  final String id;
  final String nome;
  final String? imagemUrl;

  const AutorCursoModel({
    required this.id,
    required this.nome,
    this.imagemUrl,
  });

  factory AutorCursoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const AutorCursoModel(id: '', nome: '');
    }
    return AutorCursoModel(
      id: map['id'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      imagemUrl: map['imagemUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      if (imagemUrl != null) 'imagemUrl': imagemUrl,
    };
  }

  AutorCursoModel copyWith({
    String? id,
    String? nome,
    String? imagemUrl,
  }) {
    return AutorCursoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      imagemUrl: imagemUrl ?? this.imagemUrl,
    );
  }

  /// Retorna as iniciais do nome para avatar placeholder
  String get iniciais {
    final palavras = nome.split(' ').where((p) => p.isNotEmpty).toList();
    if (palavras.isEmpty) return 'A';
    if (palavras.length == 1) return palavras[0][0].toUpperCase();
    return '${palavras[0][0]}${palavras[1][0]}'.toUpperCase();
  }

  @override
  String toString() => 'AutorCursoModel(id: $id, nome: $nome)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AutorCursoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
