/// Constantes de rotas para o modulo EAD
class EadRoutes {
  EadRoutes._();

  // Home EAD
  static const String eadHome = 'eadHome';
  static const String eadHomePath = 'ead';

  // Catalogo de Cursos
  static const String catalogoCursos = 'catalogoCursos';
  static const String catalogoCursosPath = 'ead/cursos';

  // Detalhes do Curso
  static const String cursoDetalhes = 'cursoDetalhes';
  static const String cursoDetalhesPath = 'ead/curso/:cursoId';

  // Meus Cursos
  static const String meusCursos = 'meusCursos';
  static const String meusCursosPath = 'ead/meus-cursos';

  // Player de Topico
  static const String playerTopico = 'playerTopico';
  static const String playerTopicoPath = 'ead/curso/:cursoId/aula/:aulaId/topico/:topicoId';

  // Quiz
  static const String quiz = 'quiz';
  static const String quizPath = 'ead/curso/:cursoId/aula/:aulaId/topico/:topicoId/quiz';

  // Certificado
  static const String certificado = 'certificado';
  static const String certificadoPath = 'ead/certificado/:cursoId';

  // Suporte - Tickets
  static const String meusTickets = 'meusTickets';
  static const String meusTicketsPath = 'suporte/tickets';

  static const String novoTicket = 'novoTicket';
  static const String novoTicketPath = 'suporte/novo-ticket';

  static const String ticketChat = 'ticketChat';
  static const String ticketChatPath = 'suporte/ticket/:ticketId';

  // Discussões (Q&A)
  static const String discussoesCurso = 'discussoesCurso';
  static const String discussoesCursoPath = 'ead/curso/:cursoId/discussoes';

  static const String novaDiscussao = 'novaDiscussao';
  static const String novaDiscussaoPath = 'ead/curso/:cursoId/discussoes/nova';

  static const String discussaoDetail = 'discussaoDetail';
  static const String discussaoDetailPath = 'ead/discussao/:discussaoId';
}
