import 'package:flutter/material.dart';

/// Botao para marcar/desmarcar um topico como completo
class MarkCompleteButton extends StatelessWidget {
  const MarkCompleteButton({
    super.key,
    required this.isCompleto,
    required this.isLoading,
    required this.onToggle,
    this.size = MarkCompleteButtonSize.medium,
  });

  final bool isCompleto;
  final bool isLoading;
  final VoidCallback onToggle;
  final MarkCompleteButtonSize size;

  @override
  Widget build(BuildContext context) {
    switch (size) {
      case MarkCompleteButtonSize.small:
        return _buildSmall(context);
      case MarkCompleteButtonSize.medium:
        return _buildMedium(context);
      case MarkCompleteButtonSize.large:
        return _buildLarge(context);
    }
  }

  Widget _buildSmall(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onToggle,
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              isCompleto ? Icons.check_circle : Icons.check_circle_outline,
              color: isCompleto ? Colors.green : null,
            ),
      tooltip: isCompleto ? 'Marcar como incompleto' : 'Marcar como completo',
    );
  }

  Widget _buildMedium(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onToggle,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              isCompleto ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
            ),
      label: Text(isCompleto ? 'Concluido' : 'Marcar como concluido'),
      style: OutlinedButton.styleFrom(
        foregroundColor: isCompleto ? Colors.green : null,
        side: BorderSide(
          color: isCompleto ? Colors.green : Theme.of(context).dividerColor,
        ),
      ),
    );
  }

  Widget _buildLarge(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onToggle,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                isCompleto ? Icons.check_circle : Icons.check_circle_outline,
              ),
        label: Text(isCompleto ? 'Concluido!' : 'Marcar como concluido'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isCompleto ? Colors.green : null,
        ),
      ),
    );
  }
}

enum MarkCompleteButtonSize { small, medium, large }

/// Card com informacao de conclusao e botao
class CompletionCard extends StatelessWidget {
  const CompletionCard({
    super.key,
    required this.isCompleto,
    required this.isLoading,
    required this.onToggle,
    this.progressoCurso,
  });

  final bool isCompleto;
  final bool isLoading;
  final VoidCallback onToggle;
  final double? progressoCurso;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleto
                        ? Colors.green.withOpacity(0.1)
                        : theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleto ? Icons.check_circle : Icons.school,
                    color: isCompleto ? Colors.green : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCompleto ? 'Topico concluido!' : 'Concluiu este topico?',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (progressoCurso != null)
                        Text(
                          'Progresso do curso: ${progressoCurso!.toStringAsFixed(0)}%',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MarkCompleteButton(
              isCompleto: isCompleto,
              isLoading: isLoading,
              onToggle: onToggle,
              size: MarkCompleteButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }
}
