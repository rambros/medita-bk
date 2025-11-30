import 'package:flutter/material.dart';

/// Widget de navegacao entre topicos
class NavegacaoTopicosWidget extends StatelessWidget {
  const NavegacaoTopicosWidget({
    super.key,
    required this.hasAnterior,
    required this.hasProximo,
    required this.onAnterior,
    required this.onProximo,
    this.textoProgresso,
  });

  final bool hasAnterior;
  final bool hasProximo;
  final VoidCallback onAnterior;
  final VoidCallback onProximo;
  final String? textoProgresso;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botao anterior
            Expanded(
              child: hasAnterior
                  ? OutlinedButton.icon(
                      onPressed: onAnterior,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('Anterior'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Indicador de progresso
            if (textoProgresso != null) ...[
              const SizedBox(width: 16),
              Text(
                textoProgresso!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 16),
            ],

            // Botao proximo
            Expanded(
              child: hasProximo
                  ? ElevatedButton.icon(
                      onPressed: onProximo,
                      icon: const Text('Proximo'),
                      label: const Icon(Icons.arrow_forward, size: 18),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text('Fim do curso'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botao compacto para navegacao
class NavegacaoCompactaWidget extends StatelessWidget {
  const NavegacaoCompactaWidget({
    super.key,
    required this.hasAnterior,
    required this.hasProximo,
    required this.onAnterior,
    required this.onProximo,
  });

  final bool hasAnterior;
  final bool hasProximo;
  final VoidCallback onAnterior;
  final VoidCallback onProximo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: hasAnterior ? onAnterior : null,
          icon: const Icon(Icons.skip_previous),
          tooltip: 'Topico anterior',
        ),
        IconButton(
          onPressed: hasProximo ? onProximo : null,
          icon: const Icon(Icons.skip_next),
          tooltip: 'Proximo topico',
        ),
      ],
    );
  }
}
