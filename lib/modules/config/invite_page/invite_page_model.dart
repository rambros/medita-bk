import '/flutter_flow/flutter_flow_util.dart';
import 'invite_page_widget.dart' show InvitePageWidget;
import 'package:flutter/material.dart';

class InvitePageModel extends FlutterFlowModel<InvitePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for inviteText widget.
  FocusNode? inviteTextFocusNode;
  TextEditingController? inviteTextTextController;
  String? Function(BuildContext, String?)? inviteTextTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    inviteTextFocusNode?.dispose();
    inviteTextTextController?.dispose();
  }
}
