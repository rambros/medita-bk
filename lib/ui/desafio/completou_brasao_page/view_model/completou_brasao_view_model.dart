import 'package:flutter/material.dart';
import 'package:medita_bk/core/state/app_state.dart';
import 'package:medita_bk/core/structs/index.dart';

class CompletouBrasaoViewModel extends ChangeNotifier {
  final int indiceBrasao;

  CompletouBrasaoViewModel({
    required this.indiceBrasao,
  });

  // Computed properties
  D21ModelStruct get desafio21 => AppStateStore().desafio21;

  D21BrasaoModelStruct? get brasao {
    return desafio21.listaBrasoes.elementAtOrNull(indiceBrasao);
  }

  String get brasaoUrl => brasao?.brasaoUrl ?? '';

  String get header => brasao?.header ?? '';
  String get descricao => brasao?.descricao ?? '';
  String get premio => brasao?.premio ?? '';

  String get textoCompartilhar {
    final texto = brasao?.textoConquistaBrasao ?? '';
    return '$texto Baixe no link a seguir o  App MEDITABK da Brahma Kumaris, é 100% gratuito.\nhttps://c5dad.app.link/meditabk';
  }

  String get brasaoNome {
    switch (indiceBrasao) {
      case 0:
        return 'Bronze';
      case 1:
        return 'Prata';
      case 2:
        return 'Ouro';
      default:
        return '';
    }
  }
}
