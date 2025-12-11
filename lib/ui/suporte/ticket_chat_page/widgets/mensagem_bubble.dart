import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:medita_bk/domain/models/ead/index.dart';

/// Widget de bubble de mensagem para o chat
class MensagemBubble extends StatelessWidget {
  final TicketMensagemModel mensagem;
  final bool isFromCurrentUser;

  const MensagemBubble({
    super.key,
    required this.mensagem,
    required this.isFromCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isFromCurrentUser ? 60 : 16,
          right: isFromCurrentUser ? 16 : 60,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: isFromCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Nome do autor (apenas para mensagens do suporte)
            if (!isFromCurrentUser)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      mensagem.autorTipo.icon,
                      size: 14,
                      color: mensagem.autorTipo.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      mensagem.autorNome,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: mensagem.autorTipo.color,
                      ),
                    ),
                  ],
                ),
              ),

            // Bubble da mensagem
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isFromCurrentUser
                    ? Colors.blue.shade600
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isFromCurrentUser ? 16 : 4),
                  bottomRight: Radius.circular(isFromCurrentUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conteúdo da mensagem
                  Text(
                    mensagem.conteudo,
                    style: TextStyle(
                      fontSize: 15,
                      color: isFromCurrentUser ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),

                  // Anexos (se houver)
                  if (mensagem.anexos.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...mensagem.anexos.map((anexo) => _buildAnexo(anexo)),
                  ],
                ],
              ),
            ),

            // Horário
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
              child: Text(
                _formatarHorario(mensagem.dataCriacao),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnexo(AnexoModel anexo) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isFromCurrentUser
            ? Colors.white.withOpacity(0.2)
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image,
            size: 16,
            color: isFromCurrentUser ? Colors.white : Colors.black54,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              anexo.nome,
              style: TextStyle(
                fontSize: 13,
                color: isFromCurrentUser ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatarHorario(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) {
      // Hoje - mostra só o horário
      return DateFormat('HH:mm').format(data);
    } else if (diferenca.inDays == 1) {
      // Ontem
      return 'Ontem ${DateFormat('HH:mm').format(data)}';
    } else if (diferenca.inDays < 7) {
      // Esta semana
      return DateFormat('EEE HH:mm', 'pt_BR').format(data);
    } else {
      // Mais de uma semana
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    }
  }
}
