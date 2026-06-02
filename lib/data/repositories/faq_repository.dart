import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:medita_bk/domain/models/ead/faq_model.dart';

class FaqRepository {
  final FirebaseFirestore _firestore;

  static const String _collection = 'faqs';

  FaqRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<FaqModel>> getFaqsAtivas() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final results = snapshot.docs
          .map(FaqModel.fromFirestore)
          .where((f) => f.ativo && f.pergunta.isNotEmpty)
          .toList();
      results.sort((a, b) {
        final s = a.secao.compareTo(b.secao);
        return s != 0 ? s : a.ordem.compareTo(b.ordem);
      });
      return results;
    } catch (e) {
      if (kDebugMode) print('Erro ao buscar FAQs: $e');
      rethrow;
    }
  }
}
