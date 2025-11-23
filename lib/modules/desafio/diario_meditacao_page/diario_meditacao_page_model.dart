import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'diario_meditacao_page_widget.dart' show DiarioMeditacaoPageWidget;
import 'package:flutter/material.dart';

class DiarioMeditacaoPageModel
    extends FlutterFlowModel<DiarioMeditacaoPageWidget> {
  ///  Local state fields for this page.

  List<D21MeditationModelStruct> listaMeditacoes = [];
  void addToListaMeditacoes(D21MeditationModelStruct item) =>
      listaMeditacoes.add(item);
  void removeFromListaMeditacoes(D21MeditationModelStruct item) =>
      listaMeditacoes.remove(item);
  void removeAtIndexFromListaMeditacoes(int index) =>
      listaMeditacoes.removeAt(index);
  void insertAtIndexInListaMeditacoes(
          int index, D21MeditationModelStruct item) =>
      listaMeditacoes.insert(index, item);
  void updateListaMeditacoesAtIndex(
          int index, Function(D21MeditationModelStruct) updateFn) =>
      listaMeditacoes[index] = updateFn(listaMeditacoes[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
