import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/ead/index.dart';

/// Card para exibição de um curso inscrito na lista "Meus Cursos"
/// Foco em mostrar progresso e permitir continuação rápida
class MeuCursoCard extends StatelessWidget {
  const MeuCursoCard({
    super.key,
    required this.inscricao,
    this.onTap,
    this.onContinuar,
  });

  final InscricaoCursoModel inscricao;
  final VoidCallback? onTap;
  final VoidCallback? onContinuar;

  double get progresso => inscricao.percentualConcluido;
  bool get isConcluido => inscricao.isConcluido;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com imagem e progresso circular
            _buildHeader(context),

            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    inscricao.cursoTitulo,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Status e último acesso
                  _buildStatusInfo(context),

                  const SizedBox(height: 12),

                  // Barra de progresso
                  _buildProgressBar(context),

                  const SizedBox(height: 12),

                  // Botão de ação
                  _buildActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Imagem de fundo
        AspectRatio(
          aspectRatio: 21 / 9,
          child: inscricao.cursoImagem != null
              ? CachedNetworkImage(
                  imageUrl: inscricao.cursoImagem!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(context),
                  errorWidget: (context, url, error) => _buildPlaceholder(context),
                )
              : _buildPlaceholder(context),
        ),

        // Overlay gradiente
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // Badge de status
        Positioned(
          top: 8,
          left: 8,
          child: _buildStatusBadge(context),
        ),

        // Indicador de progresso circular
        Positioned(
          bottom: 8,
          right: 8,
          child: _buildProgressCircle(context),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.school,
          size: 40,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = inscricao.status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: progresso / 100,
              strokeWidth: 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isConcluido ? Colors.green : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Text(
            '${progresso.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isConcluido ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    final theme = Theme.of(context);
    final ultimoAcesso = inscricao.progresso.ultimoAcesso;

    return Row(
      children: [
        // Tópicos completos
        Icon(
          Icons.check_circle_outline,
          size: 16,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          '${inscricao.topicosCompletos}/${inscricao.totalTopicos} tópicos',
          style: theme.textTheme.bodySmall,
        ),

        const SizedBox(width: 16),

        // Último acesso
        if (ultimoAcesso != null) ...[
          Icon(
            Icons.access_time,
            size: 16,
            color: theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 4),
          Text(
            _formatarUltimoAcesso(ultimoAcesso),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              isConcluido ? 'Concluído!' : '${progresso.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isConcluido ? Colors.green : null,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progresso / 100,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              isConcluido ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final buttonText = inscricao.textoBotaoAcao;
    final icon = _getActionIcon();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onContinuar ?? onTap,
        icon: Icon(icon, size: 20),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: isConcluido
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  IconData _getActionIcon() {
    if (isConcluido) return Icons.replay;
    if (!inscricao.progresso.hasProgresso) return Icons.play_arrow;
    return Icons.play_arrow;
  }

  String _formatarUltimoAcesso(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) {
      if (diferenca.inHours == 0) {
        return 'Agora há pouco';
      }
      return 'Há ${diferenca.inHours}h';
    } else if (diferenca.inDays == 1) {
      return 'Ontem';
    } else if (diferenca.inDays < 7) {
      return 'Há ${diferenca.inDays} dias';
    } else if (diferenca.inDays < 30) {
      final semanas = (diferenca.inDays / 7).floor();
      return 'Há $semanas sem${semanas > 1 ? 'anas' : 'ana'}';
    } else {
      final meses = (diferenca.inDays / 30).floor();
      return 'Há $meses ${meses > 1 ? 'meses' : 'mês'}';
    }
  }
}
