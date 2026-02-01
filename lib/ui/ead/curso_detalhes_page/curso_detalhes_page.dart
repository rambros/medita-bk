import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/repositories/user_repository.dart';
import 'package:medita_bk/data/services/user_document_service.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart' show routeObserver;
import 'package:medita_bk/ui/core/widgets/html_display_widget.dart';
import 'package:medita_bk/ui/core/widgets/login_snackbar.dart';
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
      LoginSnackBar.show(context, message: 'Faça login para se inscrever no curso');
      return;
    }

    // DEFENSIVO: Garante que o documento do usuário existe
    // Caso edge: documento foi deletado durante a sessão
    final userRepo = context.read<UserRepository>();
    final userDocService = UserDocumentService(
      userRepository: userRepo,
      authRepository: authRepo,
    );

    UserModel? currentUserData;
    try {
      currentUserData = await userDocService.ensureUserDocument();

      if (currentUserData == null) {
        // Faz logout para limpar estado inconsistente
        await authRepo.signOut();
        UserDocumentService.clearCache();

        if (!mounted) return;
        LoginSnackBar.show(
          context,
          message: 'Ocorreu um erro com sua conta. Por favor, faça login novamente.',
        );
        return;
      }
    } catch (e) {
      debugPrint('❌ Erro ao garantir documento do usuário: $e');
      _mostrarSnackBar('Erro ao processar sua solicitação. Tente novamente.');
      return;
    }

    // Mostra o modal de atualização (sempre solicita confirmação/atualização dos dados)
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateUserInfoDialog(
        currentUser: currentUserData!,
        onSave: (fullName, whatsapp, cidade, uf) async {
          await userRepo.updateContactInfo(
            userId: authRepo.currentUserUid,
            fullName: fullName,
            whatsapp: whatsapp,
            cidade: cidade,
            uf: uf,
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

    // Verifica se precisa mostrar botão de avaliação
    final progresso100 = viewModel.progresso >= 100;
    final cursoRequerAvaliacao = viewModel.curso?.requerAvaliacao ?? false;
    final avaliacaoPreenchida = viewModel.inscricao?.avaliacaoPreenchida ?? false;
    final mostrarBotaoAvaliacao = viewModel.isInscrito && progresso100 && cursoRequerAvaliacao && !avaliacaoPreenchida;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: mostrarBotaoAvaliacao
            ? _buildAvaliacaoSection(viewModel, appTheme)
            : _buildBotaoPrincipal(viewModel, appTheme),
      ),
    );
  }

  // Seção de avaliação com design convidativo
  Widget _buildAvaliacaoSection(CursoDetalhesViewModel viewModel, AppTheme appTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appTheme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appTheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagem do curso e título
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: viewModel.curso?.imagemCapa != null
                    ? Image.network(
                        viewModel.curso!.imagemCapa!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: appTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: appTheme.primary,
                              size: 32,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: appTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          color: appTheme.primary,
                          size: 32,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Parabéns! Você concluiu o curso',
                            style: appTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: appTheme.primaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: appTheme.secondary.withOpacity(0.6),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.pending_outlined,
                                size: 16,
                                color: appTheme.secondary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Pendente',
                                style: appTheme.bodySmall.copyWith(
                                  color: appTheme.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Compartilhe sua experiência e nos ajude a melhorar',
                      style: appTheme.bodySmall.copyWith(
                        color: appTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botões
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final inscricaoId = viewModel.inscricao!.id;
                    final resultado = await context.pushNamed(
                      EadRoutes.avaliacaoForm,
                      pathParameters: {'inscricaoId': inscricaoId},
                    );

                    if (resultado == true) {
                      await _recarregarProgresso();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: appTheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Avaliar Curso',
                    style: TextStyle(
                      color: appTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: viewModel.isConcluido ? null : _continuarCurso,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    foregroundColor: appTheme.info,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continuar Curso',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Botão principal (quando não há avaliação)
  Widget _buildBotaoPrincipal(CursoDetalhesViewModel viewModel, AppTheme appTheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: viewModel.isInscrevendo
            ? null
            : (viewModel.isInscrito ? (viewModel.isConcluido ? null : _continuarCurso) : _inscrever),
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
        label: Text(
          viewModel.textoBotaoAcao,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
