/// Barrel file para o modulo EAD
///
/// Uso:
/// ```dart
/// import 'package:medita_bk/ui/ead/index.dart';
/// ```
library;

// Pages
export 'ead_home_page/ead_home_page.dart';
export 'catalogo_cursos_page/catalogo_cursos_page.dart';
export 'curso_detalhes_page/curso_detalhes_page.dart';
export 'meus_cursos_page/meus_cursos_page.dart';
export 'player_topico_page/player_topico_page.dart';
export 'quiz_page/quiz_page.dart';
export 'certificado_page/certificado_page.dart';

// ViewModels
export 'catalogo_cursos_page/view_model/catalogo_cursos_view_model.dart';
export 'curso_detalhes_page/view_model/curso_detalhes_view_model.dart';
export 'meus_cursos_page/view_model/meus_cursos_view_model.dart';
export 'player_topico_page/view_model/player_topico_view_model.dart';
export 'quiz_page/view_model/quiz_view_model.dart';
export 'ead_home_page/view_model/ead_home_view_model.dart';
export 'certificado_page/view_model/certificado_view_model.dart';

// Widgets - Catalogo
export 'catalogo_cursos_page/widgets/curso_card.dart';

// Widgets - Detalhes do Curso
export 'curso_detalhes_page/widgets/curso_info_header.dart';
export 'curso_detalhes_page/widgets/curriculo_section.dart';
export 'curso_detalhes_page/widgets/objetivos_section.dart';

// Widgets - Meus Cursos
export 'meus_cursos_page/widgets/meu_curso_card.dart';
export 'meus_cursos_page/widgets/resumo_progresso_widget.dart';

// Widgets - Player
export 'player_topico_page/widgets/navegacao_topicos_widget.dart';
export 'player_topico_page/widgets/mark_complete_button.dart';
export 'player_topico_page/widgets/topico_content_widget.dart';
export 'player_topico_page/widgets/topico_header_widget.dart';

// Widgets - Quiz
export 'quiz_page/widgets/question_tile.dart';
export 'quiz_page/widgets/quiz_result_widget.dart';

// Widgets - Home EAD
export 'ead_home_page/widgets/ead_home_widgets.dart';

// Widgets - Certificado
export 'certificado_page/widgets/certificado_widget.dart';

// === SUPORTE - TICKETS ===

// Pages
export 'suporte/meus_tickets_page/meus_tickets_page.dart';
export 'suporte/novo_ticket_page/novo_ticket_page.dart';
export 'suporte/ticket_chat_page/ticket_chat_page.dart';

// ViewModels
export 'suporte/meus_tickets_page/view_model/meus_tickets_view_model.dart';
export 'suporte/novo_ticket_page/view_model/novo_ticket_view_model.dart';
export 'suporte/ticket_chat_page/view_model/ticket_chat_view_model.dart';

// Widgets
export 'suporte/meus_tickets_page/widgets/ticket_card.dart';
export 'suporte/ticket_chat_page/widgets/mensagem_bubble.dart';
export 'suporte/ticket_chat_page/widgets/input_mensagem.dart';

// === DISCUSSÕES (Q&A) ===

// Pages
export 'discussoes/discussoes_curso_page/discussoes_curso_page.dart';
export 'discussoes/discussao_detail_page/discussao_detail_page.dart';
export 'discussoes/nova_discussao_page/nova_discussao_page.dart';

// ViewModels
export 'discussoes/discussoes_curso_page/view_model/discussoes_curso_view_model.dart';
export 'discussoes/discussao_detail_page/view_model/discussao_detail_view_model.dart';
export 'discussoes/nova_discussao_page/view_model/nova_discussao_view_model.dart';

// Widgets
export 'discussoes/discussoes_curso_page/widgets/discussao_card.dart';
export 'discussoes/discussao_detail_page/widgets/resposta_card.dart';
export 'discussoes/discussao_detail_page/widgets/input_resposta.dart';
