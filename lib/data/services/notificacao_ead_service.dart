import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:medita_bk/domain/models/ead/notificacao_ead_model.dart';
import 'package:medita_bk/domain/models/user_notification_state.dart';

/// Service para gerenciar notificações in-app
/// Responsável por criar, listar e marcar notificações como lidas
/// Collection: notifications (unificada)
class NotificacaoEadService {
  final FirebaseFirestore _firestore;

  NotificacaoEadService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // === Collections ===

  CollectionReference<Map<String, dynamic>> get _notificacoesCollection =>
      _firestore.collection('notifications');

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
      // Formato novo: usa array de destinatarios e inclui navegacao
      final notificacaoData = {
        'titulo': titulo,
        'conteudo': conteudo,
        'tipo': tipo.value,
        'destinatarios': [destinatarioId], // Array ao invés de string
        'status': 'enviada', // Campo obrigatório no novo modelo
        'dataCriacao': FieldValue.serverTimestamp(),
        'dataEnvio': FieldValue.serverTimestamp(),
        // Navegação estruturada (compatível com NotificacaoRepository)
        if (relatedType != null && relatedId != null)
          'navegacao': {
            'tipo': relatedType,
            'id': relatedId,
            if (dados != null) 'dados': dados,
          },
        // Mantém campos legados para compatibilidade (se necessário)
        'destinatarioId': destinatarioId,
        'relatedType': relatedType,
        'relatedId': relatedId,
        'remetenteId': remetenteId,
        'remetenteNome': remetenteNome,
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
      // Usa arrayContains pois destinatarios é um array na collection nova
      Query<Map<String, dynamic>> query = _notificacoesCollection
          .where('destinatarios', arrayContains: usuarioId)
          .orderBy('dataCriacao', descending: true)
          .limit(limite);

      final snapshot = await query.get();

      // Buscar estados do usuário para cada notificação
      final notificacoes = <NotificacaoEadModel>[];

      for (final doc in snapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(usuarioId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, usuarioId)
            : UserNotificationState(userId: usuarioId);

        // Pula notificações ocultadas
        if (userState.ocultado) continue;

        // Se está filtrando apenas não lidas, pula as lidas
        if (apenasNaoLidas && userState.lido) continue;

        // Cria modelo com estado de leitura do usuário
        final notificacao = NotificacaoEadModel.fromMap(doc.data(), doc.id)
            .copyWith(lido: userState.lido);

        notificacoes.add(notificacao);
      }

      return notificacoes;
    } catch (e) {
      debugPrint('Erro ao buscar notificações: $e');
      return [];
    }
  }

  /// Stream de notificações do usuário
  /// NOTA: Para melhor performance com user_states, considere usar getNotificacoesByUsuario
  /// Este stream não inclui estados de usuário em tempo real
  Stream<List<NotificacaoEadModel>> streamNotificacoesByUsuario(
    String usuarioId, {
    int limite = 50,
  }) {
    return _notificacoesCollection
        .where('destinatarios', arrayContains: usuarioId)
        .orderBy('dataCriacao', descending: true)
        .limit(limite)
        .snapshots()
        .asyncMap((snapshot) async {
      // Para cada notificação, buscar o estado do usuário
      final notificacoes = <NotificacaoEadModel>[];

      for (final doc in snapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(usuarioId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, usuarioId)
            : UserNotificationState(userId: usuarioId);

        // Pula notificações ocultadas
        if (userState.ocultado) continue;

        // Cria modelo com estado de leitura do usuário
        final notificacao = NotificacaoEadModel.fromMap(doc.data(), doc.id)
            .copyWith(lido: userState.lido);

        notificacoes.add(notificacao);
      }

      return notificacoes;
    });
  }

  /// Stream de notificações não lidas do usuário
  /// NOTA: Este método está deprecated pois o campo 'lido' agora está em user_states
  /// Use streamNotificacoesByUsuario + filtro manual ou getNotificacoesByUsuario
  Stream<List<NotificacaoEadModel>> streamNotificacoesNaoLidas(
    String usuarioId,
  ) {
    return _notificacoesCollection
        .where('destinatarios', arrayContains: usuarioId)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Filtra não lidas consultando user_states
      final notificacoes = <NotificacaoEadModel>[];
      for (final doc in snapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(usuarioId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, usuarioId)
            : UserNotificationState(userId: usuarioId);

        if (!userState.lido && !userState.ocultado) {
          final notificacao = NotificacaoEadModel.fromMap(doc.data(), doc.id)
              .copyWith(lido: false);
          notificacoes.add(notificacao);
        }
      }
      return notificacoes;
    });
  }

  /// Marca uma notificação como lida
  Future<bool> marcarComoLida(String notificacaoId, String usuarioId) async {
    try {
      final doc = await _notificacoesCollection.doc(notificacaoId).get();
      if (!doc.exists) return false;

      final notificacao = NotificacaoEadModel.fromMap(doc.data()!, doc.id);

      // Busca estado atual do usuário
      final userStateDoc = await _notificacoesCollection
          .doc(notificacaoId)
          .collection('user_states')
          .doc(usuarioId)
          .get();

      final currentState = userStateDoc.exists
          ? UserNotificationState.fromMap(userStateDoc.data()!, usuarioId)
          : UserNotificationState(userId: usuarioId);

      // Só atualiza se ainda não foi lida
      if (!currentState.lido) {
        final newState = currentState.marcarComoLida();

        await _notificacoesCollection
            .doc(notificacaoId)
            .collection('user_states')
            .doc(usuarioId)
            .set(newState.toMap(), SetOptions(merge: true));

        // CRITICAL: Atualiza o documento principal para disparar o stream
        // Isso força o Firestore a emitir evento de mudança
        await _notificacoesCollection.doc(notificacaoId).update({
          'lastUpdated': FieldValue.serverTimestamp(),
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
          .where('destinatarios', arrayContains: usuarioId)
          .get();

      if (snapshot.docs.isEmpty) return true;

      final batch = _firestore.batch();
      final now = DateTime.now();

      for (final doc in snapshot.docs) {
        // Cria/atualiza user_state para marcar como lida
        final userStateRef = doc.reference.collection('user_states').doc(usuarioId);
        batch.set(
          userStateRef,
          {
            'lido': true,
            'dataLeitura': Timestamp.fromDate(now),
          },
          SetOptions(merge: true),
        );
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

  /// Oculta uma notificação para um usuário específico
  /// A notificação não é deletada, apenas marcada como ocultada para o usuário
  Future<bool> ocultarNotificacao(String notificacaoId, String usuarioId) async {
    try {
      debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Iniciando para $notificacaoId, usuário $usuarioId');

      final userStateRef = _notificacoesCollection
          .doc(notificacaoId)
          .collection('user_states')
          .doc(usuarioId);

      // Verificar se o documento da notificação existe
      final notificationDoc = await _notificacoesCollection.doc(notificacaoId).get();
      if (!notificationDoc.exists) {
        debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Documento não existe em notifications');
        return false;
      }

      debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Documento encontrado, buscando user_state');

      // Buscar estado atual do usuário para preservar campos como 'lido'
      final userStateDoc = await userStateRef.get();

      final currentState = userStateDoc.exists
          ? UserNotificationState.fromMap(userStateDoc.data()!, usuarioId)
          : UserNotificationState(userId: usuarioId);

      debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Estado atual - lido: ${currentState.lido}, ocultado: ${currentState.ocultado}');

      // Marca como ocultado preservando outros campos
      final newState = currentState.marcarComoOcultada();

      debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Novo estado - lido: ${newState.lido}, ocultado: ${newState.ocultado}');
      debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Salvando no Firestore: ${newState.toMap()}');

      await userStateRef.set(newState.toMap(), SetOptions(merge: true));

      // CRITICAL: Atualiza o documento principal para disparar o stream
      await _notificacoesCollection.doc(notificacaoId).update({
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      debugPrint('🟢 NotificacaoEadService.ocultarNotificacao: Salvo com sucesso e stream disparado!');
      return true;
    } catch (e) {
      debugPrint('Erro ao ocultar notificação: $e');
      return false;
    }
  }

  /// Exclui uma notificação (apenas para uso administrativo)
  /// IMPORTANTE: Isso remove permanentemente a notificação do Firestore
  /// Para usuários, use ocultarNotificacao() ao invés disso
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
  /// NOTA: Como 'lido' agora está em user_states, precisa iterar
  Future<int> contarNaoLidas(String usuarioId) async {
    try {
      final snapshot = await _notificacoesCollection
          .where('destinatarios', arrayContains: usuarioId)
          .get();

      int count = 0;
      for (final doc in snapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(usuarioId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, usuarioId)
            : null;

        // Conta se não lido e não ocultado
        if (!(userState?.lido ?? false) && !(userState?.ocultado ?? false)) {
          count++;
        }
      }

      return count;
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

  /// Notifica participantes quando discussão é fechada
  /// Envia notificação para todos que responderam (exceto quem fechou)
  Future<void> notificarDiscussaoFechada({
    required String discussaoId,
    required String discussaoTitulo,
    required List<String> destinatariosIds,
    required String remetenteId,
    String? cursoId,
  }) async {
    try {
      // Cria uma notificação para cada participante
      final batch = _firestore.batch();

      for (final destinatarioId in destinatariosIds) {
        final dadosNavegacao = {
          'discussaoId': discussaoId,
          if (cursoId != null) 'cursoId': cursoId,
        };

        final notificacaoData = {
          'titulo': 'Discussão Resolvida',
          'conteudo': 'A discussão "$discussaoTitulo" foi marcada como resolvida',
          'tipo': TipoNotificacaoEad.discussaoResolvida.value,
          'destinatarios': [destinatarioId], // Array ao invés de string
          'status': 'enviada',
          'dataCriacao': FieldValue.serverTimestamp(),
          'dataEnvio': FieldValue.serverTimestamp(),
          // Navegação estruturada
          'navegacao': {
            'tipo': 'discussao',
            'id': discussaoId,
            'dados': dadosNavegacao,
          },
          // Campos legados para compatibilidade
          'destinatarioId': destinatarioId,
          'relatedType': 'discussao',
          'relatedId': discussaoId,
          'remetenteId': remetenteId,
          'dados': dadosNavegacao,
        };

        final docRef = _notificacoesCollection.doc();
        batch.set(docRef, notificacaoData);
      }

      await batch.commit();

      // Incrementa contadores de cada destinatário
      for (final destinatarioId in destinatariosIds) {
        await _incrementarContador(destinatarioId, 'discussoesNaoLidas');
      }
    } catch (e) {
      debugPrint('Erro ao notificar discussão fechada: $e');
    }
  }
}
