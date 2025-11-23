import '/flutter_flow/flutter_flow_util.dart';
import 'carousel_get_mandalas_widget.dart' show CarouselGetMandalasWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselGetMandalasModel
    extends FlutterFlowModel<CarouselGetMandalasWidget> {
  ///  Local state fields for this component.

  int? indiceListaMandalas = 0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
