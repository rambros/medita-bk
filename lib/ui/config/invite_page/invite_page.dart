import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'view_model/invite_view_model.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  static String routeName = 'invitePage';
  static String routePath = 'invitePage';

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late TextEditingController inviteTextTextController;
  late FocusNode inviteTextFocusNode;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'invitePage'});
    inviteTextTextController = TextEditingController();
    inviteTextFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      inviteTextTextController.text =
          'Olá, estou usando esse Aplicativo de MEDITAÇÃO chamado MeditaBK.\nEle nos ajuda na jornada do autoconhecimento e conexão com o Eu interior, por isso quero recomendar a você.\nBaixe no link a seguir o  App MEDITABK da Brahma Kumaris, é 100% gratuito.';
    });
  }

  @override
  void dispose() {
    inviteTextTextController.dispose();
    inviteTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InviteViewModel(),
      child: Consumer<InviteViewModel>(
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
                        'Convide seus amigos',
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
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 420.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 0.0),
                                child: Text(
                                  'Convide seus amigos e amigas para experimentar este app de reflexões e meditações.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 24.0, 4.0, 24.0),
                                child: TextFormField(
                                  controller: inviteTextTextController,
                                  focusNode: inviteTextFocusNode,
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.sentences,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Texto sugerido (você pode alterá-lo)',
                                    labelStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                          fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                        ),
                                    hintText: 'Leave note here...',
                                    hintStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                          fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 20.0, 24.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                      ),
                                  maxLines: 8,
                                  cursorColor: FlutterFlowTheme.of(context).primaryText,
                                  validator: null,
                                  inputFormatters: [
                                    if (!isAndroid && !isiOS)
                                      TextInputFormatter.withFunction((oldValue, newValue) {
                                        return TextEditingValue(
                                          selection: newValue.selection,
                                          text: newValue.text.toCapitalization(TextCapitalization.sentences),
                                        );
                                      }),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Builder(
                                    builder: (context) => Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                      child: FFButtonWidget(
                                        onPressed: () {
                                          viewModel.shareInvite(context, inviteTextTextController.text);
                                        },
                                        text: 'Convidar amigos',
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
                                  ),
                                ],
                              ),
                            ],
                          ),
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
