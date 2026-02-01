import 'package:flutter/material.dart';

/// Widget para seleção de emoji em escala de 1 a 5
class EmojiScaleSelector extends StatelessWidget {
  final int? valorSelecionado;
  final Function(int) onChanged;
  final bool obrigatoria;

  const EmojiScaleSelector({super.key, this.valorSelecionado, required this.onChanged, this.obrigatoria = false});

  static const Map<int, String> _emojis = {1: '😢', 2: '😕', 3: '😐', 4: '🙂', 5: '😄'};

  static const Map<int, String> _labels = {1: 'Muito Ruim', 2: 'Ruim', 3: 'Regular', 4: 'Bom', 5: 'Excelente'};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emojis
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [for (int i = 1; i <= 5; i++) _buildEmojiButton(context, i)],
        ),

        const SizedBox(height: 12),

        // Labels
        if (valorSelecionado != null)
          Text(
            _labels[valorSelecionado] ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }

  Widget _buildEmojiButton(BuildContext context, int valor) {
    final isSelected = valorSelecionado == valor;

    return GestureDetector(
      onTap: () => onChanged(valor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 70 : 60,
        height: isSelected ? 70 : 60,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(_emojis[valor] ?? '', style: TextStyle(fontSize: isSelected ? 36 : 32)),
        ),
      ),
    );
  }
}
