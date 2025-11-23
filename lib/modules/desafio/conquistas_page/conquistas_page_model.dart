import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/modules/desafio/carousel_get_brasao/carousel_get_brasao_widget.dart';
import '/modules/desafio/carousel_get_ebooks/carousel_get_ebooks_widget.dart';
import '/modules/desafio/carousel_get_mandalas/carousel_get_mandalas_widget.dart';
import 'conquistas_page_widget.dart' show ConquistasPageWidget;
import 'package:flutter/material.dart';

class ConquistasPageModel extends FlutterFlowModel<ConquistasPageWidget> {
  ///  Local state fields for this page.

  D21ModelStruct? d21Model;
  void updateD21ModelStruct(Function(D21ModelStruct) updateFn) {
    updateFn(d21Model ??= D21ModelStruct());
  }

  bool iniciadoDesafio = false;

  bool isLoadingMandala = true;

  ///  State fields for stateful widgets in this page.

  // Model for carouselGetMandalas component.
  late CarouselGetMandalasModel carouselGetMandalasModel;
  // Model for carouselGetBrasao component.
  late CarouselGetBrasaoModel carouselGetBrasaoModel;
  // Model for carouselGetEbooks component.
  late CarouselGetEbooksModel carouselGetEbooksModel;

  @override
  void initState(BuildContext context) {
    carouselGetMandalasModel =
        createModel(context, () => CarouselGetMandalasModel());
    carouselGetBrasaoModel =
        createModel(context, () => CarouselGetBrasaoModel());
    carouselGetEbooksModel =
        createModel(context, () => CarouselGetEbooksModel());
  }

  @override
  void dispose() {
    carouselGetMandalasModel.dispose();
    carouselGetBrasaoModel.dispose();
    carouselGetEbooksModel.dispose();
  }
}
