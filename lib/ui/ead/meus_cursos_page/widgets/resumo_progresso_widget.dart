import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../view_model/meus_cursos_view_model.dart';

/// Widget que exibe um resumo do progresso geral do usuário
class ResumoProgressoWidget extends StatelessWidget {
  const ResumoProgressoWidget({
    super.key,
    required this.totalCursos,
    required this.emAndamento,
    required this.concluidos,
  });

  final int totalCursos;
  final int emAndamento;
  final int concluidos;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appTheme.primary,
            appTheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appTheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.school, color: appTheme.info, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meu Progresso',
                      style: appTheme.titleMedium.copyWith(
                        color: appTheme.info,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$totalCursos ${totalCursos == 1 ? 'curso' : 'cursos'} no total',
                      style: appTheme.bodySmall.copyWith(
                        color: appTheme.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.play_circle,
                  label: 'Em andamento',
                  value: emAndamento.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: appTheme.white70,
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle,
                  label: 'Concluídos',
                  value: concluidos.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: appTheme.info, size: 20),
            const SizedBox(width: 8),
            Text(
              value,
              style: appTheme.headlineSmall.copyWith(
                color: appTheme.info,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: appTheme.bodySmall.copyWith(
            color: appTheme.white70,
          ),
        ),
      ],
    );
  }
}

/// Chips de filtro para Meus Cursos
class FiltroChipsWidget extends StatelessWidget {
  const FiltroChipsWidget({
    super.key,
    required this.filtroAtual,
    required this.onFiltroChanged,
    required this.totalEmAndamento,
    required this.totalConcluidos,
    required this.totalPausados,
  });

  final FiltroMeusCursos filtroAtual;
  final Function(FiltroMeusCursos) onFiltroChanged;
  final int totalEmAndamento;
  final int totalConcluidos;
  final int totalPausados;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: FiltroMeusCursos.values.map((filtro) {
          final isSelected = filtro == filtroAtual;
          final count = _getCount(filtro);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              selectedColor: appTheme.primary,
              checkmarkColor: appTheme.info,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filtro.label,
                    style: TextStyle(
                      color: isSelected ? appTheme.info : appTheme.primaryText,
                    ),
                  ),
                  if (count > 0 && filtro != FiltroMeusCursos.todos) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? appTheme.info.withOpacity(0.3)
                            : appTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? appTheme.info : appTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              avatar: Icon(
                filtro.icon,
                size: 18,
                color: isSelected ? appTheme.info : appTheme.primary,
              ),
              onSelected: (_) => onFiltroChanged(filtro),
            ),
          );
        }).toList(),
      ),
    );
  }

  int _getCount(FiltroMeusCursos filtro) {
    switch (filtro) {
      case FiltroMeusCursos.todos:
        return 0;
      case FiltroMeusCursos.emAndamento:
        return totalEmAndamento;
      case FiltroMeusCursos.concluidos:
        return totalConcluidos;
      case FiltroMeusCursos.pausados:
        return totalPausados;
    }
  }
}

/// Widget para exibir quando não há cursos
class EmptyCursosWidget extends StatelessWidget {
  const EmptyCursosWidget({
    super.key,
    required this.mensagem,
    this.onExplorar,
  });

  final String mensagem;
  final VoidCallback? onExplorar;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: appTheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: appTheme.titleMedium.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
            if (onExplorar != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onExplorar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primary,
                  foregroundColor: appTheme.info,
                ),
                icon: const Icon(Icons.explore),
                label: const Text('Explorar cursos'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
