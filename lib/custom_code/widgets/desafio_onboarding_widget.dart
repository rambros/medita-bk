// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom widgets
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class DesafioOnboardingWidget extends StatefulWidget {
  const DesafioOnboardingWidget(
      {super.key, this.width, this.height, required this.onDone});

  final double? width;
  final double? height;
  final Future Function() onDone;

  @override
  State<DesafioOnboardingWidget> createState() =>
      _DesafioOnboardingWidgetState();
}

class _DesafioOnboardingWidgetState extends State<DesafioOnboardingWidget> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          decoration: const PageDecoration(
            bodyAlignment:
                Alignment.center, // Aligns the body to the topCenter,
          ),
          title: ' ',
          bodyWidget: const InnerBox(
            titulo: '21 dias para criar um hábito',
            descricao:
                '''Nosso objetivo é promover uma rotina de meditação diária para dar início a um estado de bem-estar e equilíbrio que leva a uma sensível melhora da sua saúde de corpo e mente.''',
          ),
        ),
        PageViewModel(
          decoration: const PageDecoration(
            bodyAlignment:
                Alignment.center, // Aligns the body to the topCenter,
          ),
          title: ' ',
          bodyWidget: const InnerBox(
            titulo: 'Conquiste mandalas',
            descricao: '''O Desafio é dividido em 7 etapas de 3 dias.
 A cada dia de meditação concluída, você conquista uma parte da mandala.

Ao concluir 3 dias de meditação, você
 conquista a mandala inteira.
Ao todo, você poderá conquistar 7 mandalas.''',
          ),
        ),
        PageViewModel(
          decoration: const PageDecoration(
            bodyAlignment:
                Alignment.center, // Aligns the body to the topCenter,
          ),
          title: ' ',
          bodyWidget: const InnerBox(
            titulo: 'Ganhe brasões e prêmios',
            descricao:
                '''Além das mandalas, você poderá ganhar brasões que serão revertidos em e-books exclusivos!''',
          ),
        ),
        PageViewModel(
          decoration: const PageDecoration(
            bodyAlignment:
                Alignment.center, // Aligns the body to the topCenter,
          ),
          title: ' ',
          bodyWidget: const InnerBox(
            titulo: 'Compartilhe sua experiência',
            descricao: '''Ao final de cada meditação, você poderá
 conferir o seu progresso e compartilhar suas  conquistas com seus amigos.''',
          ),
        ),
      ],
      globalBackgroundColor: Colors.transparent,
      showNextButton: true,
      showSkipButton: true,
      skip: const Text("Pular"),
      next: const Text("Próxima"),
      done: const Text("Avançar"),
      onDone: () {
        widget.onDone();
      },
      baseBtnStyle: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF9A61A),
      ),
      skipStyle: TextButton.styleFrom(
        foregroundColor: FlutterFlowTheme.of(context).info,
      ),
      doneStyle: TextButton.styleFrom(
        foregroundColor: FlutterFlowTheme.of(context).info,
      ),
      nextStyle: TextButton.styleFrom(
        foregroundColor: FlutterFlowTheme.of(context).info,
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: FlutterFlowTheme.of(context)
            .info, //Theme.of(context).colorScheme.primary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}

class InnerBox extends StatelessWidget {
  const InnerBox({super.key, required this.titulo, required this.descricao});

  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Material(
        color: Colors.transparent,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xCC83193F), Color(0xCBB0373E)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                  child: Text(
                    titulo,
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleLargeFamily,
                          fontSize: 24,
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleLargeFamily),
                        ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 16.0),
                  child: Text(
                    descricao,
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).labelLargeFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelLargeFamily),
                        ),
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
