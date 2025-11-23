import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'mensagens_semantic_search_page_widget.dart'
    show MensagensSemanticSearchPageWidget;
import 'package:flutter/material.dart';

class MensagensSemanticSearchPageModel
    extends FlutterFlowModel<MensagensSemanticSearchPageWidget> {
  ///  Local state fields for this page.

  int? numResultados = 0;

  SearchedMessagesStruct? searchedMessages;
  void updateSearchedMessagesStruct(Function(SearchedMessagesStruct) updateFn) {
    updateFn(searchedMessages ??= SearchedMessagesStruct());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextSearchField widget.
  FocusNode? textSearchFieldFocusNode;
  TextEditingController? textSearchFieldTextController;
  String? Function(BuildContext, String?)?
      textSearchFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (searchMensagens)] action in TextSearchField widget.
  ApiCallResponse? apiResultekeCopy;
  // Stores action output result for [Backend Call - API (searchMensagens)] action in Icon widget.
  ApiCallResponse? apiResulteke;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textSearchFieldFocusNode?.dispose();
    textSearchFieldTextController?.dispose();
  }
}
