import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/ead/notificacao_ead_model.dart';

/// Service para gerenciar notificações do módulo EAD
/// Responsável por criar, listar e marcar notificações como lidas
class NotificacaoEadService {
  final FirebaseFirestore _firestore;

  NotificacaoEadService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // === Collections ===

  CollectionReference<Map<String, dynamic>> get _notificacoesCollection =>
      _firestore.collection('notificacoes_ead');

  CollectionReference<Map<String, dynamic>> get _contadoresCollection =>
      _firestore.collection('contadores_comunicacao');

  // ============================================================
  // === NOTIFICAÇÕES ===
  // ============================================================

  /// Cria uma nova notificação
  Future<String?> criarNotificacao({
    required String titulo,
    required String conteudo,
    required TipoNotificacaoEad tipo,
    required String destinatarioId,
    String? relatedType,
    String? relatedId,
    String? remetenteId,
    String? remetenteNome,
    Map<String, dynamic>? dados,
  }) async {
    try {
      final notificacaoData = {
        'titulo': titulo,
        'conteudo': conteudo,
        'tipo': tipo.value,
        'destinatarioId': destinatarioId,
        'relatedType': relatedType,
        'relatedId': relatedId,
        'remetenteId': remetenteId,
        'remetenteNome': remetenteNome,
        'dataCriacao': FieldValue.serverTimestamp(),
        'lido': false,
        if (dados != null) 'dados': dados,
      };

      final docRef = await _notificacoesCollection.add(notificacaoData);

      // Incrementa contador do destinatário
      await _incrementarContador(
        destinatarioId,
        tipo.isTicket ? 'ticketsNaoLidos' : 'discussoesNaoLidas',
      );

      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao criar notificação: $e');
      return null;
    }
  }

