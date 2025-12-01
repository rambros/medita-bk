import 'package:flutter/material.dart';
import '/ui/core/flutter_flow/flutter_flow_animations.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/pages.dart';
import '/routing/ead_routes.dart';
import 'navigation_card.dart';

/// Grid of navigation cards for home page
class NavigationGrid extends StatelessWidget {
  final Map<String, AnimationInfo> animationsMap;

  const NavigationGrid({
    super.key,
    required this.animationsMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
      child: GridView(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          // Meditation card
          NavigationCard(
            title: 'Fazer uma meditação',
            icon: Icons.filter_vintage,
            gradientColors: const [Color(0xFFEC407A), Color(0xFFF48FB1)],
            gradientStops: const [0.0, 1.0],
            gradientBegin: const AlignmentDirectional(-1.0, -1.0),
            gradientEnd: const AlignmentDirectional(1.0, 1.0),
            onTap: () {
              context.pushNamed(
                MeditationListPage.routeName,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.leftToRight,
                  ),
                },
              );
            },
            animation: animationsMap['containerOnPageLoadAnimation2'],
          ),

          // EAD/Cursos card
          NavigationCard(
            title: 'Aprender com cursos',
            icon: Icons.school,
            gradientColors: const [Color(0xFF7E57C2), Color(0xFFB39DDB)],
            gradientStops: const [0.0, 1.0],
            gradientBegin: const AlignmentDirectional(-1.0, 1.0),
            gradientEnd: const AlignmentDirectional(1.0, -1.0),
            onTap: () {
              context.pushNamed(
                EadRoutes.eadHome,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.leftToRight,
                  ),
                },
              );
            },
            animation: animationsMap['containerOnPageLoadAnimation3'],
          ),

          // Agenda card
          NavigationCard(
            title: 'Ver agenda de atividades',
            icon: Icons.calendar_today,
            gradientColors: const [Colors.red, Color(0xFFEF9A9A)],
            gradientStops: const [0.0, 1.0],
            gradientBegin: const AlignmentDirectional(1.0, -1.0),
            gradientEnd: const AlignmentDirectional(-1.0, 1.0),
            onTap: () {
              context.pushNamed(
                AgendaListPage.routeName,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.leftToRight,
                  ),
                },
              );
            },
            animation: animationsMap['containerOnPageLoadAnimation4'],
          ),

          // Daily message card
          NavigationCard(
            title: 'Ler mensagem para o dia',
            icon: FFIcons.kselfImprovementBlack24dp,
            gradientColors: const [Color(0xFFFFA726), Color(0xFFFFCC80)],
            gradientStops: const [0.0, 1.0],
            gradientBegin: const AlignmentDirectional(-1.0, 1.0),
            gradientEnd: const AlignmentDirectional(1.0, -1.0),
            onTap: () {
              context.pushNamed(
                MensagemDetailsPage.routeName,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.leftToRight,
                  ),
                },
              );
            },
            animation: animationsMap['containerOnPageLoadAnimation5'],
          ),

          // Support card
          NavigationCard(
            title: 'Ajude-nos a melhorar o app',
            icon: Icons.thumb_up_alt,
            gradientColors: const [Color(0xFFF9A825), Color(0xFFFFEE58)],
            gradientStops: const [0.0, 1.0],
            gradientBegin: const AlignmentDirectional(1.0, 1.0),
            gradientEnd: const AlignmentDirectional(-1.0, -1.0),
            onTap: () {
              context.pushNamed(
                SupportPage.routeName,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                    duration: Duration(milliseconds: 0),
                  ),
                },
              );
            },
            animation: animationsMap['containerOnPageLoadAnimation6'],
          ),
        ],
      ),
    );
  }
}
