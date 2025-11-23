import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'desafio_play_page_widget.dart' show DesafioPlayPageWidget;
import 'package:flutter/material.dart';

class DesafioPlayPageModel extends FlutterFlowModel<DesafioPlayPageWidget> {
  ///  Local state fields for this page.

  D21ModelStruct? d21Model;
  void updateD21ModelStruct(Function(D21ModelStruct) updateFn) {
    updateFn(d21Model ??= D21ModelStruct());
  }

  bool iniciadoDesafio = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in desafioPlayPage widget.
  Desafio21Record? desafio21Record;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
