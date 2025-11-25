import 'package:flutter/material.dart';
import '/app_state.dart';
import '/data/services/auth/firebase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';

class ListaEtapasViewModel extends ChangeNotifier {
  // Access to global state
  final FFAppState _appState = FFAppState();

  // Getters for UI
  int get diasCompletados => _appState.desafio21.diasCompletados;

  List<D21EtapaModelStruct> get listaEtapasMandalas => _appState.listaEtapasMandalas;

  bool get isTester {
    final roles = currentUserDocument?.userRole.toList() ?? [];
    return roles.contains('Tester');
  }

  // Methods
  String? getURLMandala(int etapa) {
    // This logic was in custom_functions.getURLMandala
    // We can call the function or replicate logic if it's simple.
    // For now, let's assume the UI calls the function directly or we wrap it here.
    // But the UI uses `functions.getURLMandala`.
    // It's better if the ViewModel provides the data.

    // However, `functions.getURLMandala` is a custom function.
    // I will let the UI call it for now, or I can import it here.
    return null;
  }
}
