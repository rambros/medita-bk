import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';

/// Página inicial do módulo EAD
class EadHomePage extends StatelessWidget {
  const EadHomePage({super.key});

  static const String routeName = EadRoutes.eadHome;
  static const String routePath = EadRoutes.eadHomePath;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.info,
        elevation: 2.0,
        title: Text(
          'EAD',
          style: appTheme.headlineMedium.copyWith(
            color: appTheme.info,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildMenuGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao EAD',
              style: appTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Continue seus estudos ou explore novos cursos para expandir seu conhecimento.',
              style: appTheme.bodyMedium.copyWith(
                color: appTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _MenuCard(
          icon: Icons.school_outlined,
          title: 'Meus Cursos',
          onTap: () {
            context.pushNamed(EadRoutes.meusCursos);
          },
        ),
        _MenuCard(
          icon: Icons.search,
          title: 'Catálogo de Cursos',
          onTap: () {
            context.pushNamed(EadRoutes.catalogoCursos);
          },
        ),
        _MenuCard(
          icon: Icons.support_agent,
          title: 'Suporte Técnico',
          onTap: () {
            context.pushNamed(EadRoutes.meusTickets);
          },
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: appTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: appTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appTheme.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
