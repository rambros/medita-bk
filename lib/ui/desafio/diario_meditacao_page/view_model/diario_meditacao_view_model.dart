import 'package:flutter/material.dart';

import 'package:medita_b_k/core/structs/index.dart';
import 'package:medita_b_k/data/repositories/auth_repository.dart';

class DiarioMeditacaoViewModel extends ChangeNotifier {
  DiarioMeditacaoViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  List<D21MeditationModelStruct> _listaMeditacoes = [];
  List<D21MeditationModelStruct> get listaMeditacoes => _listaMeditacoes;

  Future<void> loadMeditacoes() async {
    final desafio = _authRepository.currentUser?.desafio21;
    if (desafio != null) {
      _listaMeditacoes = desafio.d21Meditations
          .toList()
          .cast<D21MeditationModelStruct>();
      notifyListeners();
    }
  }
}
