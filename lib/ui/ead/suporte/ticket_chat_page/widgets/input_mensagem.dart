import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget de input para enviar mensagens no chat
class InputMensagem extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnviando;
  final bool ticketFechado;

  const InputMensagem({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnviando = false,
    this.ticketFechado = false,
  });

  @override
  Widget build(BuildContext context) {
    if (ticketFechado) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          border: Border(
            top: BorderSide(color: Colors.orange.shade200),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Este ticket está fechado. Não é possível enviar mensagens.',
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Campo de texto
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  enabled: !isEnviando,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Botão de enviar
            Builder(
              builder: (context) {
                final appTheme = AppTheme.of(context);
                return Container(
                  decoration: BoxDecoration(
                    color: appTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: isEnviando
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(appTheme.info),
                            ),
                          )
                        : Icon(Icons.send, color: appTheme.info),
                    onPressed: isEnviando ? null : _handleSend,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend() {
    if (controller.text.trim().isNotEmpty && !isEnviando) {
      onSend();
    }
  }
}
