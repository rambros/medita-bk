import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';

class CarouselGetMandalasWidget extends StatefulWidget {
  const CarouselGetMandalasWidget({
    super.key,
    required this.listaMandalas,
  });

  final List<String>? listaMandalas;

  @override
  State<CarouselGetMandalasWidget> createState() => _CarouselGetMandalasWidgetState();
}

class _CarouselGetMandalasWidgetState extends State<CarouselGetMandalasWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  List<String> get _mandalas => widget.listaMandalas ?? [];

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
            child: _mandalas.isNotEmpty ? _buildCarousel(context) : _buildEmptyState(context),
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
                itemCount: _mandalas.length,
                itemBuilder: (context, index, _) {
                  final urlMandalasItem = _mandalas[index];
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
                carouselController: _controller,
                options: CarouselOptions(
                  initialPage: max(0, min(0, _mandalas.length - 1)),
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
                  'Mandala ${_currentIndex + 1}/${_mandalas.length}',
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fmandala%2Fmandala_1-1.png?alt=media&token=00cab8c0-5d3e-4ac5-a2ad-64d3949fb1f0',
              width: 270.0,
              height: 270.0,
              fit: BoxFit.contain,
              alignment: const Alignment(0.0, 0.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: Text(
            'Mandala 0/7',
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
    );
  }
}
