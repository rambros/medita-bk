import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/services/user_document_service.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart' show routeObserver;
import 'package:medita_bk/ui/core/widgets/html_display_widget.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'package:medita_bk/ui/ead/widgets/update_user_info_dialog.dart';
import 'view_model/curso_detalhes_view_model.dart';
import 'widgets/curso_info_header.dart';
import 'widgets/curriculo_section.dart';
import 'widgets/objetivos_section.dart';

/// Página de detalhes do curso
class CursoDetalhesPage extends StatefulWidget {
  const CursoDetalhesPage({
    super.key,
    required this.cursoId,
  });

  final String cursoId;

  static const String routeName = EadRoutes.cursoDetalhes;
  static const String routePath = EadRoutes.cursoDetalhesPath;

  @override
  State<CursoDetalhesPage> createState() => _CursoDetalhesPageState();
}

class _CursoDetalhesPageState extends State<CursoDetalhesPage> with RouteAware {
  late final CursoDetalhesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CursoDetalhesViewModel(cursoId: widget.cursoId);
    _carregarDados();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registra para receber notificações de navegação
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Chamado quando uma rota acima é removida (usuário voltou para esta página)
    _recarregarProgresso();
  }

  Future<void> _carregarDados() async {
    final authRepo = context.read<AuthRepository>();
    final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;

    // Força refresh para garantir dados atualizados do Firestore
    await _viewModel.refresh(usuarioId: usuarioId);
  }

  Future<void> _inscrever() async {
    final authRepo = context.read<AuthRepository>();
    final user = authRepo.currentUser;
    if (user == null || authRepo.currentUserUid.isEmpty) {
      _mostrarSnackBar('Faça login para se inscrever');
      return;
    }

    // DEFENSIVO: Garante que o documento do usuário existe
    // Caso edge: documento foi deletado durante a sessão
    final userRepo = context.read<UserRepository>();
    final userDocService = UserDocumentService(
      userRepository: userRepo,
      authRepository: authRepo,
    );

    var currentUserData = await userDocService.ensureUserDocument();

    if (currentUserData == null) {
      _mostrarSnackBar('Erro ao carregar dados do usuário');
      return;
    }

    // Mostra o modal de atualização (sempre solicita confirmação/atualização dos dados)
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateUserInfoDialog(
        currentUser: currentUserData,
        onSave: (fullName, whatsapp, cidade) async {
          await userRepo.updateContactInfo(
            userId: authRepo.currentUserUid,
            fullName: fullName,
            whatsapp: whatsapp,
            cidade: cidade,
          );
        },
      ),
    );

    // Se o usuário cancelou, não continua com a inscrição
    if (result != true) {
      return;
    }

    // Busca novamente os dados atualizados
    final updatedUserData = await userRepo.getUserById(authRepo.currentUserUid);
    if (updatedUserData == null) {
      _mostrarSnackBar('Erro ao carregar dados atualizados');
      return;
    }

    // Realiza a inscrição com os dados atualizados
    final sucesso = await _viewModel.inscrever(
      usuarioId: authRepo.currentUserUid,
      usuarioNome: updatedUserData.fullName.isEmpty ? user.displayName : updatedUserData.fullName,
      usuarioEmail: user.email,
      usuarioFoto: user.photoUrl,
    );

    if (sucesso) {
      _mostrarSnackBar('Inscrição realizada com sucesso!');
    } else {
      _mostrarSnackBar('Erro ao realizar inscrição');
    }
  }

  Future<void> _navegarParaTopico(String aulaId, String topicoId) async {
    await context.pushNamed(
      EadRoutes.playerTopico,
      pathParameters: {
        'cursoId': widget.cursoId,
        'aulaId': aulaId,
        'topicoId': topicoId,
      },
    );
    // O refresh é feito automaticamente via didPopNext
  }

  Future<void> _recarregarProgresso() async {
    final authRepo = context.read<AuthRepository>();
    final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
    await _viewModel.refresh(usuarioId: usuarioId);
  }

  Future<void> _continuarCurso() async {
    final proximo = _viewModel.proximoTopico;
    if (proximo != null) {
      await _navegarParaTopico(proximo.aulaId, proximo.topicoId);
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: Consumer<CursoDetalhesViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              final appTheme = AppTheme.of(context);
              return Center(
                child: CircularProgressIndicator(color: appTheme.primary),
              );
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (viewModel.curso == null) {
              return _buildNaoEncontrado();
            }

            return _buildConteudo(viewModel);
          },
        ),
        bottomNavigationBar: Consumer<CursoDetalhesViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading || viewModel.curso == null) {
              return const SizedBox.shrink();
            }
            return _buildBottomBar(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildError(CursoDetalhesViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return CustomScrollView(
      slivers: [
        _buildAppBar(null),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: appTheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.error!,
                    textAlign: TextAlign.center,
                    style: appTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _carregarDados,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.primary,
                      foregroundColor: appTheme.info,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNaoEncontrado() {
    final appTheme = AppTheme.of(context);

    return CustomScrollView(
      slivers: [
        _buildAppBar(null),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: appTheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Curso não encontrado',
                  style: appTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    foregroundColor: appTheme.info,
                  ),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConteudo(CursoDetalhesViewModel viewModel) {
    final curso = viewModel.curso!;

    return RefreshIndicator(
      onRefresh: () {
        final authRepo = context.read<AuthRepository>();
        final usuarioId = authRepo.currentUserUid.isEmpty ? null : authRepo.currentUserUid;
        return viewModel.refresh(usuarioId: usuarioId);
      },
      child: CustomScrollView(
        slivers: [
          // AppBar
          _buildAppBar(curso.titulo),

          // Conteúdo
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com info do curso
                CursoInfoHeader(
                  curso: curso,
                  inscricao: viewModel.inscricao,
                  totalTopicosCalculado: viewModel.totalTopicos,
                ),

                const Divider(),

                // Objetivos
                if (curso.objetivos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ObjetivosSection(objetivos: curso.objetivos),
                  const SizedBox(height: 24),
                  const Divider(),
                ],

                // Requisitos
                if (curso.requisitos.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  RequisitosSection(requisitos: curso.requisitos),
                  const SizedBox(height: 24),
                  const Divider(),
                ],

                // Descrição completa
                if (curso.descricao?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sobre o Curso',
                          style: AppTheme.of(context).titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.of(context).primaryText,
                              ),
                        ),
                        const SizedBox(height: 12),
                        HtmlDisplayWidget(description: curso.descricao!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                ],

                // Currículo
                const SizedBox(height: 16),
                CurriculoSection(
                  aulas: viewModel.aulas,
                  aulasExpandidas: viewModel.aulasExpandidas,
                  onToggleAula: viewModel.toggleAulaExpandida,
                  onTopicoTap: (aula, topico) {
                    if (viewModel.isInscrito) {
                      _navegarParaTopico(aula.id, topico.id);
                    } else {
                      _mostrarSnackBar('Inscreva-se para acessar o conteúdo');
                    }
                  },
                  isTopicoCompleto: viewModel.isTopicoCompleto,
                  isAulaCompleta: viewModel.isAulaCompleta,
                  isInscrito: viewModel.isInscrito,
                ),

                // Espaço para o bottom bar
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(String? titulo) {
    final appTheme = AppTheme.of(context);

    return SliverAppBar(
      floating: true,
      backgroundColor: appTheme.primary,
      foregroundColor: appTheme.info,
      elevation: 2.0,
      title: titulo != null
          ? Text(
              titulo,
              style: appTheme.titleLarge.copyWith(
                color: appTheme.info,
              ),
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.question_answer),
          tooltip: 'Perguntas',
          onPressed: () {
            context.pushNamed(
              EadRoutes.discussoesCurso,
              pathParameters: {'cursoId': widget.cursoId},
              queryParameters: {'cursoTitulo': titulo ?? ''},
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar(CursoDetalhesViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Info de progresso
            if (viewModel.isInscrito) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${viewModel.topicosCompletos}/${viewModel.totalTopicos} tópicos',
                      style: appTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: viewModel.progresso / 100,
                        minHeight: 6,
                        backgroundColor: appTheme.accent4,
                        valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],

            // Botão principal
            Expanded(
              flex: viewModel.isInscrito ? 0 : 1,
              child: SizedBox(
                width: viewModel.isInscrito ? null : double.infinity,
                child: ElevatedButton.icon(
                  onPressed: viewModel.isInscrevendo
                      ? null
                      : (viewModel.isInscrito
                          ? (viewModel.isConcluido ? null : _continuarCurso)
                          : _inscrever),
                  icon: viewModel.isInscrevendo
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(appTheme.info),
                          ),
                        )
                      : Icon(viewModel.iconeBotaoAcao),
                  label: Text(viewModel.textoBotaoAcao),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    foregroundColor: appTheme.info,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
