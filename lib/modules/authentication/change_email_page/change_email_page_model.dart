import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'change_email_page_widget.dart' show ChangeEmailPageWidget;
import 'package:flutter/material.dart';

class ChangeEmailPageModel extends FlutterFlowModel<ChangeEmailPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  String? _emailAddressTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Informação  obrigatória';
    }

    if (val.length < 6) {
      return 'No mínimo 6 caracteres';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    emailAddressTextControllerValidator = _emailAddressTextControllerValidator;
  }

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}
