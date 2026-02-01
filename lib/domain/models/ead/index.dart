/// Barrel file para os models do módulo EAD
///
/// Uso:
/// ```dart
/// import 'package:medita_bk/domain/models/ead/index.dart';
/// ```
library;

export 'ead_enums.dart';
export 'autor_curso_model.dart';
export 'curso_model.dart';
export 'aula_model.dart';
export 'topico_model.dart';
export 'progresso_curso_model.dart';
export 'inscricao_curso_model.dart';
export 'quiz_question_model.dart';

// Avaliação
export 'avaliacao_enums.dart';
export 'pergunta_avaliacao_model.dart';
export 'avaliacao_curso_model.dart';
export 'resposta_avaliacao_model.dart';

// Comunicação (Tickets)
export 'comunicacao_enums.dart';
export 'ticket_model.dart';
export 'ticket_mensagem_model.dart';

// Comunicação (Discussões Q&A)
export 'discussao_model.dart';
export 'resposta_discussao_model.dart';

// Notificações EAD
export 'notificacao_ead_model.dart';
