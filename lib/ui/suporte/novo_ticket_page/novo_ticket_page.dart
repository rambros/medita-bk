import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/data/repositories/auth_repository.dart';
import 'package:medita_bk/data/models/firebase/user_model.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/domain/models/ead/index.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'package:medita_bk/ui/suporte/novo_ticket_page/view_model/novo_ticket_view_model.dart';

/// Página para criar um novo ticket de suporte
class NovoTicketPage extends StatefulWidget {
  const NovoTicketPage({super.key});

  static const String routeName = EadRoutes.novoTicket;
  static const String routePath = EadRoutes.novoTicketPath;

  @override
  State<NovoTicketPage> createState() => _NovoTicketPageState();
}

class _NovoTicketPageState extends State<NovoTicketPage> {
  late final NovoTicketViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = NovoTicketViewModel();
    _carregarCursos();
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

  Future<void> _carregarCursos() async {
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      await _viewModel.carregarCursos(usuarioId);
    }
  }

  Future<void> _criarTicket() async {
    if (_formKey.currentState?.validate() ?? false) {
      final usuarioId = _usuarioId;
      final usuario = _usuario;

      if (usuarioId == null || usuario == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: usuário não autenticado')),
        );
        return;
      }

      final ticketId = await _viewModel.criarTicket(
        usuarioId: usuarioId,
        usuarioNome: usuario.displayName.isNotEmpty ? usuario.displayName : 'Usuário',
        usuarioEmail: usuario.email,
      );

      if (!mounted) return;

      if (ticketId != null) {
        // Sucesso - volta para lista e mostra mensagem
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitação criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true); // Retorna true para indicar sucesso
      } else {
        // Erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.error ?? 'Erro ao criar solicitação'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider<NovoTicketViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Text(
            'Nova Solicitação',
            style: TextStyle(color: appTheme.info),
          ),
          actions: [
            // Botão de ajuda
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () => _mostrarAjuda(),
            ),
          ],
        ),
        body: Consumer<NovoTicketViewModel>(
          builder: (context, viewModel, _) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header informativo
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Categoria
                  _buildCategoriaSection(viewModel),
                  const SizedBox(height: 24),

                  // Título
                  _buildTituloField(viewModel),
                  const SizedBox(height: 16),

                  // Descrição
                  _buildDescricaoField(viewModel),
                  const SizedBox(height: 24),

                  // Curso (opcional)
                  _buildCursoSection(viewModel),
                  const SizedBox(height: 32),

                  // Botão de criar
                  _buildCriarButton(viewModel),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appTheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent,
            size: 40,
            color: appTheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Como podemos ajudar?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: appTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nossa equipe responderá em breve',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaSection(NovoTicketViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoria do problema *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: CategoriaTicket.values.map((categoria) {
            final isSelected = viewModel.categoriaSelecionada == categoria;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    categoria.icon,
                    size: 18,
                    color: isSelected ? Colors.white : categoria.color,
                  ),
                  const SizedBox(width: 6),
                  Text(categoria.label),
                ],
              ),
              selected: isSelected,
              selectedColor: categoria.color,
              backgroundColor: categoria.color.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  viewModel.setCategoria(categoria);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTituloField(NovoTicketViewModel viewModel) {
    return TextFormField(
      controller: viewModel.tituloController,
      decoration: InputDecoration(
        labelText: 'Título *',
        hintText: 'Resuma o problema em poucas palavras',
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        helperText: 'Mínimo 5 caracteres',
      ),
      maxLength: 100,
      validator: viewModel.validarTitulo,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildDescricaoField(NovoTicketViewModel viewModel) {
    return TextFormField(
      controller: viewModel.descricaoController,
      decoration: InputDecoration(
        labelText: 'Descrição do problema *',
        hintText: 'Descreva detalhadamente o que está acontecendo...',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Icon(Icons.description),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        helperText: 'Mínimo 20 caracteres. Seja específico.',
      ),
      maxLines: 5,
      maxLength: 500,
      validator: viewModel.validarDescricao,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildCursoSection(NovoTicketViewModel viewModel) {
    if (viewModel.isLoadingCursos) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (viewModel.cursosDisponiveis.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Esta solicitação é sobre algum curso? (opcional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: viewModel.cursoSelecionadoId,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.school),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: 'Selecione um curso',
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Nenhum curso específico'),
            ),
            ...viewModel.cursosDisponiveis.map((curso) {
              return DropdownMenuItem<String>(
                value: curso.id,
                child: Text(
                  curso.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: (value) => viewModel.setCurso(value),
        ),
      ],
    );
  }

  Widget _buildCriarButton(NovoTicketViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: viewModel.isCriando ? null : _criarTicket,
        icon: viewModel.isCriando
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(appTheme.info),
                ),
              )
            : const Icon(Icons.send),
        label: Text(
          viewModel.isCriando ? 'Criando solicitação...' : 'Criar Solicitação',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _mostrarAjuda() {
    final appTheme = AppTheme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: appTheme.primary),
            const SizedBox(width: 8),
            const Text('Dicas para criar uma boa solicitação'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✓ Seja específico no título',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Exemplo: "Não consigo acessar a aula 3 do curso X"'),
              SizedBox(height: 12),
              Text(
                '✓ Descreva o problema em detalhes',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Inclua o que você estava fazendo quando o erro ocorreu'),
              SizedBox(height: 12),
              Text(
                '✓ Escolha a categoria correta',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Isso ajuda a equipe a resolver mais rápido'),
              SizedBox(height: 12),
              Text(
                '✓ Informe o curso se aplicável',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Facilita a identificação do problema'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: appTheme.primary),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
