import 'package:flutter/material.dart';
import '/app_state.dart';
import '/core/structs/index.dart';

class CompletouMandalaViewModel extends ChangeNotifier {
  final int diaCompletado;
  final int etapaCompletada;
  final String mandalaUrl;

  CompletouMandalaViewModel({
    required this.diaCompletado,
    required this.etapaCompletada,
    required this.mandalaUrl,
  });

  // Computed properties
  D21ModelStruct get desafio21 => AppStateStore().desafio21;
  List<D21EtapaModelStruct> get listaEtapasMandalas => AppStateStore().listaEtapasMandalas;

  String get meditationTitle {
    return desafio21.d21Meditations.elementAtOrNull(diaCompletado)?.titulo ?? '';
  }

  int get diaNumero => diaCompletado + 1;

  String get textoMandalaCompleta {
    return listaEtapasMandalas.elementAtOrNull(etapaCompletada - 1)?.textoMandalaCompleta ?? '';
  }

  String get textoCompartilhar {
    final texto = listaEtapasMandalas.elementAtOrNull(etapaCompletada - 1)?.textoCompartilharMandala ?? '';
    return '$texto Baixe no link a seguir o  App MEDITABK da Brahma Kumaris, é 100% gratuito.\nhttps://c5dad.app.link/meditabk';
  }

  String? get shareImageUrl {
    return listaEtapasMandalas.elementAtOrNull(etapaCompletada - 1)?.listaMandalas.lastOrNull?.mandalaUrl;
  }

  // Navigation helper - determines which brasão to show
  int? getBrasaoIndex() {
    if (diaCompletado == 2) {
      return 0; // Bronze
    } else if (diaCompletado == 8) {
      return 1; // Prata
    } else if (diaCompletado == 20) {
      return 2; // Ouro
    }
    return null; // No brasão for this day
  }

  bool shouldNavigateToBrasao() {
    return getBrasaoIndex() != null;
  }
}
