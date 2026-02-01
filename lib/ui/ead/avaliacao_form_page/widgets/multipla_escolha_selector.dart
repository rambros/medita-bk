import 'package:flutter/material.dart';

/// Widget para seleção de múltipla escolha (radio buttons)
class MultiplaEscolhaSelector extends StatelessWidget {
  final List<String>? opcoes;
  final String? valorSelecionado;
  final Function(String) onChanged;
  final bool obrigatoria;

  const MultiplaEscolhaSelector({
    super.key,
    required this.opcoes,
    this.valorSelecionado,
    required this.onChanged,
    this.obrigatoria = false,
  });

  @override
  Widget build(BuildContext context) {
    // Se não há opções, mostrar mensagem de erro
    if (opcoes == null || opcoes!.isEmpty) {
      return Text(
        'Erro: Nenhuma opção disponível',
        style: TextStyle(color: Colors.red.shade600),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < opcoes!.length; i++) ...[
          _buildOpcao(context, opcoes![i]),
          if (i < opcoes!.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildOpcao(BuildContext context, String opcao) {
    final isSelected = valorSelecionado == opcao;

    return InkWell(
      onTap: () => onChanged(opcao),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button customizado
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            // Texto da opção
            Expanded(
              child: Text(
                opcao,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
