import 'package:flutter/material.dart';
import '/data/services/auth/firebase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/app_state.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;

class ConquistasViewModel extends ChangeNotifier {
  D21ModelStruct? get desafio21 => currentUserDocument?.desafio21;
  
  int get diasCompletados => desafio21?.diasCompletados ?? 0;
  int get etapasCompletadas => desafio21?.etapasCompletadas ?? 0;
  
  double get progressoMeditacoes => _safeProgress(diasCompletados, 21);
  double get progressoEtapas => _safeProgress(etapasCompletadas, 7);
  
  List<String> get mandalasCompletadas {
    final etapasMandalas = FFAppState().listaEtapasMandalas;
    if (etapasMandalas.isEmpty) {
      return [];
    }

    final mandalas = functions.getMandalasCompletadas(
      etapasCompletadas,
      etapasMandalas.toList(),
    );
    return mandalas ?? [];
  }
  
  List<String> get brasoesCompletados {
    final desafio = desafio21;
    if (desafio == null || (desafio.listaBrasoes.isEmpty)) {
      return [];
    }

    return functions.getBrasoesCompletados(
      etapasCompletadas,
      desafio.listaBrasoes.toList(),
    );
  }
  
  List<String> get ebooksCompletados {
    final ebooks = FFAppState().listaEbooksDesafio21;
    if (ebooks.isEmpty) {
      return [];
    }

    return functions.getEbooksCompletados(
      etapasCompletadas,
      ebooks.toList(),
    );
  }

  double _safeProgress(int current, int total) {
    if (total <= 0) {
      return 0;
    }

    final progress = current / total;
    return progress.clamp(0.0, 1.0).toDouble();
  }
}
