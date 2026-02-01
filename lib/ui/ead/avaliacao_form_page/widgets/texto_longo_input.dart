import 'package:flutter/material.dart';

/// Widget para entrada de texto longo com contador de caracteres
class TextoLongoInput extends StatefulWidget {
  final String? valorInicial;
  final Function(String) onChanged;
  final bool obrigatoria;
  final int maxCaracteres;
  final String? hintText;

  const TextoLongoInput({
    super.key,
    this.valorInicial,
    required this.onChanged,
    this.obrigatoria = false,
    this.maxCaracteres = 500,
    this.hintText,
  });

  @override
  State<TextoLongoInput> createState() => _TextoLongoInputState();
}

class _TextoLongoInputState extends State<TextoLongoInput> {
  late final TextEditingController _controller;
  int _caracteresAtual = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.valorInicial ?? '');
    _caracteresAtual = _controller.text.length;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _caracteresAtual = _controller.text.length;
    });
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final isLimiteProximo = _caracteresAtual > widget.maxCaracteres * 0.9;
    final isLimiteExcedido = _caracteresAtual > widget.maxCaracteres;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de texto
        TextField(
          controller: _controller,
          maxLines: 5,
          maxLength: widget.maxCaracteres,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Digite sua resposta...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            counterText: '', // Esconde contador padrão
            contentPadding: const EdgeInsets.all(16),
          ),
        ),

        const SizedBox(height: 8),

        // Contador customizado
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$_caracteresAtual/${widget.maxCaracteres}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isLimiteExcedido
                    ? Colors.red
                    : isLimiteProximo
                    ? Colors.orange
                    : Colors.grey.shade600,
                fontWeight: isLimiteProximo ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
