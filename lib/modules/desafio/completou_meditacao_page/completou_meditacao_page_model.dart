import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'completou_meditacao_page_widget.dart' show CompletouMeditacaoPageWidget;
import 'package:flutter/material.dart';

class CompletouMeditacaoPageModel
    extends FlutterFlowModel<CompletouMeditacaoPageWidget> {
  ///  Local state fields for this page.

  D21ModelStruct? d21Model;
  void updateD21ModelStruct(Function(D21ModelStruct) updateFn) {
    updateFn(d21Model ??= D21ModelStruct());
  }

  bool iniciadoDesafio = false;

  bool isLoadingMandala = true;

  int? proximaEtapa;

  String? mandalaURL;

  bool isMeditacaoJaFeita = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
