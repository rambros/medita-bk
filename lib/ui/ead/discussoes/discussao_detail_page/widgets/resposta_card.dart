import 'package:flutter/material.dart';

import 'package:medita_bk/domain/models/ead/index.dart';

/// Card de resposta da discussão
class RespostaCard extends StatelessWidget {
  final RespostaDiscussaoModel resposta;
  final String usuarioId;
  final bool podeMarcarSolucao;
  final VoidCallback onLike;
  final VoidCallback? onMarcarSolucao;

  const RespostaCard({
    super.key,
    required this.resposta,
    required this.usuarioId,
    required this.podeMarcarSolucao,
    required this.onLike,
    this.onMarcarSolucao,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMinhaResposta = resposta.isMinhaResposta(usuarioId);
    final isLiked = resposta.curtidoPor(usuarioId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: resposta.isSolucao ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: resposta.isSolucao
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de solução
          if (resposta.isSolucao)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Resposta Aceita',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com autor
                _buildHeader(context, isMinhaResposta),

                const SizedBox(height: 12),

                // Conteúdo
                Text(
                  resposta.conteudo,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // Footer com ações
                _buildFooter(context, isLiked, isMinhaResposta),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMinhaResposta) {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 18,
          backgroundColor: resposta.autorTipo.color.withOpacity(0.2),
          backgroundImage: resposta.autorFoto != null
              ? NetworkImage(resposta.autorFoto!)
              : null,
          child: resposta.autorFoto == null
              ? Icon(
                  resposta.autorTipo.icon,
                  size: 20,
                  color: resposta.autorTipo.color,
                )
              : null,
        ),

        const SizedBox(width: 12),

        // Nome e data
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      isMinhaResposta ? 'Você' : resposta.autorNome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (resposta.isRespostaProfissional) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: resposta.autorTipo.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        resposta.autorTipo.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: resposta.autorTipo.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                resposta.tempoDesde,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    bool isLiked,
    bool isMinhaResposta,
  ) {
    return Row(
      children: [
        // Like
        InkWell(
          onTap: onLike,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 18,
                  color: isLiked ? Colors.blue : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  resposta.likes > 0 ? '${resposta.likes}' : 'Útil',
                  style: TextStyle(
                    fontSize: 13,
                    color: isLiked ? Colors.blue : Colors.grey[600],
                    fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Marcar como solução (apenas para autor da discussão)
        if (podeMarcarSolucao && onMarcarSolucao != null && !isMinhaResposta)
          TextButton.icon(
            onPressed: onMarcarSolucao,
            icon: Icon(
              resposta.isSolucao ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
              color: resposta.isSolucao ? Colors.green : Colors.grey[600],
            ),
            label: Text(
              resposta.isSolucao ? 'Solução' : 'Marcar como Solução',
              style: TextStyle(
                fontSize: 12,
                color: resposta.isSolucao ? Colors.green : Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }
}
