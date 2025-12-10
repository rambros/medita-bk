import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/ui/core/theme/app_theme.dart';
import 'view_model/notificacoes_view_model.dart';
import 'widgets/notificacao_card.dart';
import 'widgets/notificacoes_empty_state.dart';
import 'widgets/notificacoes_debug_info.dart';

/// Página de notificações
/// Exibe todas as notificações do usuário com badge counter no app
class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificacoesViewModel(),
      child: const _NotificacoesPageContent(),
    );
  }
}

class _NotificacoesPageContent extends StatelessWidget {
  const _NotificacoesPageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificacoesViewModel>();
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notificações',
          style: appTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Badge com total não lidas
          if (viewModel.temNaoLidas)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: appTheme.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${viewModel.totalNaoLidas}',
                  style: appTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Menu de ações
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'marcar_todas_lidas',
                enabled: viewModel.temNaoLidas,
                child: Row(
                  children: [
                    Icon(
                      Icons.done_all,
                      color: viewModel.temNaoLidas
                          ? appTheme.primaryText
                          : appTheme.secondaryText,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Marcar todas como lidas',
                      style: TextStyle(
                        color: viewModel.temNaoLidas
                            ? appTheme.primaryText
                            : appTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(context, viewModel, appTheme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificacoesViewModel viewModel,
    AppTheme appTheme,
  ) {
    // Loading
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: appTheme.primary),
      );
    }

    // Error
    if (viewModel.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: appTheme.error.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: appTheme.bodyMedium.copyWith(
                  color: appTheme.primaryText,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: viewModel.loadNotificacoes,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (!viewModel.hasNotificacoes) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const NotificacoesDebugInfo(),
            const NotificacoesEmptyState(),
          ],
        ),
      );
    }

    // Lista de notificações
    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: appTheme.primary,
      child: CustomScrollView(
        slivers: [
          // Debug info
          const SliverToBoxAdapter(
            child: NotificacoesDebugInfo(),
          ),

          // Notificações não lidas
          if (viewModel.notificacoesNaoLidas.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: appTheme.secondaryBackground,
                child: Text(
                  'NÃO LIDAS',
                  style: appTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appTheme.secondaryText,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notificacao = viewModel.notificacoesNaoLidas[index];
                  return NotificacaoCard(
                    notificacao: notificacao,
                    onTap: () => _handleNotificacaoTap(context, notificacao),
                    onDismiss: () => _handleNotificacaoRemove(
                      context,
                      notificacao,
                    ),
                    onMarkAsRead: () => _handleMarkAsRead(context, notificacao),
                    onDelete: () => _handleNotificacaoRemove(
                      context,
                      notificacao,
                    ),
                  );
                },
                childCount: viewModel.notificacoesNaoLidas.length,
              ),
            ),
          ],

          // Notificações lidas
          if (viewModel.notificacoesLidas.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: appTheme.secondaryBackground,
                child: Text(
                  'ANTERIORES',
                  style: appTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appTheme.secondaryText,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notificacao = viewModel.notificacoesLidas[index];
                  return NotificacaoCard(
                    notificacao: notificacao,
                    onTap: () => _handleNotificacaoTap(context, notificacao),
                    onDismiss: () => _handleNotificacaoRemove(
                      context,
                      notificacao,
                    ),
                    onDelete: () => _handleNotificacaoRemove(
                      context,
                      notificacao,
                    ),
                  );
                },
                childCount: viewModel.notificacoesLidas.length,
              ),
            ),
          ],

          // Padding bottom
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  // === Actions ===

  void _handleMenuAction(BuildContext context, String action) {
    final viewModel = context.read<NotificacoesViewModel>();

    switch (action) {
      case 'marcar_todas_lidas':
        _marcarTodasComoLidas(context, viewModel);
        break;
    }
  }

  Future<void> _marcarTodasComoLidas(
    BuildContext context,
    NotificacoesViewModel viewModel,
  ) async {
    final success = await viewModel.marcarTodasComoLidas();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Todas as notificações foram marcadas como lidas'
                : 'Erro ao marcar notificações como lidas',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _handleNotificacaoTap(
    BuildContext context,
    dynamic notificacao,
  ) async {
    final viewModel = context.read<NotificacoesViewModel>();
    final navData = await viewModel.onNotificacaoTap(notificacao);

    if (context.mounted && navData != null) {
      // Navega baseado no tipo de notificação
      final type = navData['type'] as String?;
      final id = navData['id'] as String?;
      final dados = navData['dados'] as Map<String, dynamic>?;

      if (type == 'ticket' && id != null) {
        // Navegar para ticket
        context.push('/suporte/ticket/$id');
      } else if (type == 'discussao' && id != null) {
        // Navegar para discussão
        final cursoId = dados?['cursoId'] as String?;
        if (cursoId != null) {
          context.push('/ead/curso/$cursoId/discussoes/$id');
        }
      }
    }
  }

  Future<void> _handleMarkAsRead(
    BuildContext context,
    dynamic notificacao,
  ) async {
    final viewModel = context.read<NotificacoesViewModel>();
    final success = await viewModel.marcarComoLida(notificacao);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Notificação marcada como lida'
                : 'Erro ao marcar notificação como lida',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleNotificacaoRemove(
    BuildContext context,
    dynamic notificacao,
  ) async {
    // Confirmar antes de deletar
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir notificação'),
        content: const Text(
          'Tem certeza que deseja excluir esta notificação? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final viewModel = context.read<NotificacoesViewModel>();
    final success = await viewModel.removerNotificacao(notificacao);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Notificação removida'
                : 'Não é possível remover esta notificação',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

