import 'package:medita_bk/core/structs/index.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/core/utils/media/audio_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'view_model/selectinstrument_page_view_model.dart';

class SelectinstrumentPage extends StatefulWidget {
  const SelectinstrumentPage({super.key});

  static String routeName = 'selectinstrumentPage';
  static String routePath = 'selectInstrumentPage';

  @override
  State<SelectinstrumentPage> createState() => _SelectinstrumentPageState();
}

class _SelectinstrumentPageState extends State<SelectinstrumentPage> {
  late SelectinstrumentPageViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = SelectinstrumentPageViewModel()..init(context);

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'selectinstrumentPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.listSounds = await AudioUtils.getInstrumentSounds();
      _model.instrumentsSounds = _model.listSounds!.toList().cast<AudioModelStruct>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
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
                      if (_model.isSelected && (_model.selectedIndex >= 0)) {
                        final selectedItem = _model.instrumentsSounds.elementAtOrNull(_model.selectedIndex)!;
                        debugPrint('✅ Adicionando à playlist: ${selectedItem.title} (índice: ${_model.selectedIndex})');
                        debugPrint('✅ Detalhes: ID=${selectedItem.id}, Duration=${selectedItem.duration}, FileLocation=${selectedItem.fileLocation}');
                        AppStateStore().addToListAudiosSelected(selectedItem);
                        safeSetState(() {});
                      }
                      context.pop();
                    },
                  ),
                  title: Text(
                    'Sons para a playlist',
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
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.9,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Sons de Instrumentos',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final instrumentSound = _model.instrumentsSounds.toList();

                                  return ListView.separated(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    scrollDirection: Axis.vertical,
                                    itemCount: instrumentSound.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 4.0),
                                    itemBuilder: (context, instrumentSoundIndex) {
                                      final instrumentSoundItem = instrumentSound[instrumentSoundIndex];
                                      return Align(
                                        alignment: const AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 2.0,
                                              ),
                                            ),
                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                            child: Align(
                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 8.0, 8.0),
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () async {
                                                    _model.isSelected = true;
                                                    _model.selectedIndex = instrumentSoundIndex;
                                                    debugPrint('🎵 Selecionado: ${instrumentSoundItem.title} (índice: $instrumentSoundIndex)');
                                                    debugPrint('🎵 ID: ${instrumentSoundItem.id}, AudioType: ${instrumentSoundItem.audioType}');
                                                    safeSetState(() {});
                                                    await AudioUtils.playSound(
                                                      instrumentSoundItem,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              instrumentSoundItem.title,
                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                    fontSize: 18.0,
                                                                    letterSpacing: 0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Builder(
                                                        builder: (context) {
                                                          if ((_model.isSelected == true) &&
                                                              (instrumentSoundIndex == _model.selectedIndex)) {
                                                            return Icon(
                                                              Icons.play_circle,
                                                              color: FlutterFlowTheme.of(context).primary,
                                                              size: 30.0,
                                                            );
                                                          } else {
                                                            return Icon(
                                                              Icons.play_circle_outline,
                                                              color: FlutterFlowTheme.of(context).primary,
                                                              size: 30.0,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
          ),
        ),
      ),
    );
  }
}
