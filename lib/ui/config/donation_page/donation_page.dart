import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_animations.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:medita_bk/ui/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_model/donation_view_model.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  static String routeName = 'donationPage';
  static String routePath = 'donationPage';

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'donationPage'});

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 12000.0.ms,
            begin: 0.0,
            end: 0.8,
          ),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonationViewModel()..loadMessage(),
      child: Consumer<DonationViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              appBar: responsiveVisibility(
                context: context,
                tabletLandscape: false,
                desktop: false,
              )
                  ? AppBar(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      automaticallyImplyLeading: false,
                      actions: const [],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Align(
                          alignment: const AlignmentDirectional(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30.0,
                                  borderWidth: 1.0,
                                  buttonSize: 60.0,
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 30.0,
                                  ),
                                  onPressed: () async {
                                    context.pop();
                                  },
                                ),
                                Text(
                                  'Doação para o MeditaBK',
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                        color: FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                      ),
                                ),
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30.0,
                                  borderWidth: 1.0,
                                  buttonSize: 60.0,
                                  icon: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 30.0,
                                  ),
                                  onPressed: () async {
                                    if (Navigator.of(context).canPop()) {
                                      context.pop();
                                    }
                                    context.pushNamed(
                                      MensagensSemanticSearchPage.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: const TransitionInfo(
                                          hasTransition: true,
                                          transitionType: PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      centerTitle: true,
                      elevation: 2.0,
                    )
                  : null,
              body: SafeArea(
                top: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.94,
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.7,
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.94,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.asset(
                                      'assets/images/Shiva-03.jpg',
                                    ).image,
                                  ),
                                ),
                              ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Como contribuir com a Brahma Kumaris e o MeditaBK',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              textScaler: MediaQuery.of(context).textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Acreditando que as coisas do espírito devem ser acessíveis a todos, a Brahma Kumaris oferece suas atividades com base em contribuições voluntárias de pessoas que sentem que receberam benefício pessoal ao participarem de cursos, palestras e outros programas. Neste sentido, mesmos os centros e centros de retiro da Brahma Kumaris são também dirigidos por voluntários.\n\n\nVocê pode fazer uma contribuição financeira para o trabalho nacional da Brahma Kumaris através da internet. Para contribuições,  favor clicar no botão abaixo que leverá você para o site da Brahma Kumaris:\n                ',
                                                    style: GoogleFonts.lato(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                ],
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                    ),
                                              ),
                                              maxLines: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                          child: FFButtonWidget(
                                            onPressed: () {
                                              viewModel.launchDonationSite();
                                            },
                                            text: 'Ir para o site da Brahma Kumaris',
                                            options: FFButtonOptions(
                                              width: MediaQuery.sizeOf(context).width * 0.85,
                                              height: 50.0,
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: FlutterFlowTheme.of(context).primary,
                                              textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                    color: FlutterFlowTheme.of(context).info,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                  ),
                                              elevation: 2.0,
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                              hoverColor: FlutterFlowTheme.of(context).primary,
                                              hoverBorderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 1.0,
                                              ),
                                              hoverTextColor: FlutterFlowTheme.of(context).info,
                                            ),
                                            showLoadingIndicator: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