  /// Busca notificações do usuário
  Future<List<NotificacaoEadModel>> getNotificacoesByUsuario(
    String usuarioId, {
    int limite = 50,
    bool apenasNaoLidas = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _notificacoesCollection
          .where('destinatarioId', isEqualTo: usuarioId)
          .orderBy('dataCriacao', descending: true)
          .limit(limite);

      if (apenasNaoLidas) {
        query = query.where('lido', isEqualTo: false);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => NotificacaoEadModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar notificações: $e');
      return [];
    }
  }

  /// Stream de notificações do usuário
  Stream<List<NotificacaoEadModel>> streamNotificacoesByUsuario(
    String usuarioId, {
    int limite = 50,
  }) {
    return _notificacoesCollection
        .where('destinatarioId', isEqualTo: usuarioId)
        .orderBy('dataCriacao', descending: true)
        .limit(limite)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificacaoEadModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Stream de notificações não lidas do usuário
  Stream<List<NotificacaoEadModel>> streamNotificacoesNaoLidas(
    String usuarioId,
  ) {
    return _notificacoesCollection
        .where('destinatarioId', isEqualTo: usuarioId)
        .where('lido', isEqualTo: false)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificacaoEadModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Marca uma notificação como lida
  Future<bool> marcarComoLida(String notificacaoId, String usuarioId) async {
    try {
      final doc = await _notificacoesCollection.doc(notificacaoId).get();
      if (!doc.exists) return false;

      final notificacao = NotificacaoEadModel.fromMap(doc.data()!, doc.id);

      // Só atualiza se ainda não foi lida
      if (!notificacao.lido) {
        await _notificacoesCollection.doc(notificacaoId).update({
          'lido': true,
        });

        // Decrementa contador
        await _decrementarContador(
          usuarioId,
          notificacao.tipo.isTicket ? 'ticketsNaoLidos' : 'discussoesNaoLidas',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao marcar como lida: $e');
      return false;
    }
  }

  /// Marca todas as notificações como lidas
  Future<bool> marcarTodasComoLidas(String usuarioId) async {
    try {
      final snapshot = await _notificacoesCollection
          .where('destinatarioId', isEqualTo: usuarioId)
          .where('lido', isEqualTo: false)
          .get();

      if (snapshot.docs.isEmpty) return true;

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'lido': true});
      }
      await batch.commit();

      // Zera contadores
      await _contadoresCollection.doc(usuarioId).set({
        'ticketsNaoLidos': 0,
        'discussoesNaoLidas': 0,
        'totalNaoLidas': 0,
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint('Erro ao marcar todas como lidas: $e');
      return false;
    }
  }

  /// Exclui uma notificação
  Future<bool> excluirNotificacao(String notificacaoId) async {
    try {
      await _notificacoesCollection.doc(notificacaoId).delete();
      return true;
    } catch (e) {
      debugPrint('Erro ao excluir notificação: $e');
      return false;
    }
  }

  // ============================================================
  // === CONTADORES ===
  // ============================================================

  /// Stream de contadores do usuário
  Stream<ContadorNotificacoesEad> streamContadores(String usuarioId) {
    return _contadoresCollection.doc(usuarioId).snapshots().map((doc) {
      if (!doc.exists) {
        return const ContadorNotificacoesEad();
      }
      return ContadorNotificacoesEad.fromMap(doc.data()!);
    });
  }

  /// Busca contadores do usuário
  Future<ContadorNotificacoesEad> getContadores(String usuarioId) async {
    try {
      final doc = await _contadoresCollection.doc(usuarioId).get();
      if (!doc.exists) {
        return const ContadorNotificacoesEad();
      }
      return ContadorNotificacoesEad.fromMap(doc.data()!);
    } catch (e) {
      debugPrint('Erro ao buscar contadores: $e');
      return const ContadorNotificacoesEad();
    }
  }

  /// Conta notificações não lidas
  Future<int> contarNaoLidas(String usuarioId) async {
    try {
      final snapshot = await _notificacoesCollection
          .where('destinatarioId', isEqualTo: usuarioId)
          .where('lido', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('Erro ao contar não lidas: $e');
      return 0;
    }
  }

  /// Incrementa contador
  Future<void> _incrementarContador(String usuarioId, String campo) async {
    try {
      await _contadoresCollection.doc(usuarioId).set({
        campo: FieldValue.increment(1),
        'totalNaoLidas': FieldValue.increment(1),
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro ao incrementar contador: $e');
    }
  }

  /// Decrementa contador
  Future<void> _decrementarContador(String usuarioId, String campo) async {
    try {
      await _contadoresCollection.doc(usuarioId).set({
        campo: FieldValue.increment(-1),
        'totalNaoLidas': FieldValue.increment(-1),
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro ao decrementar contador: $e');
    }
  }

  // ============================================================
  // === HELPERS PARA CRIAÇÃO DE NOTIFICAÇÕES ===
  // ============================================================

  /// Notifica resposta em ticket (para o aluno)
  Future<String?> notificarRespostaTicket({
    required String ticketId,
    required String ticketNumero,
    required String destinatarioId,
    required String remetenteId,
    required String remetenteNome,
  }) {
    return criarNotificacao(
      titulo: 'Nova resposta no Ticket #$ticketNumero',
      conteudo: '$remetenteNome respondeu ao seu ticket',
      tipo: TipoNotificacaoEad.ticketRespondido,
      destinatarioId: destinatarioId,
      relatedType: 'ticket',
      relatedId: ticketId,
      remetenteId: remetenteId,
      remetenteNome: remetenteNome,
      dados: {'ticketId': ticketId, 'ticketNumero': ticketNumero},
    );
  }

  /// Notifica ticket resolvido (para o aluno)
  Future<String?> notificarTicketResolvido({
    required String ticketId,
    required String ticketNumero,
    required String destinatarioId,
  }) {
    return criarNotificacao(
      titulo: 'Ticket #$ticketNumero Resolvido',
      conteudo: 'Seu ticket foi marcado como resolvido',
      tipo: TipoNotificacaoEad.ticketResolvido,
      destinatarioId: destinatarioId,
      relatedType: 'ticket',
      relatedId: ticketId,
      dados: {'ticketId': ticketId, 'ticketNumero': ticketNumero},
    );
  }

  /// Notifica resposta em discussão (para o autor)
  Future<String?> notificarRespostaDiscussao({
    required String discussaoId,
    required String discussaoTitulo,
    required String destinatarioId,
    required String remetenteId,
    required String remetenteNome,
    String? cursoId,
  }) {
    return criarNotificacao(
      titulo: 'Nova resposta na sua pergunta',
      conteudo: '$remetenteNome respondeu: "$discussaoTitulo"',
      tipo: TipoNotificacaoEad.discussaoRespondida,
      destinatarioId: destinatarioId,
      relatedType: 'discussao',
      relatedId: discussaoId,
      remetenteId: remetenteId,
      remetenteNome: remetenteNome,
      dados: {
        'discussaoId': discussaoId,
        if (cursoId != null) 'cursoId': cursoId,
      },
    );
  }

  /// Notifica discussão resolvida (para o autor)
  Future<String?> notificarDiscussaoResolvida({
    required String discussaoId,
    required String discussaoTitulo,
    required String destinatarioId,
  }) {
    return criarNotificacao(
      titulo: 'Pergunta Resolvida',
      conteudo: 'Sua pergunta "$discussaoTitulo" foi marcada como resolvida',
      tipo: TipoNotificacaoEad.discussaoResolvida,
      destinatarioId: destinatarioId,
      relatedType: 'discussao',
      relatedId: discussaoId,
      dados: {'discussaoId': discussaoId},
    );
  }

  /// Notifica curtida em resposta (para o autor da resposta)
  Future<String?> notificarRespostaCurtida({
    required String discussaoId,
    required String respostaId,
    required String destinatarioId,
    required String remetenteId,
    required String remetenteNome,
  }) {
    return criarNotificacao(
      titulo: 'Sua resposta foi curtida',
      conteudo: '$remetenteNome achou sua resposta útil',
      tipo: TipoNotificacaoEad.respostaCurtida,
      destinatarioId: destinatarioId,
      relatedType: 'resposta',
      relatedId: respostaId,
      remetenteId: remetenteId,
      remetenteNome: remetenteNome,
      dados: {'discussaoId': discussaoId, 'respostaId': respostaId},
    );
  }

  /// Notifica resposta marcada como solução (para o autor da resposta)
  Future<String?> notificarRespostaMarcadaSolucao({
    required String discussaoId,
    required String discussaoTitulo,
    required String respostaId,
    required String destinatarioId,
    required String remetenteId,
    required String remetenteNome,
  }) {
    return criarNotificacao(
      titulo: 'Resposta aceita como solução!',
      conteudo: 'Sua resposta em "$discussaoTitulo" foi marcada como solução',
      tipo: TipoNotificacaoEad.respostaMarcadaSolucao,
      destinatarioId: destinatarioId,
      relatedType: 'resposta',
      relatedId: respostaId,
      remetenteId: remetenteId,
      remetenteNome: remetenteNome,
      dados: {'discussaoId': discussaoId, 'respostaId': respostaId},
    );
  }
}
