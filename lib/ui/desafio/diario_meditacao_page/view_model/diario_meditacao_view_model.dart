import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/data/services/auth/firebase_auth/auth_util.dart';

class DiarioMeditacaoViewModel extends ChangeNotifier {
  List<D21MeditationModelStruct> _listaMeditacoes = [];
  List<D21MeditationModelStruct> get listaMeditacoes => _listaMeditacoes;

  Future<void> loadMeditacoes() async {
    if (currentUserDocument?.desafio21 != null) {
      _listaMeditacoes = currentUserDocument!.desafio21.d21Meditations
          .toList()
          .cast<D21MeditationModelStruct>();
      notifyListeners();
    }
  }
}
