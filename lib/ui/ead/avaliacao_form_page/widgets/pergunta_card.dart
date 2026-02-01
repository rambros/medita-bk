import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';
import '../../../../ui/core/theme/app_theme.dart';
import 'emoji_scale_selector.dart';
import 'multipla_escolha_selector.dart';
import 'texto_longo_input.dart';

/// Card que renderiza uma pergunta de avaliação
class PerguntaCard extends StatelessWidget {
  final PerguntaAvaliacaoModel pergunta;
  final dynamic valorAtual;
  final Function(dynamic) onChanged;
  final int numero;

  const PerguntaCard({
    super.key,
    required this.pergunta,
    this.valorAtual,
    required this.onChanged,
    required this.numero,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho da pergunta
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Número
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$numero',
                      style: TextStyle(
                        color: appTheme.info,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Texto da pergunta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pergunta.texto,
                        style: appTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: appTheme.primaryText,
                        ),
                      ),
                      if (pergunta.obrigatoria)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: appTheme.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Obrigatória',
                                style: appTheme.bodySmall.copyWith(
                                  color: appTheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Widget de entrada baseado no tipo
            _buildInputWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidget(BuildContext context) {
    switch (pergunta.tipo) {
      case TipoPerguntaAvaliacao.emojiScale:
        return EmojiScaleSelector(
          valorSelecionado: valorAtual is int ? valorAtual : null,
          onChanged: onChanged,
          obrigatoria: pergunta.obrigatoria,
        );

      case TipoPerguntaAvaliacao.multiplaEscolha:
        return MultiplaEscolhaSelector(
          opcoes: pergunta.opcoes,
          valorSelecionado: valorAtual is String ? valorAtual : null,
          onChanged: onChanged,
          obrigatoria: pergunta.obrigatoria,
        );

      case TipoPerguntaAvaliacao.textoLongo:
        return TextoLongoInput(
          valorInicial: valorAtual is String ? valorAtual : null,
          onChanged: onChanged,
          obrigatoria: pergunta.obrigatoria,
          hintText: 'Digite sua resposta...',
        );
    }
  }
}
