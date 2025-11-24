import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'view_model/mensagens_semantic_search_view_model.dart';

class MensagensSemanticSearchPage extends StatefulWidget {
  const MensagensSemanticSearchPage({super.key});

  static String routeName = 'mensagensSemanticSearchPage';
  static String routePath = 'mensagensSemanticSearchPage';

  @override
  State<MensagensSemanticSearchPage> createState() => _MensagensSemanticSearchPageState();
}

class _MensagensSemanticSearchPageState extends State<MensagensSemanticSearchPage> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'mensagensSemanticSearchPage'});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MensagensSemanticSearchViewModel>();
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MensagensSemanticSearchViewModel>(
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
                      'Pesquisa de mensagens',
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
                            controller: _textController,
                            focusNode: _focusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_textController',
                              const Duration(milliseconds: 2000),
                              () => safeSetState(() {}),
                            ),
                            onFieldSubmitted: (_) async {
                              await viewModel.searchMensagens(_textController.text);
                              if (viewModel.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro na consulta',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryText,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                              }
                            },
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Digite o texto para pesquisa',
                              hintStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
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
                              suffixIcon: _textController.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        _textController.clear();
                                        viewModel.clearSearch();
                                        safeSetState(() {});
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 22.0,
                                      ),
                                    )
                                  : null,
                            ),
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                ),
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
                              await viewModel.searchMensagens(_textController.text);
                              if (viewModel.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro na consulta',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).primaryText,
                                      ),
                                    ),
                                    duration: const Duration(milliseconds: 4000),
                                    backgroundColor: FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                              }
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
                                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                ),
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            viewModel.searchResults.length.toString(),
                            '0',
                          ),
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
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
                          if (!viewModel.isLoading) {
                            final listaMensagens = viewModel.searchResults;

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: listaMensagens.length,
                              itemBuilder: (context, listaMensagensIndex) {
                                final listaMensagensItem = listaMensagens[listaMensagensIndex];
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        'mensagemShowPage',
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
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              'mensagemShowPage',
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listaMensagensItem.title,
                                                style: FlutterFlowTheme.of(context).labelLarge.override(
                                                      fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w600,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                                                    ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      listaMensagensItem.mensagem,
                                                      maxLines: 3,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(const SizedBox(height: 4.0)).around(const SizedBox(height: 4.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
      },
    );
  }
}
