import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_b_k/ui/core/flutter_flow/form_field_controller.dart';
import 'filter_meditations_dialog.dart' show FilterMeditationsDialogWidget;
import 'package:flutter/material.dart';

class FilterMeditationsDialogModel extends FlutterFlowModel<FilterMeditationsDialogWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue => choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) => choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
