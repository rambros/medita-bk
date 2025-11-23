import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'mensagem_show_page_widget.dart' show MensagemShowPageWidget;
import 'package:flutter/material.dart';

class MensagemShowPageModel extends FlutterFlowModel<MensagemShowPageWidget> {
  ///  Local state fields for this page.

  String dataHoje = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in mensagemShowPage widget.
  MessagesRecord? messageDoc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
