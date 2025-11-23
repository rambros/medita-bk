import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'mensagens_semantic_search_page_model.dart';
export 'mensagens_semantic_search_page_model.dart';

class MensagensSemanticSearchPageWidget extends StatefulWidget {
  const MensagensSemanticSearchPageWidget({super.key});

  static String routeName = 'mensagensSemanticSearchPage';
  static String routePath = 'mensagensSemanticSearchPage';

  @override
  State<MensagensSemanticSearchPageWidget> createState() =>
      _MensagensSemanticSearchPageWidgetState();
}

class _MensagensSemanticSearchPageWidgetState
    extends State<MensagensSemanticSearchPageWidget> {
  late MensagensSemanticSearchPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MensagensSemanticSearchPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'mensagensSemanticSearchPage'});
    _model.textSearchFieldTextController ??= TextEditingController();
    _model.textSearchFieldFocusNode ??= FocusNode();

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
                  'Pesquisa de mensagens',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleLargeIsCustom,
                      ),
                ),
                actions: const [],
                centerTitle: true,
                elevation: 2.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 8.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _model.textSearchFieldTextController,
                        focusNode: _model.textSearchFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textSearchFieldTextController',
                          const Duration(milliseconds: 2000),
                          () => safeSetState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          _model.apiResultekeCopy =
                              await SearchMensagensCall.call(
                            pesquisar:
                                _model.textSearchFieldTextController.text,
                          );

                          if ((_model.apiResultekeCopy?.succeeded ?? true)) {
                            _model.numResultados =
                                SearchedMessagesStruct.maybeFromMap(
                                        (_model.apiResultekeCopy?.jsonBody ??
                                            ''))
                                    ?.result
                                    .length;
                            _model.searchedMessages =
                                SearchedMessagesStruct.maybeFromMap(
                                    (_model.apiResultekeCopy?.jsonBody ?? ''));
                            safeSetState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erro na consulta',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                duration: const Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                            );
                          }

                          safeSetState(() {});
                        },
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Digite o texto para pesquisa',
                          hintStyle: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyLargeIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          suffixIcon: _model.textSearchFieldTextController!.text
                                  .isNotEmpty
                              ? InkWell(
                                  onTap: () async {
                                    _model.textSearchFieldTextController
                                        ?.clear();
                                    safeSetState(() {});
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 22.0,
                                  ),
                                )
                              : null,
                        ),
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyLargeFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyLargeIsCustom,
                            ),
                        validator: _model.textSearchFieldTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.apiResulteke = await SearchMensagensCall.call(
                            pesquisar:
                                _model.textSearchFieldTextController.text,
                          );

                          if ((_model.apiResulteke?.succeeded ?? true)) {
                            _model.numResultados =
                                SearchedMessagesStruct.maybeFromMap(
                                        (_model.apiResulteke?.jsonBody ?? ''))
                                    ?.result
                                    .length;
                            _model.searchedMessages =
                                SearchedMessagesStruct.maybeFromMap(
                                    (_model.apiResulteke?.jsonBody ?? ''));
                            safeSetState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erro na consulta',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                duration: const Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                            );
                          }

                          safeSetState(() {});
                        },
                        child: Icon(
                          Icons.search,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 38.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Resultado da pesquisa',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleLargeIsCustom,
                            ),
                      ),
                    ),
                    Text(
                      valueOrDefault<String>(
                        _model.numResultados?.toString(),
                        '0',
                      ),
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleLargeFamily,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleLargeIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Builder(
                    builder: (context) {
                      if (_model.searchedMessages != null) {
                        return Builder(
                          builder: (context) {
                            final listaMensagens =
                                _model.searchedMessages?.result.toList() ?? [];

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: listaMensagens.length,
                              itemBuilder: (context, listaMensagensIndex) {
                                final listaMensagensItem =
                                    listaMensagens[listaMensagensIndex];
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 4.0, 8.0, 4.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        MensagemShowPageWidget.routeName,
                                        queryParameters: {
                                          'tema': serializeParam(
                                            listaMensagensItem.title,
                                            ParamType.String,
                                          ),
                                          'mensagem': serializeParam(
                                            listaMensagensItem.mensagem,
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            8.0, 4.0, 8.0, 4.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              MensagemShowPageWidget.routeName,
                                              queryParameters: {
                                                'tema': serializeParam(
                                                  listaMensagensItem.title,
                                                  ParamType.String,
                                                ),
                                                'mensagem': serializeParam(
                                                  listaMensagensItem.mensagem,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listaMensagensItem.title,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelLarge
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLargeIsCustom,
                                                    ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      listaMensagensItem
                                                          .mensagem,
                                                      maxLines: 3,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                                .divide(const SizedBox(height: 4.0))
                                                .around(const SizedBox(height: 4.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200.0,
                              maxHeight: 200.0,
                            ),
                            decoration: const BoxDecoration(),
                            child: Lottie.asset(
                              'assets/jsons/animation-loading-mbk.json',
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.contain,
                              animate: true,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
