import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget de input para resposta
class InputResposta extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnviando;
  final bool podeResponder;
  final VoidCallback onEnviar;

  const InputResposta({
    super.key,
    required this.controller,
    required this.isEnviando,
    required this.podeResponder,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    if (!podeResponder) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(
            top: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey[500], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Esta discussão foi encerrada',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Campo de texto
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Escreva sua resposta...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => onEnviar(),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Botão de enviar
            Builder(
              builder: (context) {
                final appTheme = AppTheme.of(context);
                return Material(
                  color: appTheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: isEnviando ? null : onEnviar,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: isEnviando
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(appTheme.info),
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: appTheme.info,
                              size: 22,
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
