import 'package:flutter/material.dart';
import '/data/models/firebase/message_model.dart';
import '/data/repositories/mensagem_repository.dart';
import '/app_state.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/core/utils/logger.dart';
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
      if (dataHoje != FFAppState().dataMensagemHoje) {
        FFAppState().indexMensagemHoje = functions.getRandom(1222);
      }

      messageDoc = await _repository.getMensagemById(
        FFAppState().indexMensagemHoje,
      );

      FFAppState().dataMensagemHoje = functions.getTodayDateFormated();
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
