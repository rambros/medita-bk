import 'package:flutter/material.dart';

import 'package:medita_b_k/ui/core/theme/app_theme.dart';

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
    final appTheme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: appTheme.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Botao anterior
            Expanded(
              child: hasAnterior
                  ? OutlinedButton.icon(
                      onPressed: onAnterior,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Anterior'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: appTheme.primary,
                        side: BorderSide(color: appTheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: const Size(0, 36),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Indicador de progresso
            if (textoProgresso != null) ...[
              const SizedBox(width: 12),
              Text(
                textoProgresso!,
                style: appTheme.bodySmall.copyWith(
                  color: appTheme.secondaryText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Botao proximo
            Expanded(
              child: hasProximo
                  ? ElevatedButton.icon(
                      onPressed: onProximo,
                      icon: const Text('Próximo'),
                      label: const Icon(Icons.arrow_forward, size: 16),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                        foregroundColor: appTheme.info,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: const Size(0, 36),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: const Text('Fim'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.primary,
                        foregroundColor: appTheme.info,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: const Size(0, 36),
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
    final appTheme = AppTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: hasAnterior ? onAnterior : null,
          icon: Icon(
            Icons.skip_previous,
            color: hasAnterior ? appTheme.primary : appTheme.secondaryText,
          ),
          tooltip: 'Topico anterior',
        ),
        IconButton(
          onPressed: hasProximo ? onProximo : null,
          icon: Icon(
            Icons.skip_next,
            color: hasProximo ? appTheme.primary : appTheme.secondaryText,
          ),
          tooltip: 'Proximo topico',
        ),
      ],
    );
  }
}
