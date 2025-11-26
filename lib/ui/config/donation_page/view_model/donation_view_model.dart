import 'package:flutter/material.dart';
import '/data/models/firebase/message_model.dart';
import '/data/services/firebase/firestore_service.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;

class DonationViewModel extends ChangeNotifier {
  DonationViewModel({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  MessageModel? messageDoc;
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

      final result = await _firestoreService.getCollection(
        collectionPath: 'messages',
        fromSnapshot: MessageModel.fromFirestore,
        queryBuilder: (query) => query.where(
          'id',
          isEqualTo: valueOrDefault<int>(
            FFAppState().indexMensagemHoje,
            100,
          ),
        ),
        limit: 1,
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
