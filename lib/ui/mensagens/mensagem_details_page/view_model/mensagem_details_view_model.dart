import 'package:flutter/material.dart';
import 'package:medita_bk/data/models/firebase/message_model.dart';
import 'package:medita_bk/data/repositories/mensagem_repository.dart';
import 'package:medita_bk/core/state/app_state.dart';
import 'package:medita_bk/ui/core/flutter_flow/custom_functions.dart' as functions;
import 'package:medita_bk/core/utils/logger.dart';
import 'package:share_plus/share_plus.dart';

class MensagemDetailsViewModel extends ChangeNotifier {
  final MensagemRepository _repository;

  MessageModel? messageDoc;
  String? dataHoje;
  bool isLoading = true;

  MensagemDetailsViewModel(this._repository);

  Future<void> loadMensagemDoDia() async {
    isLoading = true;
    notifyListeners();

    try {
      dataHoje = functions.getTodayDateFormated();

      // If it is equal, already passed through here and set index and date
      if (dataHoje != AppStateStore().dataMensagemHoje) {
        AppStateStore().indexMensagemHoje = functions.getRandom(1222);
      }

      messageDoc = await _repository.getMensagemById(
        AppStateStore().indexMensagemHoje,
      );

      AppStateStore().dataMensagemHoje = functions.getTodayDateFormated();
    } catch (e) {
      logDebug('Error loading mensagem do dia: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> shareMensagem(Rect? sharePositionOrigin) async {
    if (messageDoc == null) return;

    await Share.share(
      'Mensagem positiva para hoje\n\n${messageDoc!.tema}\n${messageDoc!.mensagem}',
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
