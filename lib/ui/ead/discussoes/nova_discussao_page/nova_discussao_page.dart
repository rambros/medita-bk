import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/data/repositories/auth_repository.dart';
import 'package:medita_b_k/routing/ead_routes.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
import 'view_model/nova_discussao_view_model.dart';

/// Página para criar uma nova discussão
class NovaDiscussaoPage extends StatefulWidget {
  final String cursoId;
  final String cursoTitulo;

  const NovaDiscussaoPage({
    super.key,
    required this.cursoId,
    required this.cursoTitulo,
  });

  static const String routeName = EadRoutes.novaDiscussao;
  static const String routePath = EadRoutes.novaDiscussaoPath;

  @override
  State<NovaDiscussaoPage> createState() => _NovaDiscussaoPageState();
}

class _NovaDiscussaoPageState extends State<NovaDiscussaoPage> {
  late final NovaDiscussaoViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = NovaDiscussaoViewModel(
      cursoId: widget.cursoId,
      cursoTitulo: widget.cursoTitulo,
    );
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

  Future<void> _onCriarDiscussao() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioId = _usuarioId;
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para criar uma discussão'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final discussaoId = await _viewModel.criarDiscussao(
      autorId: usuarioId,
      autorNome: _usuarioNome,
    );

    if (!mounted) return;

    if (discussaoId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pergunta criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true); // Retorna sucesso
    } else if (_viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ChangeNotifierProvider<NovaDiscussaoViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          title: Text(
            'Nova Pergunta',
            style: TextStyle(color: appTheme.info),
          ),
        ),
        body: Consumer<NovaDiscussaoViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info do curso
                    _buildCursoInfo(),

                    const SizedBox(height: 24),

                    // Título
                    _buildTituloField(viewModel),

                    const SizedBox(height: 16),

                    // Conteúdo
                    _buildConteudoField(viewModel),

                    const SizedBox(height: 16),

                    // Switch de privado
                    _buildPrivadoSwitch(viewModel),

                    const SizedBox(height: 8),

                    // Dicas
                    _buildDicas(),

                    const SizedBox(height: 24),

                    // Botão de enviar
                    _buildEnviarButton(viewModel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCursoInfo() {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.school, color: appTheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curso',
                  style: TextStyle(
                    fontSize: 12,
                    color: appTheme.primary,
                  ),
                ),
                Text(
                  widget.cursoTitulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTituloField(NovaDiscussaoViewModel viewModel) {
    return TextFormField(
      controller: viewModel.tituloController,
      validator: viewModel.validarTitulo,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 200,
      decoration: const InputDecoration(
        labelText: 'Título da pergunta *',
        hintText: 'Ex: Como faço para...',
        prefixIcon: Icon(Icons.title),
        border: OutlineInputBorder(),
        helperText: 'Seja claro e objetivo no título',
      ),
    );
  }

  Widget _buildConteudoField(NovaDiscussaoViewModel viewModel) {
    return TextFormField(
      controller: viewModel.conteudoController,
      validator: viewModel.validarConteudo,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 6,
      minLines: 4,
      decoration: const InputDecoration(
        labelText: 'Descrição *',
        hintText: 'Descreva sua dúvida com detalhes...',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
        helperText: 'Quanto mais detalhes, melhor será a resposta',
      ),
    );
  }

  Widget _buildPrivadoSwitch(NovaDiscussaoViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            viewModel.isPrivada ? Icons.lock : Icons.public,
            color: viewModel.isPrivada ? Colors.orange : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.isPrivada ? 'Pergunta Privada' : 'Pergunta Pública',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  viewModel.isPrivada
                      ? 'Apenas você e os professores podem ver'
                      : 'Todos os alunos do curso podem ver',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: viewModel.isPrivada,
            onChanged: viewModel.setPrivada,
          ),
        ],
      ),
    );
  }

  Widget _buildDicas() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Dicas para uma boa pergunta',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Seja específico sobre sua dúvida\n'
            '• Mencione a aula ou tópico relacionado\n'
            '• Descreva o que você já tentou\n'
            '• Evite perguntas muito amplas',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnviarButton(NovaDiscussaoViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: viewModel.isCriando ? null : _onCriarDiscussao,
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
          viewModel.isCriando ? 'Enviando...' : 'Publicar Pergunta',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
