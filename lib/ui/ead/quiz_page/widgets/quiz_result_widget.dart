import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';

/// Widget que exibe o resultado do quiz
class QuizResultWidget extends StatelessWidget {
  const QuizResultWidget({
    super.key,
    required this.resultado,
    required this.onRevisar,
    required this.onContinuar,
    required this.onRefazer,
  });

  final QuizResultadoModel resultado;
  final VoidCallback onRevisar;
  final VoidCallback onContinuar;
  final VoidCallback onRefazer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aprovado = resultado.aprovado;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Icone de resultado
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: aprovado
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              aprovado ? Icons.emoji_events : Icons.refresh,
              size: 64,
              color: aprovado ? Colors.green : Colors.orange,
            ),
          ),

          const SizedBox(height: 24),

          // Titulo
          Text(
            aprovado ? 'Parabens!' : 'Continue tentando!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: aprovado ? Colors.green : Colors.orange,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitulo
          Text(
            aprovado
                ? 'Voce completou este quiz com sucesso!'
                : 'Voce nao alcancou a nota minima de 70%',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),

          const SizedBox(height: 32),

          // Card com estatisticas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Nota
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sua nota: ',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        resultado.notaFormatada,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: aprovado ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Estatisticas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: 'Acertos',
                        value: resultado.acertos.toString(),
                        color: Colors.green,
                      ),
                      _StatItem(
                        label: 'Erros',
                        value: resultado.erros.toString(),
                        color: Colors.red,
                      ),
                      _StatItem(
                        label: 'Total',
                        value: resultado.totalPerguntas.toString(),
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Barra de progresso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: resultado.percentualAcertos / 100,
                      minHeight: 12,
                      backgroundColor: Colors.red.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${resultado.percentualAcertos.toStringAsFixed(0)}% de acerto',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Botoes de acao
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: aprovado ? onContinuar : onRefazer,
              icon: Icon(aprovado ? Icons.arrow_forward : Icons.refresh),
              label: Text(aprovado ? 'Continuar' : 'Tentar novamente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: aprovado ? Colors.green : theme.colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Botao revisar
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRevisar,
              icon: const Icon(Icons.visibility),
              label: const Text('Revisar respostas'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Indicador de progresso do quiz
class QuizProgressIndicator extends StatelessWidget {
  const QuizProgressIndicator({
    super.key,
    required this.totalPerguntas,
    required this.perguntaAtual,
    required this.respostas,
    this.onPerguntaTap,
  });

  final int totalPerguntas;
  final int perguntaAtual;
  final Map<String, String> respostas;
  final Function(int index)? onPerguntaTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(totalPerguntas, (index) {
          final isAtual = index == perguntaAtual;
          final isRespondida = index < respostas.length;

          return Expanded(
            child: GestureDetector(
              onTap: onPerguntaTap != null ? () => onPerguntaTap!(index) : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 8,
                decoration: BoxDecoration(
                  color: isAtual
                      ? Theme.of(context).colorScheme.primary
                      : isRespondida
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
