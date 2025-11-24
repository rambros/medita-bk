import '/flutter_flow/flutter_flow_util.dart';
import 'comment_dialog.dart' show CommentDialogWidget;
import 'package:flutter/material.dart';

class CommentDialogModel extends FlutterFlowModel<CommentDialogWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for comentario widget.
  FocusNode? comentarioFocusNode;
  TextEditingController? comentarioTextController;
  String? Function(BuildContext, String?)? comentarioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    comentarioFocusNode?.dispose();
    comentarioTextController?.dispose();
  }
}
