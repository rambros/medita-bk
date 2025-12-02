import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

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
    final appTheme = AppTheme.of(context);

    return IconButton(
      onPressed: isLoading ? null : onToggle,
      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
              ),
            )
          : Icon(
              isCompleto ? Icons.check_circle : Icons.check_circle_outline,
              color: appTheme.primary,
            ),
      tooltip: isCompleto ? 'Marcar como incompleto' : 'Marcar como completo',
    );
  }

  Widget _buildMedium(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return OutlinedButton.icon(
      onPressed: isLoading ? null : onToggle,
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
              ),
            )
          : Icon(
              isCompleto ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
            ),
      label: Text(isCompleto ? 'Concluido' : 'Marcar como concluido'),
      style: OutlinedButton.styleFrom(
        foregroundColor: appTheme.primary,
        side: BorderSide(color: appTheme.primary),
      ),
    );
  }

  Widget _buildLarge(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onToggle,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(appTheme.info),
                ),
              )
            : Icon(
                isCompleto ? Icons.check_circle : Icons.check_circle_outline,
              ),
        label: Text(isCompleto ? 'Concluido!' : 'Marcar como concluido'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: appTheme.primary,
          foregroundColor: appTheme.info,
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
    final appTheme = AppTheme.of(context);

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
                    color: appTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleto ? Icons.check_circle : Icons.school,
                    color: appTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCompleto ? 'Topico concluido!' : 'Concluiu este topico?',
                        style: appTheme.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appTheme.primaryText,
                        ),
                      ),
                      if (progressoCurso != null)
                        Text(
                          'Progresso do curso: ${progressoCurso!.toStringAsFixed(0)}%',
                          style: appTheme.bodySmall.copyWith(
                            color: appTheme.secondaryText,
                          ),
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
