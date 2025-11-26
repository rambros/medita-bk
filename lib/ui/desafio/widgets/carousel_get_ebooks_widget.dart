import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class CarouselGetEbooksWidget extends StatefulWidget {
  const CarouselGetEbooksWidget({
    super.key,
    required this.listaEbooks,
  });

  final List<String>? listaEbooks;

  @override
  State<CarouselGetEbooksWidget> createState() => _CarouselGetEbooksWidgetState();
}

class _CarouselGetEbooksWidgetState extends State<CarouselGetEbooksWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  List<String> get _ebooks => widget.listaEbooks ?? [];

  @override
  Widget build(BuildContext context) {
    context.watch<AppStateStore>();

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
            child: _ebooks.isNotEmpty ? _buildCarousel(context) : _buildEmptyState(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const AlignmentDirectional(0.0, -1.0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: 250.0,
              child: CarouselSlider.builder(
                itemCount: _ebooks.length,
                itemBuilder: (context, index, _) {
                  final ebookCoverUrl = _ebooks[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      final premio = AppStateStore().desafio21.listaBrasoes.elementAtOrNull(_currentIndex);
                      await downloadFile(
                        filename: premio?.pdfFilename ?? 'Caminhos para uma vida plena',
                        url: premio?.pdfUrl ??
                            'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fpremios%2FCaminhos.pdf?alt=media&token=2e31bbe6-fb24-4071-897e-05636e83f626',
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        ebookCoverUrl,
                        width: 250.0,
                        height: 250.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                carouselController: _controller,
                options: CarouselOptions(
                  initialPage: max(0, min(0, _ebooks.length - 1)),
                  viewportFraction: 1.0,
                  disableCenter: false,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, _) {
                    setState(() => _currentIndex = index);
                  },
                ),
              ),
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
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 16.0),
                child: Text(
                  'Prêmio ${_currentIndex + 1}/${_ebooks.length}',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Complete as etapas para fazer download dos ebooks aqui',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                    color: FlutterFlowTheme.of(context).primaryBtnText,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    lineHeight: 1.5,
                    useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: Text(
              'Prêmio 0/3',
              style: FlutterFlowTheme.of(context).labelLarge.override(
                    fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                    color: FlutterFlowTheme.of(context).info,
                    fontSize: 22.0,
                    letterSpacing: 0.0,
                    useGoogleFonts: !FlutterFlowTheme.of(context).labelLargeIsCustom,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
