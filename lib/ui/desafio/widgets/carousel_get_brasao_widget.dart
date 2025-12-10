import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';

class CarouselGetBrasaoWidget extends StatefulWidget {
  const CarouselGetBrasaoWidget({
    super.key,
    required this.listaBrasoes,
  });

  final List<String>? listaBrasoes;

  @override
  State<CarouselGetBrasaoWidget> createState() => _CarouselGetBrasaoWidgetState();
}

class _CarouselGetBrasaoWidgetState extends State<CarouselGetBrasaoWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  List<String> get _brasoes => widget.listaBrasoes ?? [];

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
            child: _brasoes.isNotEmpty ? _buildCarousel(context) : _buildEmptyState(context),
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
                itemCount: _brasoes.length,
                itemBuilder: (context, index, _) {
                  final urlBrasaoItem = _brasoes[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      urlBrasaoItem,
                      width: 250.0,
                      height: 250.0,
                      fit: BoxFit.contain,
                    ),
                  );
                },
                carouselController: _controller,
                options: CarouselOptions(
                  initialPage: max(0, min(0, _brasoes.length - 1)),
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
                  'Brasão ${_currentIndex + 1}/${_brasoes.length}',
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
        Opacity(
          opacity: 0.8,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fbrasao%2Fbrasao_modelo%20-%2001.png?alt=media&token=af985984-db73-41a2-86a9-d6174793679f',
                width: 270.0,
                height: 270.0,
                fit: BoxFit.contain,
                alignment: const Alignment(0.0, 0.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: Text(
            'Brasão 0/3',
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
