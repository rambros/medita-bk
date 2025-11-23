import '/flutter_flow/flutter_flow_util.dart';
import 'carousel_get_brasao_widget.dart' show CarouselGetBrasaoWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselGetBrasaoModel extends FlutterFlowModel<CarouselGetBrasaoWidget> {
  ///  Local state fields for this component.

  int? indiceLista = 0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
