import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'meditation_details_page_widget.dart' show MeditationDetailsPageWidget;
import 'package:flutter/material.dart';

class MeditationDetailsPageModel
    extends FlutterFlowModel<MeditationDetailsPageWidget> {
  ///  Local state fields for this page.

  bool favorito = false;

  int? numPlayed;

  int? numLiked;

  bool isAudioDownloaded = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Read Document] action in meditationDetailsPage widget.
  MeditationsRecord? meditationDoc;
  // Stores action output result for [Custom Action - isAudioDownloaded] action in meditationDetailsPage widget.
  bool? isDownloaded;
  // Stores action output result for [Custom Action - hasInternetAccess] action in PlayAudioIconButton widget.
  bool? hasInternetAccess;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
