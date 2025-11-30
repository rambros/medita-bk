import 'package:flutter/material.dart';

/// Widget que exibe os objetivos do curso
class ObjetivosSection extends StatelessWidget {
  const ObjetivosSection({
    super.key,
    required this.objetivos,
  });

  final List<String> objetivos;

  @override
  Widget build(BuildContext context) {
    if (objetivos.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que você vai aprender',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...objetivos.map((objetivo) => _ObjetivoItem(texto: objetivo)),
        ],
      ),
    );
  }
}

class _ObjetivoItem extends StatelessWidget {
  const _ObjetivoItem({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget que exibe os requisitos do curso
class RequisitosSection extends StatelessWidget {
  const RequisitosSection({
    super.key,
    required this.requisitos,
  });

  final List<String> requisitos;

  @override
  Widget build(BuildContext context) {
    if (requisitos.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requisitos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...requisitos.map((requisito) => _RequisitoItem(texto: requisito)),
        ],
      ),
    );
  }
}

class _RequisitoItem extends StatelessWidget {
  const _RequisitoItem({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_right,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
