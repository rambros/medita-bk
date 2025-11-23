import '/flutter_flow/flutter_flow_util.dart';
import '/modules/desafio/status_meditacao/status_meditacao_widget.dart';
import 'card_dia_meditacao_widget.dart' show CardDiaMeditacaoWidget;
import 'package:flutter/material.dart';

class CardDiaMeditacaoModel extends FlutterFlowModel<CardDiaMeditacaoWidget> {
  ///  Local state fields for this component.

  bool isDownloaded = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - isAudioDownloaded] action in cardDiaMeditacao widget.
  bool? isAudioDownloaded;
  // Model for statusMeditacao component.
  late StatusMeditacaoModel statusMeditacaoModel;

  @override
  void initState(BuildContext context) {
    statusMeditacaoModel = createModel(context, () => StatusMeditacaoModel());
  }

  @override
  void dispose() {
    statusMeditacaoModel.dispose();
  }
}
