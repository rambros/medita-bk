import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'carousel_get_ebooks_model.dart';
export 'carousel_get_ebooks_model.dart';

class CarouselGetEbooksWidget extends StatefulWidget {
  const CarouselGetEbooksWidget({
    super.key,
    required this.listaEbooks,
  });

  final List<String>? listaEbooks;

  @override
  State<CarouselGetEbooksWidget> createState() =>
      _CarouselGetEbooksWidgetState();
}

class _CarouselGetEbooksWidgetState extends State<CarouselGetEbooksWidget> {
  late CarouselGetEbooksModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarouselGetEbooksModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: const AlignmentDirectional(0.0, -1.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
        child: Material(
          color: Colors.transparent,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: double.infinity,
            height: 330.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xCC83193F), Color(0xCBB0373E)],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Builder(
              builder: (context) {
                if (widget.listaEbooks != null &&
                    (widget.listaEbooks)!.isNotEmpty) {
                  return Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final ebooks = widget.listaEbooks!.toList();

                              return SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 250.0,
                                child: CarouselSlider.builder(
                                  itemCount: ebooks.length,
                                  itemBuilder: (context, ebooksIndex, _) {
                                    final ebooksItem = ebooks[ebooksIndex];
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await downloadFile(
                                          filename: valueOrDefault<String>(
                                            FFAppState()
                                                .desafio21
                                                .listaBrasoes
                                                .elementAtOrNull(
                                                    _model.carouselCurrentIndex)
                                                ?.pdfFilename,
                                            'Caminhos para uma vida plena',
                                          ),
                                          url: valueOrDefault<String>(
                                            FFAppState()
                                                .desafio21
                                                .listaBrasoes
                                                .elementAtOrNull(
                                                    _model.carouselCurrentIndex)
                                                ?.pdfUrl,
                                            'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fpremios%2FCaminhos.pdf?alt=media&token=2e31bbe6-fb24-4071-897e-05636e83f626',
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          ebooksItem,
                                          width: 250.0,
                                          height: 250.0,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                  carouselController:
                                      _model.carouselController ??=
                                          CarouselSliderController(),
                                  options: CarouselOptions(
                                    initialPage:
                                        max(0, min(0, ebooks.length - 1)),
                                    viewportFraction: 1.0,
                                    disableCenter: false,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.25,
                                    enableInfiniteScroll: false,
                                    scrollDirection: Axis.horizontal,
                                    autoPlay: false,
                                    onPageChanged: (index, _) async {
                                      _model.carouselCurrentIndex = index;
                                      _model.indiceLista =
                                          _model.carouselCurrentIndex;
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 16.0),
                              child: Text(
                                'Prêmio ${(_model.carouselCurrentIndex + 1).toString()}/${widget.listaEbooks?.length.toString()}',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 22.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelLargeIsCustom,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Complete as etapas para fazer download dos ebooks aqui',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.5,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            'Prêmio 0/3',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelLargeFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelLargeIsCustom,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
