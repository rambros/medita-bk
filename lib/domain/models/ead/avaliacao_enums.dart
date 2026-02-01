/// Enums para o sistema de avaliação de cursos

/// Tipo de pergunta na avaliação
enum TipoPerguntaAvaliacao {
  /// Escala de emojis (1-5)
  emojiScale,

  /// Múltipla escolha (radio buttons)
  multiplaEscolha,

  /// Texto longo (textarea)
  textoLongo;

  /// Converte string para enum
  static TipoPerguntaAvaliacao fromString(String? value) {
    if (value == null) return TipoPerguntaAvaliacao.emojiScale;

    switch (value.toLowerCase()) {
      case 'emojiscale':
      case 'emoji_scale':
        return TipoPerguntaAvaliacao.emojiScale;
      case 'multiplaescolha':
      case 'multipla_escolha':
        return TipoPerguntaAvaliacao.multiplaEscolha;
      case 'textolongo':
      case 'texto_longo':
        return TipoPerguntaAvaliacao.textoLongo;
      default:
        return TipoPerguntaAvaliacao.emojiScale;
    }
  }

  /// Retorna label amigável
  String get label {
    switch (this) {
      case TipoPerguntaAvaliacao.emojiScale:
        return 'Escala de Emojis';
      case TipoPerguntaAvaliacao.multiplaEscolha:
        return 'Múltipla Escolha';
      case TipoPerguntaAvaliacao.textoLongo:
        return 'Texto Longo';
    }
  }

  /// Retorna ícone sugerido
  String get icon {
    switch (this) {
      case TipoPerguntaAvaliacao.emojiScale:
        return '😊';
      case TipoPerguntaAvaliacao.multiplaEscolha:
        return '☑️';
      case TipoPerguntaAvaliacao.textoLongo:
        return '📝';
    }
  }
}
