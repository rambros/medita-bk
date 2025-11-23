import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'mensagem_details_page_widget.dart' show MensagemDetailsPageWidget;
import 'package:flutter/material.dart';

class MensagemDetailsPageModel
    extends FlutterFlowModel<MensagemDetailsPageWidget> {
  ///  Local state fields for this page.

  String dataHoje = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in mensagemDetailsPage widget.
  MessagesRecord? messageDoc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
