import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

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

    final appTheme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que você vai aprender',
            style: appTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: appTheme.primaryText,
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
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: appTheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: appTheme.bodyMedium.copyWith(
                color: appTheme.primaryText,
              ),
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

    final appTheme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requisitos',
            style: appTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: appTheme.primaryText,
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
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_right,
            size: 20,
            color: appTheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: appTheme.bodyMedium.copyWith(
                color: appTheme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
