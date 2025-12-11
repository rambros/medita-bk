/// =====================================================
/// INSTRUÇÕES PARA INTEGRAR ROTAS DO EAD NO nav.dart
/// =====================================================
/// 
/// 1. No arquivo lib/routing/nav.dart, adicione os imports:
/// 
/// ```dart
/// import 'package:medita_bk/ui/ead/index.dart';
/// import 'package:medita_bk/routing/ead_routes.dart';
/// ```
/// 
/// 2. Adicione as rotas abaixo dentro da lista de FFRoutes
///    (dentro de `routes: [` do GoRouter)
/// 
/// 3. Cole o código abaixo após as outras rotas existentes:

/*
            // === MÓDULO EAD ===
            FFRoute(
              name: EadHomePage.routeName,
              path: EadHomePage.routePath,
              builder: (context, params) => const EadHomePage(),
            ),
            FFRoute(
              name: CatalogoCursosPage.routeName,
              path: CatalogoCursosPage.routePath,
              builder: (context, params) => const CatalogoCursosPage(),
            ),
            FFRoute(
              name: CursoDetalhesPage.routeName,
              path: CursoDetalhesPage.routePath,
              builder: (context, params) => CursoDetalhesPage(
                cursoId: params.getParam('cursoId', ParamType.String) ?? '',
              ),
            ),
            FFRoute(
              name: MeusCursosPage.routeName,
              path: MeusCursosPage.routePath,
              builder: (context, params) => const MeusCursosPage(),
            ),
            FFRoute(
              name: PlayerTopicoPage.routeName,
              path: PlayerTopicoPage.routePath,
              builder: (context, params) => PlayerTopicoPage(
                cursoId: params.getParam('cursoId', ParamType.String) ?? '',
                aulaId: params.getParam('aulaId', ParamType.String) ?? '',
                topicoId: params.getParam('topicoId', ParamType.String) ?? '',
              ),
            ),
            FFRoute(
              name: QuizPage.routeName,
              path: QuizPage.routePath,
              builder: (context, params) => QuizPage(
                cursoId: params.getParam('cursoId', ParamType.String) ?? '',
                aulaId: params.getParam('aulaId', ParamType.String) ?? '',
                topicoId: params.getParam('topicoId', ParamType.String) ?? '',
              ),
            ),
            FFRoute(
              name: CertificadoPage.routeName,
              path: CertificadoPage.routePath,
              builder: (context, params) => CertificadoPage(
                inscricaoId: params.getParam('inscricaoId', ParamType.String) ?? '',
              ),
            ),
            // === SUPORTE - TICKETS ===
            FFRoute(
              name: MeusTicketsPage.routeName,
              path: MeusTicketsPage.routePath,
              builder: (context, params) => const MeusTicketsPage(),
            ),
            FFRoute(
              name: NovoTicketPage.routeName,
              path: NovoTicketPage.routePath,
              builder: (context, params) => const NovoTicketPage(),
            ),
            FFRoute(
              name: TicketChatPage.routeName,
              path: TicketChatPage.routePath,
              builder: (context, params) => TicketChatPage(
                ticketId: params.getParam('ticketId', ParamType.String) ?? '',
              ),
            ),
            // === DISCUSSÕES (Q&A) ===
            FFRoute(
              name: DiscussoesCursoPage.routeName,
              path: DiscussoesCursoPage.routePath,
              builder: (context, params) {
                final extra = params.extra as Map<String, dynamic>?;
                return DiscussoesCursoPage(
                  cursoId: params.getParam('cursoId', ParamType.String) ?? '',
                  cursoTitulo: extra?['cursoTitulo'] ?? '',
                );
              },
            ),
            FFRoute(
              name: NovaDiscussaoPage.routeName,
              path: NovaDiscussaoPage.routePath,
              builder: (context, params) {
                final extra = params.extra as Map<String, dynamic>?;
                return NovaDiscussaoPage(
                  cursoId: params.getParam('cursoId', ParamType.String) ?? '',
                  cursoTitulo: extra?['cursoTitulo'] ?? '',
                );
              },
            ),
            FFRoute(
              name: DiscussaoDetailPage.routeName,
              path: DiscussaoDetailPage.routePath,
              builder: (context, params) => DiscussaoDetailPage(
                discussaoId: params.getParam('discussaoId', ParamType.String) ?? '',
              ),
            ),
            // === FIM MÓDULO EAD ===
*/

/// =====================================================
/// EXEMPLO DE NAVEGAÇÃO PARA AS ROTAS EAD
/// =====================================================
/// 
/// ```dart
/// // Ir para Home EAD
/// context.pushNamed(EadRoutes.eadHome);
/// 
/// // Ir para Catálogo de Cursos
/// context.pushNamed(EadRoutes.catalogoCursos);
/// 
/// // Ir para Detalhes do Curso
/// context.pushNamed(
///   EadRoutes.cursoDetalhes,
///   pathParameters: {'cursoId': 'abc123'},
/// );
/// 
/// // Ir para Meus Cursos
/// context.pushNamed(EadRoutes.meusCursos);
/// 
/// // Ir para Player do Tópico
/// context.pushNamed(
///   EadRoutes.playerTopico,
///   pathParameters: {
///     'cursoId': 'curso123',
///     'aulaId': 'aula456',
///     'topicoId': 'topico789',
///   },
/// );
/// 
/// // Ir para Quiz
/// context.pushNamed(
///   EadRoutes.quiz,
///   pathParameters: {
///     'cursoId': 'curso123',
///     'aulaId': 'aula456',
///     'topicoId': 'topico789',
///   },
/// );
/// 
/// // Ir para Certificado
/// context.pushNamed(
///   EadRoutes.certificado,
///   pathParameters: {'inscricaoId': 'inscricao_abc'},
/// );
///
/// // === DISCUSSÕES (Q&A) ===
///
/// // Ir para Discussões do Curso
/// context.pushNamed(
///   EadRoutes.discussoesCurso,
///   pathParameters: {'cursoId': 'curso123'},
///   extra: {'cursoTitulo': 'Nome do Curso'},
/// );
///
/// // Ir para Nova Discussão
/// context.pushNamed(
///   EadRoutes.novaDiscussao,
///   pathParameters: {'cursoId': 'curso123'},
///   extra: {'cursoTitulo': 'Nome do Curso'},
/// );
///
/// // Ir para Detalhes da Discussão
/// context.pushNamed(
///   EadRoutes.discussaoDetail,
///   pathParameters: {'discussaoId': 'discussao123'},
/// );
/// ```
