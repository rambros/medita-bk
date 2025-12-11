import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'view_model/settings_view_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static String routeName = 'SettingsPage';
  static String routePath = 'settingsPage';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SettingsPage'});
    // Initialize ViewModel
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();

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
                'Configurações',
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
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                value: viewModel.isDarkMode,
                onChanged: (newValue) async {
                  viewModel.toggleDarkMode(context, newValue);
                },
                title: Text(
                  'Tema escuro',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        lineHeight: 2.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                      ),
                ),
                tileColor: FlutterFlowTheme.of(context).primaryBackground,
                activeColor: FlutterFlowTheme.of(context).primary,
                activeTrackColor: FlutterFlowTheme.of(context).accent1,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                value: viewModel.receiveNotifications,
                onChanged: (newValue) async {
                  viewModel.toggleNotifications(newValue);
                },
                title: Text(
                  'Notificações no celular',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        lineHeight: 2.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                      ),
                ),
                subtitle: Text(
                  'Receba em seu celular notificações sobre atualizações do conteúdo .',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: const Color(0xFF8B97A2),
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
                tileColor: FlutterFlowTheme.of(context).primaryBackground,
                activeColor: FlutterFlowTheme.of(context).primary,
                activeTrackColor: FlutterFlowTheme.of(context).accent1,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: SwitchListTile.adaptive(
                value: viewModel.receiveEmails,
                onChanged: (newValue) async {
                  viewModel.toggleEmails(newValue);
                },
                title: Text(
                  'Notificações por email',
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        lineHeight: 2.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                      ),
                ),
                subtitle: Text(
                  'Receba notificações por email sobre as atualizações de conteúdo do app.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: const Color(0xFF8B97A2),
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
                tileColor: FlutterFlowTheme.of(context).primaryBackground,
                activeColor: FlutterFlowTheme.of(context).primary,
                activeTrackColor: FlutterFlowTheme.of(context).accent1,
                dense: false,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 32.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deletar meditações baixadas',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      var confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return WebViewAware(
                                child: AlertDialog(
                                  title: const Text('Deleção de meditações'),
                                  content: const Text(
                                      'Se você precisar de espaço no celular pode deletar todas as meditações que você baixou.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(alertDialogContext, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(alertDialogContext, true),
                                      child: const Text('Deletar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ) ??
                          false;
                      if (confirmDialogResponse) {
                        await viewModel.deleteDownloads(context);
                      }
                    },
                    child: Icon(
                      Icons.delete,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 32.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 32.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Versão: ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                  Text(
                    viewModel.appVersion,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
