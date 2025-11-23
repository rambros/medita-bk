import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'carousel_get_mandalas_model.dart';
export 'carousel_get_mandalas_model.dart';

class CarouselGetMandalasWidget extends StatefulWidget {
  const CarouselGetMandalasWidget({
    super.key,
    required this.listaMandalas,
  });

  final List<String>? listaMandalas;

  @override
  State<CarouselGetMandalasWidget> createState() =>
      _CarouselGetMandalasWidgetState();
}

class _CarouselGetMandalasWidgetState extends State<CarouselGetMandalasWidget> {
  late CarouselGetMandalasModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarouselGetMandalasModel());

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
                if (widget.listaMandalas != null &&
                    (widget.listaMandalas)!.isNotEmpty) {
                  return Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final urlMandalas =
                                  widget.listaMandalas!.toList();

                              return SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: 250.0,
                                child: CarouselSlider.builder(
                                  itemCount: urlMandalas.length,
                                  itemBuilder: (context, urlMandalasIndex, _) {
                                    final urlMandalasItem =
                                        urlMandalas[urlMandalasIndex];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        urlMandalasItem,
                                        width: 250.0,
                                        height: 250.0,
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                  carouselController:
                                      _model.carouselController ??=
                                          CarouselSliderController(),
                                  options: CarouselOptions(
                                    initialPage:
                                        max(0, min(0, urlMandalas.length - 1)),
                                    viewportFraction: 1.0,
                                    disableCenter: false,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.25,
                                    enableInfiniteScroll: false,
                                    scrollDirection: Axis.horizontal,
                                    autoPlay: false,
                                    onPageChanged: (index, _) async {
                                      _model.carouselCurrentIndex = index;
                                      _model.indiceListaMandalas =
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
                                'Mandala ${(_model.carouselCurrentIndex + 1).toString()}/${widget.listaMandalas?.length.toString()}',
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
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            FFAppState()
                                .listaEtapasMandalas
                                .firstOrNull!
                                .listaMandalas
                                .firstOrNull!
                                .mandalaUrl,
                            width: 250.0,
                            height: 250.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                        child: Text(
                          'Mandala 0/7',
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
