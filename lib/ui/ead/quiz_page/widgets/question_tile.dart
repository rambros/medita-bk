import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';

/// Widget que exibe uma pergunta do quiz
class QuestionTile extends StatelessWidget {
  const QuestionTile({
    super.key,
    required this.pergunta,
    required this.numeroPergunta,
    required this.totalPerguntas,
    required this.respostaSelecionada,
    required this.onRespostaSelecionada,
    this.mostrarResultado = false,
  });

  final QuizQuestionModel pergunta;
  final int numeroPergunta;
  final int totalPerguntas;
  final String? respostaSelecionada;
  final Function(String opcaoId) onRespostaSelecionada;
  final bool mostrarResultado;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numero da pergunta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Pergunta $numeroPergunta de $totalPerguntas',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Texto da pergunta
          Text(
            pergunta.pergunta,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          // Opcoes
          ...pergunta.opcoes.map((opcao) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OptionTile(
                  opcao: opcao,
                  isSelected: respostaSelecionada == opcao.id,
                  onTap: () => onRespostaSelecionada(opcao.id),
                  mostrarResultado: mostrarResultado,
                ),
              )),

          // Explicacao (apos responder, se disponivel)
          if (mostrarResultado && pergunta.hasExplicacao) ...[
            const SizedBox(height: 16),
            _buildExplicacao(context),
          ],
        ],
      ),
    );
  }

  Widget _buildExplicacao(BuildContext context) {
    final theme = Theme.of(context);
    final acertou = pergunta.isOpcaoCorreta(respostaSelecionada ?? '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: acertou
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: acertou ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                acertou ? Icons.check_circle : Icons.info,
                color: acertou ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                acertou ? 'Correto!' : 'Explicacao',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: acertou ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pergunta.explicacao!,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Widget que exibe uma opcao de resposta
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.opcao,
    required this.isSelected,
    required this.onTap,
    this.mostrarResultado = false,
  });

  final QuizOpcaoModel opcao;
  final bool isSelected;
  final VoidCallback onTap;
  final bool mostrarResultado;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determina as cores baseado no estado
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    if (mostrarResultado) {
      if (opcao.isCorreta) {
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
      } else if (isSelected && !opcao.isCorreta) {
        backgroundColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
      } else {
        backgroundColor = theme.colorScheme.surface;
        borderColor = theme.dividerColor;
        textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
        icon = null;
      }
    } else {
      if (isSelected) {
        backgroundColor = theme.colorScheme.primaryContainer;
        borderColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.onPrimaryContainer;
        icon = Icons.radio_button_checked;
      } else {
        backgroundColor = theme.colorScheme.surface;
        borderColor = theme.dividerColor;
        textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
        icon = Icons.radio_button_unchecked;
      }
    }

    return InkWell(
      onTap: mostrarResultado ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected || mostrarResultado
                    ? borderColor
                    : theme.disabledColor,
                size: 24,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                opcao.texto,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
