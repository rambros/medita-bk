import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'view_model/delete_account_view_model.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  static String routeName = 'deleteAccountPage';
  static String routePath = 'deleteAccountPage';

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'deleteAccountPage'});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<DeleteAccountViewModel>();

    return Scaffold(
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
              leading: FlutterFlowIconButton(
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
              title: Text(
                'Apagar Conta e Dados',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                      color: FlutterFlowTheme.of(context).info,
                      letterSpacing: 0.0,
                      useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                    ),
              ),
              actions: const [],
              centerTitle: true,
              elevation: 2.0,
            )
          : null,
      body: SafeArea(
        top: true,
        child: Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.8,
                constraints: const BoxConstraints(
                  maxWidth: 570.0,
                ),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.warning_amber,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 120.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 16.0),
                            child: Text(
                              'Atenção',
                              style: FlutterFlowTheme.of(context).headlineLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).headlineLargeFamily,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).headlineLargeIsCustom,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Você realmente quer deletar todos  os dados e remover sua conta dos servidores do MeditaBK?',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                    ),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 6,
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  context.safePop();
                                },
                                text: 'Cancelar',
                                options: FFButtonOptions(
                                  width: 230.0,
                                  height: 50.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                      ),
                                  elevation: 2.0,
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.05),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  var confirmDialogResponse = await showDialog<bool>(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return WebViewAware(
                                            child: AlertDialog(
                                              title: const Text('Confirmação de remoção de conta'),
                                              content: const Text(
                                                  'Você confirma que quer remover todos os seus dados do MeditaBK?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(alertDialogContext, false),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(alertDialogContext, true),
                                                  child: const Text('Confirmar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ) ??
                                      false;
                                  if (confirmDialogResponse) {
                                    await viewModel.deleteAccount(context);
                                  } else {
                                    context.safePop();
                                  }
                                },
                                text: 'Apagar todos os dados e deletar conta',
                                options: FFButtonOptions(
                                  width: MediaQuery.sizeOf(context).width * 0.92,
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
    );
  }
}
