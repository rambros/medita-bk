import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/domain/models/ead/index.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'view_model/discussao_detail_view_model.dart';
import 'widgets/resposta_card.dart';
import 'widgets/input_resposta.dart';

/// Página de detalhes da discussão
class DiscussaoDetailPage extends StatefulWidget {
  final String discussaoId;

  const DiscussaoDetailPage({
    super.key,
    required this.discussaoId,
  });

  static const String routeName = EadRoutes.discussaoDetail;
  static const String routePath = EadRoutes.discussaoDetailPath;

  @override
  State<DiscussaoDetailPage> createState() => _DiscussaoDetailPageState();
}

class _DiscussaoDetailPageState extends State<DiscussaoDetailPage> {
  late final DiscussaoDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DiscussaoDetailViewModel(discussaoId: widget.discussaoId);
    _viewModel.iniciarStreams();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  String? get _usuarioId {
    final uid = context.read<AuthRepository>().currentUserUid;
    return uid.isNotEmpty ? uid : null;
  }

  String get _usuarioNome {
    final user = context.read<AuthRepository>().currentUser;
    return user?.displayName ?? user?.fullName ?? 'Usuário';
  }

  Future<void> _onEnviarResposta() async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) return;

    final sucesso = await _viewModel.enviarResposta(
      usuarioId: usuarioId,
      usuarioNome: _usuarioNome,
    );

    if (mounted && !sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao enviar resposta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onLike(String respostaId) async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) return;

    await _viewModel.toggleLike(
      respostaId: respostaId,
      usuarioId: usuarioId,
    );
  }

  Future<void> _onMarcarSolucao(RespostaDiscussaoModel resposta) async {
    final sucesso = await _viewModel.marcarComoSolucao(
      respostaId: resposta.id,
      isSolucao: !resposta.isSolucao,
    );

    if (mounted && sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resposta.isSolucao
                ? 'Resposta desmarcada como solução'
                : 'Resposta marcada como solução!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _onFecharDiscussao() async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Marcar como Resolvida'),
        content: const Text(
          'Esta discussão será marcada como resolvida. '
          'Você ainda poderá reabri-la se necessário.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.check_circle),
            label: const Text('Marcar como Resolvida'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final sucesso = await _viewModel.fecharDiscussao(usuarioId: usuarioId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              sucesso
                  ? 'Discussão marcada como resolvida!'
                  : 'Erro ao fechar discussão',
            ),
            backgroundColor: sucesso ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _onReabrirDiscussao() async {
    final usuarioId = _usuarioId;
    if (usuarioId == null) return;

    final sucesso = await _viewModel.reabrirDiscussao(usuarioId: usuarioId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sucesso
                ? 'Discussão reaberta!'
                : 'Erro ao reabrir discussão',
          ),
          backgroundColor: sucesso ? Colors.blue : Colors.red,
        ),
      );
    }
  }

  Future<void> _onEditarDiscussao() async {
    final discussao = _viewModel.discussao;
    if (discussao == null) return;

    final appTheme = AppTheme.of(context);
    final tituloController = TextEditingController(text: discussao.titulo);
    final conteudoController = TextEditingController(text: discussao.conteudo);

    final resultado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Pergunta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tituloController.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('O título não pode estar vazio'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (resultado == true && mounted) {
      final sucesso = await _viewModel.editarDiscussao(
        titulo: tituloController.text.trim(),
        conteudo: conteudoController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              sucesso
                  ? 'Pergunta editada com sucesso!'
                  : 'Erro ao editar pergunta',
            ),
            backgroundColor: sucesso ? Colors.green : Colors.red,
          ),
        );
      }
    }

    tituloController.dispose();
    conteudoController.dispose();
  }

  Future<void> _onDeletarDiscussao() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deletar Pergunta'),
        content: const Text(
          'Tem certeza que deseja deletar esta pergunta? '
          'Esta ação não pode ser desfeita e todas as respostas também serão removidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final sucesso = await _viewModel.deletarDiscussao();

      if (mounted) {
        if (sucesso) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pergunta deletada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          // Volta para a tela anterior
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao deletar pergunta'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider<DiscussaoDetailViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Text(
            'Discussão',
            style: TextStyle(color: appTheme.info),
          ),
          actions: [
            Consumer<DiscussaoDetailViewModel>(
              builder: (context, viewModel, _) {
                final discussao = viewModel.discussao;
                final usuarioId = _usuarioId ?? '';

                if (discussao == null) return const SizedBox.shrink();

                // Menu de opções - só para o criador
                if (discussao.autorId != usuarioId) {
                  return const SizedBox.shrink();
                }

                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'editar') {
                      _onEditarDiscussao();
                    } else if (value == 'fechar') {
                      _onFecharDiscussao();
                    } else if (value == 'reabrir') {
                      _onReabrirDiscussao();
                    } else if (value == 'deletar') {
                      _onDeletarDiscussao();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Editar pergunta'),
                        ],
                      ),
                    ),
                    // Mostra fechar ou reabrir dependendo do status
                    if (discussao.podeFechar(usuarioId))
                      const PopupMenuItem(
                        value: 'fechar',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text('Marcar como resolvida', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    if (discussao.podeReabrir(usuarioId))
                      const PopupMenuItem(
                        value: 'reabrir',
                        child: Row(
                          children: [
                            Icon(Icons.refresh, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Text('Reabrir pergunta', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'deletar',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Deletar pergunta', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<DiscussaoDetailViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && !viewModel.hasDiscussao) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null && !viewModel.hasDiscussao) {
              return _buildErrorState(viewModel);
            }

            if (!viewModel.hasDiscussao) {
              return const Center(
                child: Text('Discussão não encontrada'),
              );
            }

            return Column(
              children: [
                // Banner se estiver fechada
                if (viewModel.discussao!.status.isFechada)
                  _buildBannerFechada(viewModel.discussao!),

                // Conteúdo rolável
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    child: ListView(
                      controller: viewModel.scrollController,
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        // Pergunta original
                        _buildPergunta(viewModel.discussao!),

                        // Separador
                        const Divider(height: 32),

                        // Respostas
                        _buildRespostas(viewModel),
                      ],
                    ),
                  ),
                ),

                // Input de resposta
                InputResposta(
                  controller: viewModel.respostaController,
                  isEnviando: viewModel.isEnviando,
                  podeResponder: viewModel.podeResponder,
                  onEnviar: _onEnviarResposta,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerFechada(DiscussaoModel discussao) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.green.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discussão Resolvida',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                if (discussao.dataFechamento != null)
                  Text(
                    'Fechada em ${_formatarData(discussao.dataFechamento!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) {
      if (diferenca.inHours == 0) {
        if (diferenca.inMinutes == 0) {
          return 'agora';
        }
        return '${diferenca.inMinutes}min atrás';
      }
      return '${diferenca.inHours}h atrás';
    } else if (diferenca.inDays == 1) {
      return 'ontem';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays} dias atrás';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }

  Widget _buildPergunta(DiscussaoModel discussao) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);
    final isMinhaDiscussao = discussao.isMinhaDiscussao(_usuarioId ?? '');

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _StatusBadge(status: discussao.status),
              if (discussao.isPinned)
                _IconBadge(
                  icon: Icons.push_pin,
                  color: appTheme.primary,
                  label: 'Fixada',
                ),
              if (discussao.isPrivada)
                const _IconBadge(
                  icon: Icons.lock,
                  color: Colors.grey,
                  label: 'Privada',
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Título
          Text(
            discussao.titulo,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Conteúdo
          Text(
            discussao.conteudo,
            style: theme.textTheme.bodyLarge,
          ),

          // Tags
          if (discussao.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: discussao.tags.map((tag) {
                return Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 12)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Info do autor
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: discussao.autorTipo.color.withOpacity(0.2),
                backgroundImage: discussao.autorFoto != null
                    ? NetworkImage(discussao.autorFoto!)
                    : null,
                child: discussao.autorFoto == null
                    ? Icon(
                        discussao.autorTipo.icon,
                        size: 20,
                        color: discussao.autorTipo.color,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMinhaDiscussao ? 'Você' : discussao.autorNome,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      discussao.tempoDesde,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              // Contexto (curso/aula)
              if (discussao.aulaTitulo != null || discussao.topicoTitulo != null)
                Tooltip(
                  message: discussao.contexto,
                  child: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRespostas(DiscussaoDetailViewModel viewModel) {
    final usuarioId = _usuarioId ?? '';
    final podeMarcarSolucao = viewModel.podeMarcarSolucao(usuarioId);

    if (!viewModel.hasRespostas) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma resposta ainda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Seja o primeiro a responder!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de respostas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${viewModel.respostas.length} ${viewModel.respostas.length == 1 ? 'resposta' : 'respostas'}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Lista de respostas
        ...viewModel.respostasOrdenadas.map((resposta) {
          return RespostaCard(
            resposta: resposta,
            usuarioId: usuarioId,
            podeMarcarSolucao: podeMarcarSolucao,
            onLike: () => _onLike(resposta.id),
            onMarcarSolucao: podeMarcarSolucao
                ? () => _onMarcarSolucao(resposta)
                : null,
          );
        }),
      ],
    );
  }

  Widget _buildErrorState(DiscussaoDetailViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.error ?? 'Erro desconhecido',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: viewModel.refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: appTheme.info,
            ),
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }
}

/// Badge de status
class _StatusBadge extends StatelessWidget {
  final StatusDiscussao status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              color: status.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge com ícone
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _IconBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
