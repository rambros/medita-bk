import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/domain/models/ead/index.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'package:medita_bk/ui/suporte/ticket_chat_page/view_model/ticket_chat_view_model.dart';
import 'package:medita_bk/ui/suporte/ticket_chat_page/widgets/mensagem_bubble.dart';
import 'package:medita_bk/ui/suporte/ticket_chat_page/widgets/input_mensagem.dart';

/// Página de chat do ticket (mensagens)
class TicketChatPage extends StatefulWidget {
  final String ticketId;

  const TicketChatPage({
    super.key,
    required this.ticketId,
  });

  static const String routeName = EadRoutes.ticketChat;
  static const String routePath = EadRoutes.ticketChatPath;

  @override
  State<TicketChatPage> createState() => _TicketChatPageState();
}

class _TicketChatPageState extends State<TicketChatPage> {
  late final TicketChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TicketChatViewModel(ticketId: widget.ticketId);
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

  UserModel? get _usuario {
    return context.read<AuthRepository>().currentUser;
  }

  Future<void> _enviarMensagem() async {
    final usuarioId = _usuarioId;
    final usuario = _usuario;

    if (usuarioId == null || usuario == null) return;

    final sucesso = await _viewModel.enviarMensagem(
      usuarioId: usuarioId,
      usuarioNome: usuario.displayName.isNotEmpty ? usuario.displayName : 'Usuário',
    );

    if (!mounted) return;

    if (!sucesso && _viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarDetalhesTicket(TicketModel ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDetalhesBottomSheet(ticket),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider<TicketChatViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Consumer<TicketChatViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.tituloTicket,
                    style: TextStyle(color: appTheme.info),
                  ),
                  if (viewModel.ticket != null)
                    Text(
                      viewModel.ticket!.status.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: appTheme.info.withOpacity(0.8),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            Consumer<TicketChatViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.ticket == null) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _mostrarDetalhesTicket(viewModel.ticket!),
                );
              },
            ),
          ],
        ),
        body: Consumer<TicketChatViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoadingTicket || viewModel.isLoadingMensagens) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null && viewModel.ticket == null) {
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
                      onPressed: () => viewModel.refresh(),
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

            return Column(
              children: [
                // Header com informações do ticket
                if (viewModel.ticket != null) _buildTicketHeader(viewModel.ticket!),

                // Lista de mensagens
                Expanded(
                  child: viewModel.hasMensagens
                      ? ListView.builder(
                          controller: viewModel.scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: viewModel.mensagens.length,
                          itemBuilder: (context, index) {
                            final mensagem = viewModel.mensagens[index];
                            final usuarioId = _usuarioId;
                            return MensagemBubble(
                              mensagem: mensagem,
                              isFromCurrentUser:
                                  mensagem.autorId == usuarioId,
                            );
                          },
                        )
                      : _buildMensagensVazias(),
                ),

                // Input de mensagem
                InputMensagem(
                  controller: viewModel.mensagemController,
                  onSend: _enviarMensagem,
                  isEnviando: viewModel.isEnviando,
                  ticketFechado: viewModel.ticketFechado,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTicketHeader(TicketModel ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          // Ícone da categoria
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ticket.categoria.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              ticket.categoria.icon,
              color: ticket.categoria.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Título e categoria
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.categoria.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: ticket.categoria.color,
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ticket.status.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ticket.status.color.withOpacity(0.3),
              ),
            ),
            child: Text(
              ticket.status.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ticket.status.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensagensVazias() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma mensagem ainda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Envie a primeira mensagem para iniciar a conversa',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalhesBottomSheet(TicketModel ticket) {
    final appTheme = AppTheme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header fixo com handle e botão fechar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
              child: Column(
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Título e botão fechar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detalhes do Ticket',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade600,
                        ),
                        tooltip: 'Fechar',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Conteúdo rolável
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informações
                    _buildDetalheItem('Número', '#${ticket.numero}'),
                    _buildDetalheItem('Título', ticket.titulo),
                    _buildDetalheItem('Categoria', ticket.categoria.label),
                    _buildDetalheItem('Prioridade', ticket.prioridade.label),
                    _buildDetalheItem('Status', ticket.status.label),
                    if (ticket.cursoTitulo != null)
                      _buildDetalheItem('Curso', ticket.cursoTitulo!),
                    _buildDetalheItem('Criado em', ticket.tempoDesde),
                    if (ticket.isAtribuido)
                      _buildDetalheItem('Atribuído a', ticket.atribuidoNome!),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Descrição
                    const Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.descricao,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),

                    const SizedBox(height: 24),

                    // Botão para voltar ao chat
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.primary,
                          foregroundColor: appTheme.info,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.chat),
                        label: const Text(
                          'Voltar ao Chat',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalheItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
