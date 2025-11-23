import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class DonationViewModel extends ChangeNotifier {
  MessagesRecord? messageDoc;
  bool isLoading = true;

  Future<void> loadMessage() async {
    isLoading = true;
    notifyListeners();

    try {
      String dataHoje = functions.getTodayDateFormated();

      if (dataHoje != FFAppState().dataMensagemHoje) {
        FFAppState().indexMensagemHoje = functions.getRandom(1222);
        FFAppState().dataMensagemHoje = dataHoje;
      }

      final result = await queryMessagesRecordOnce(
        queryBuilder: (messagesRecord) => messagesRecord.where(
          'id',
          isEqualTo: valueOrDefault<int>(
            FFAppState().indexMensagemHoje,
            100,
          ),
        ),
        singleRecord: true,
      );

      messageDoc = result.firstOrNull;
    } catch (e) {
      debugPrint('Error loading message: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> launchDonationSite() async {
    await launchURL('https://brahmakumaris.org.br/como-contribuir');
  }
}
