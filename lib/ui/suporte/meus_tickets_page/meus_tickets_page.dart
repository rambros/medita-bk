import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'package:medita_bk/ui/suporte/meus_tickets_page/view_model/meus_tickets_view_model.dart';
import 'package:medita_bk/ui/suporte/meus_tickets_page/widgets/ticket_card.dart';
import 'package:medita_bk/ui/suporte/novo_ticket_page/novo_ticket_page.dart';
import 'package:medita_bk/ui/suporte/ticket_chat_page/ticket_chat_page.dart';

/// Página que lista os tickets de suporte do usuário
class MeusTicketsPage extends StatefulWidget {
  const MeusTicketsPage({super.key});

  static const String routeName = EadRoutes.meusTickets;
  static const String routePath = EadRoutes.meusTicketsPath;

  @override
  State<MeusTicketsPage> createState() => _MeusTicketsPageState();
}

class _MeusTicketsPageState extends State<MeusTicketsPage> {
  late final MeusTicketsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MeusTicketsViewModel();
    _carregarDados();
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

  Future<void> _carregarDados() async {
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      await _viewModel.carregarMeusTickets(usuarioId);
    }
  }

  Future<void> _recarregarDados() async {
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      await _viewModel.refresh(usuarioId);
    }
  }

  Future<void> _navegarParaNovoTicket() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NovoTicketPage(),
      ),
    );
    
    // Se criou com sucesso, recarrega a lista
    if (resultado == true) {
      await _recarregarDados();
    }
  }

  Future<void> _navegarParaChatTicket(String ticketId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketChatPage(ticketId: ticketId),
      ),
    );
    await _recarregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider<MeusTicketsViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Text(
            'Minhas Solicitações',
            style: TextStyle(color: appTheme.info),
          ),
          actions: [
            // Botão de filtro
            PopupMenuButton<FiltroMeusTickets>(
              icon: const Icon(Icons.filter_list),
              onSelected: (filtro) => _viewModel.setFiltro(filtro),
              itemBuilder: (context) => [
                for (final filtro in FiltroMeusTickets.values)
                  PopupMenuItem(
                    value: filtro,
                    child: Row(
                      children: [
                        Icon(filtro.icon, size: 20),
                        const SizedBox(width: 12),
                        Text(filtro.label),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Consumer<MeusTicketsViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _recarregarDados,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                        foregroundColor: appTheme.info,
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _recarregarDados,
              child: CustomScrollView(
                slivers: [
                  // Header com estatísticas
                  if (viewModel.hasTickets)
                    SliverToBoxAdapter(
                      child: _buildHeaderStats(viewModel),
                    ),

                  // Filtros
                  SliverToBoxAdapter(
                    child: _buildFiltros(viewModel),
                  ),

                  // Lista de tickets
                  if (viewModel.listaVazia)
                    SliverFillRemaining(
                      child: _buildListaVazia(viewModel),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 80),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final ticket = viewModel.ticketsRecentes[index];
                            return TicketCard(
                              ticket: ticket,
                              onTap: () => _navegarParaChatTicket(ticket.id),
                            );
                          },
                          childCount: viewModel.ticketsRecentes.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _navegarParaNovoTicket,
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          icon: const Icon(Icons.add),
          label: const Text('Nova Solicitação'),
        ),
      ),
    );
  }

  Widget _buildHeaderStats(MeusTicketsViewModel viewModel) {
    final stats = viewModel.getEstatisticas();
    final appTheme = AppTheme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appTheme.primary,
            appTheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo das Solicitações',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total',
                  stats.total.toString(),
                  Icons.confirmation_number,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Abertas',
                  stats.abertos.toString(),
                  Icons.pending,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Resolvidas',
                  stats.resolvidos.toString(),
                  Icons.check_circle,
                ),
              ),
            ],
          ),
          if (stats.urgentes > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    stats.urgentes > 1
                        ? '${stats.urgentes} solicitações urgentes'
                        : '${stats.urgentes} solicitação urgente',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros(MeusTicketsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Filtrar:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: FiltroMeusTickets.values
                    .map((filtro) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(filtro.icon, size: 16),
                                const SizedBox(width: 4),
                                Text(filtro.label),
                              ],
                            ),
                            selected: viewModel.filtroAtual == filtro,
                            onSelected: (selected) {
                              if (selected) {
                                viewModel.setFiltro(filtro);
                              }
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaVazia(MeusTicketsViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.mensagemListaVazia,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navegarParaNovoTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primary,
                foregroundColor: appTheme.info,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Criar Primeira Solicitação'),
            ),
          ],
        ),
      ),
    );
  }
}
