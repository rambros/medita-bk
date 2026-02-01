import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/app_theme.dart';
import 'view_model/avaliacao_form_view_model.dart';
import 'widgets/pergunta_card.dart';

/// Página de formulário de avaliação para o aluno
class AvaliacaoFormPage extends StatelessWidget {
  final String inscricaoId;

  const AvaliacaoFormPage({super.key, required this.inscricaoId});

  static const String routeName = 'avaliacaoForm';
  static const String routePath = 'ead/avaliacao/:inscricaoId';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvaliacaoFormViewModel(inscricaoId: inscricaoId),
      child: const _AvaliacaoFormContent(),
    );
  }
}

class _AvaliacaoFormContent extends StatelessWidget {
  const _AvaliacaoFormContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AvaliacaoFormViewModel>();
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('Avaliação do Curso'),
        elevation: 0,
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.info,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.error != null
          ? _buildError(context, viewModel)
          : _buildForm(context, viewModel),
    );
  }

  Widget _buildError(BuildContext context, AvaliacaoFormViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar avaliação',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.error ?? 'Erro desconhecido',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: viewModel.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AvaliacaoFormViewModel viewModel) {
    final avaliacao = viewModel.avaliacao;
    if (avaliacao == null) {
      return const Center(child: Text('Avaliação não encontrada'));
    }

    return Column(
      children: [
        // Cabeçalho com progresso
        _buildHeader(context, viewModel, avaliacao),

        // Lista de perguntas
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.perguntas.length,
            itemBuilder: (context, index) {
              final pergunta = viewModel.perguntas[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PerguntaCard(
                  pergunta: pergunta,
                  valorAtual: viewModel.getResposta(pergunta.id),
                  onChanged: (valor) => viewModel.setResposta(pergunta.id, valor),
                  numero: index + 1,
                ),
              );
            },
          ),
        ),

        // Botão de enviar
        _buildSubmitButton(context, viewModel),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AvaliacaoFormViewModel viewModel, avaliacao) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e descrição
          Text(
            avaliacao.titulo,
            style: appTheme.titleLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            avaliacao.descricao,
            style: appTheme.bodyMedium.copyWith(color: appTheme.secondaryText),
          ),

          const SizedBox(height: 16),

          // Barra de progresso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${viewModel.progresso.toStringAsFixed(0)}% respondido',
                    style: appTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appTheme.primary,
                    ),
                  ),
                  Text(
                    '${viewModel.perguntas.length} perguntas',
                    style: appTheme.bodySmall.copyWith(color: appTheme.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: viewModel.progresso / 100,
                  minHeight: 8,
                  backgroundColor: appTheme.accent4,
                  valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, AvaliacaoFormViewModel viewModel) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: viewModel.isSaving || !viewModel.podeSubmeter ? null : () => _handleSubmit(context, viewModel),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.primary,
              foregroundColor: appTheme.info,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: viewModel.isSaving
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(appTheme.info),
                    ),
                  )
                : Text(
                    'ENVIAR AVALIAÇÃO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appTheme.info,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context, AvaliacaoFormViewModel viewModel) async {
    // Pegar dados do usuário atual
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro: Usuário não autenticado'), backgroundColor: Colors.red));
      return;
    }

    // Submeter
    final sucesso = await viewModel.submeter(
      usuarioId: user.uid,
      usuarioNome: user.displayName ?? 'Usuário',
      usuarioEmail: user.email ?? '',
    );

    if (!context.mounted) return;

    if (sucesso) {
      // Mostrar sucesso e voltar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Avaliação enviada com sucesso!'), backgroundColor: Colors.green));

      // Aguardar um pouco para mostrar o snackbar
      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        Navigator.of(context).pop(true); // Retorna true indicando sucesso
      }
    } else {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.error ?? 'Erro ao enviar avaliação'), backgroundColor: Colors.red),
      );
    }
  }
}
