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
          'Cursos Online',
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
              'Bem-vindo aos Cursos Online',
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
          gradientColors: const [Color(0xFF7E57C2), Color(0xFFB39DDB)],
          onTap: () {
            context.pushNamed(EadRoutes.meusCursos);
          },
        ),
        _MenuCard(
          icon: Icons.search,
          title: 'Catálogo de Cursos',
          gradientColors: const [Color(0xFFEC407A), Color(0xFFF48FB1)],
          onTap: () {
            context.pushNamed(EadRoutes.catalogoCursos);
          },
        ),
        _MenuCard(
          icon: Icons.support_agent,
          title: 'Suporte Técnico',
          gradientColors: const [Color(0xFF26A69A), Color(0xFF80CBC4)],
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
    required this.gradientColors,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFECCB9E),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: 100.0,
          height: 90.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              stops: const [0.0, 1.0],
              begin: const AlignmentDirectional(-1.0, -1.0),
              end: const AlignmentDirectional(1.0, 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: appTheme.info,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Icon(
                    icon,
                    color: appTheme.secondaryText,
                    size: 24.0,
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: appTheme.bodyLarge.override(
                    fontFamily: appTheme.bodyLargeFamily,
                    color: appTheme.primaryText,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: !appTheme.bodyLargeIsCustom,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
