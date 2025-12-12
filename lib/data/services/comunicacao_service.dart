import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:medita_bk/domain/models/ead/index.dart';
import 'notificacao_ead_service.dart';

/// Service para acesso ao Firebase do módulo de Comunicação (Tickets e Discussões)
/// Responsável por operações de leitura/escrita no Firestore
class ComunicacaoService {
  final FirebaseFirestore _firestore;
  final NotificacaoEadService _notificacaoService;

  ComunicacaoService({
    FirebaseFirestore? firestore,
    NotificacaoEadService? notificacaoService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificacaoService = notificacaoService ?? NotificacaoEadService();

  // === Collections ===

  CollectionReference<Map<String, dynamic>> get _ticketsCollection =>
      _firestore.collection('tickets');

  CollectionReference<Map<String, dynamic>> _mensagensCollection(
          String ticketId) =>
      _ticketsCollection.doc(ticketId).collection('mensagens');

  CollectionReference<Map<String, dynamic>> get _discussoesCollection =>
      _firestore.collection('discussoes');

  CollectionReference<Map<String, dynamic>> _respostasCollection(
          String discussaoId) =>
      _discussoesCollection.doc(discussaoId).collection('respostas');

  // === Tickets ===

  /// Busca todos os tickets do usuário
  Future<List<TicketModel>> getTicketsByUsuario(String usuarioId) async {
    try {
      final snapshot = await _ticketsCollection
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('dataCriacao', descending: true)
          .get();

      return snapshot.docs.map((doc) => TicketModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar tickets: $e');
      return [];
    }
  }

  /// Busca tickets abertos do usuário
  Future<List<TicketModel>> getTicketsAbertos(String usuarioId) async {
    try {
      final snapshot = await _ticketsCollection
          .where('usuarioId', isEqualTo: usuarioId)
          .where('status', whereIn: ['aberto', 'em_andamento', 'aguardando_resposta'])
          .orderBy('dataCriacao', descending: true)
          .get();

      return snapshot.docs.map((doc) => TicketModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar tickets abertos: $e');
      return [];
    }
  }

  /// Busca tickets fechados do usuário
  Future<List<TicketModel>> getTicketsFechados(String usuarioId) async {
    try {
      final snapshot = await _ticketsCollection
          .where('usuarioId', isEqualTo: usuarioId)
          .where('status', whereIn: ['resolvido', 'fechado'])
          .orderBy('dataCriacao', descending: true)
          .limit(50) // Limita a 50 tickets fechados
          .get();

      return snapshot.docs.map((doc) => TicketModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar tickets fechados: $e');
      return [];
    }
  }

  /// Busca um ticket pelo ID
  Future<TicketModel?> getTicketById(String ticketId) async {
    try {
      final doc = await _ticketsCollection.doc(ticketId).get();
      if (!doc.exists) return null;
      return TicketModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('Erro ao buscar ticket: $e');
      return null;
    }
  }

  /// Stream de um ticket específico
  Stream<TicketModel?> streamTicket(String ticketId) {
    return _ticketsCollection.doc(ticketId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TicketModel.fromFirestore(doc);
    });
  }

  /// Stream de tickets do usuário
  Stream<List<TicketModel>> streamTicketsByUsuario(String usuarioId) {
    return _ticketsCollection
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TicketModel.fromFirestore(doc)).toList());
  }

  /// Cria um novo ticket
  Future<String?> criarTicket({
    required String titulo,
    required String descricao,
    required CategoriaTicket categoria,
    required String usuarioId,
    required String usuarioNome,
    String? usuarioEmail,
    String? cursoId,
    String? cursoTitulo,
  }) async {
    try {
      // Gera o próximo número do ticket
      final numero = await _getProximoNumeroTicket();

      final ticketData = {
        'numero': numero,
        'titulo': titulo,
        'descricao': descricao,
        'categoria': categoria.name,
        'prioridade': PrioridadeTicket.media.name, // Padrão: média
        'status': StatusTicket.aberto.name,
        'usuarioId': usuarioId,
        'usuarioNome': usuarioNome,
        if (usuarioEmail != null) 'usuarioEmail': usuarioEmail,
        if (cursoId != null) 'cursoId': cursoId,
        if (cursoTitulo != null) 'cursoTitulo': cursoTitulo,
        'dataCriacao': FieldValue.serverTimestamp(),
        'dataAtualizacao': FieldValue.serverTimestamp(),
        'totalMensagens': 0,
      };

      final docRef = await _ticketsCollection.add(ticketData);
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao criar ticket: $e');
      return null;
    }
  }

  /// Gera o próximo número do ticket
  Future<int> _getProximoNumeroTicket() async {
    try {
      final snapshot = await _ticketsCollection
          .orderBy('numero', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return 1;

      final ultimoNumero = snapshot.docs.first.data()['numero'] as int? ?? 0;
      return ultimoNumero + 1;
    } catch (e) {
      debugPrint('Erro ao gerar número do ticket: $e');
      return DateTime.now().millisecondsSinceEpoch % 100000; // Fallback
    }
  }

  // === Mensagens ===

  /// Busca todas as mensagens de um ticket
  Future<List<TicketMensagemModel>> getMensagensByTicket(
      String ticketId) async {
    try {
      final snapshot = await _mensagensCollection(ticketId)
          .orderBy('dataCriacao', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => TicketMensagemModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar mensagens: $e');
      return [];
    }
  }

  /// Stream de mensagens de um ticket
  Stream<List<TicketMensagemModel>> streamMensagensByTicket(String ticketId) {
    return _mensagensCollection(ticketId)
        .orderBy('dataCriacao', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TicketMensagemModel.fromFirestore(doc))
            .toList());
  }

  /// Adiciona uma mensagem ao ticket
  Future<bool> adicionarMensagem({
    required String ticketId,
    required String conteudo,
    required String autorId,
    required String autorNome,
    required TipoAutor autorTipo,
    List<Map<String, dynamic>>? anexos,
  }) async {
    try {
      final mensagemData = {
        'ticketId': ticketId,
        'conteudo': conteudo,
        'autorId': autorId,
        'autorNome': autorNome,
        'autorTipo': autorTipo.name,
        'dataCriacao': FieldValue.serverTimestamp(),
        if (anexos != null && anexos.isNotEmpty) 'anexos': anexos,
      };

      await _mensagensCollection(ticketId).add(mensagemData);

      // Atualiza o contador de mensagens e data de atualização do ticket
      await _ticketsCollection.doc(ticketId).update({
        'totalMensagens': FieldValue.increment(1),
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });

      // Notifica o dono do ticket se quem respondeu não é o autor
      if (autorTipo != TipoAutor.aluno) {
        final ticket = await getTicketById(ticketId);
        if (ticket != null && ticket.usuarioId != autorId) {
          await _notificacaoService.notificarRespostaTicket(
            ticketId: ticketId,
            ticketNumero: ticket.numero.toString(),
            destinatarioId: ticket.usuarioId,
            remetenteId: autorId,
            remetenteNome: autorNome,
          );
        }
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao adicionar mensagem: $e');
      return false;
    }
  }

  /// Atualiza o status do ticket
  Future<bool> atualizarStatusTicket(
    String ticketId,
    StatusTicket novoStatus,
  ) async {
    try {
      // Busca ticket para notificação
      final ticket = await getTicketById(ticketId);

      final updateData = {
        'status': novoStatus.name,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      };

      // Se está fechando/resolvendo, adiciona a data de fechamento
      if (novoStatus == StatusTicket.fechado ||
          novoStatus == StatusTicket.resolvido) {
        updateData['dataFechamento'] = FieldValue.serverTimestamp();
      }

      await _ticketsCollection.doc(ticketId).update(updateData);

      // Notifica o dono do ticket quando resolvido
      if (ticket != null && novoStatus == StatusTicket.resolvido) {
        await _notificacaoService.notificarTicketResolvido(
          ticketId: ticketId,
          ticketNumero: ticket.numero.toString(),
          destinatarioId: ticket.usuarioId,
        );
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar status do ticket: $e');
      return false;
    }
  }

  // ============================================================
  // === DISCUSSÕES (Q&A) ===
  // ============================================================

  /// Busca discussões de um curso específico
  Future<List<DiscussaoModel>> getDiscussoesByCurso(
    String cursoId, {
    String? usuarioId,
    bool incluirPrivadas = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _discussoesCollection.where('cursoId', isEqualTo: cursoId);

      // Se não incluir privadas, filtra apenas públicas ou do próprio usuário
      if (!incluirPrivadas && usuarioId != null) {
        // Primeiro busca todas e filtra no cliente (Firestore não suporta OR complexo)
        final snapshot = await query.orderBy('dataCriacao', descending: true).get();

        return snapshot.docs
            .map((doc) => DiscussaoModel.fromMap(doc.data(), doc.id))
            .where((d) => !d.isPrivada || d.autorId == usuarioId)
            .toList();
      }

      final snapshot = await query.orderBy('dataCriacao', descending: true).get();

      return snapshot.docs
          .map((doc) => DiscussaoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar discussões do curso: $e');
      return [];
    }
  }

  /// Busca discussões criadas pelo usuário
  Future<List<DiscussaoModel>> getMinhasDiscussoes(String usuarioId) async {
    try {
      final snapshot = await _discussoesCollection
          .where('autorId', isEqualTo: usuarioId)
          .orderBy('dataCriacao', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DiscussaoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar minhas discussões: $e');
      return [];
    }
  }

  /// Busca uma discussão pelo ID
  Future<DiscussaoModel?> getDiscussaoById(String discussaoId) async {
    try {
      final doc = await _discussoesCollection.doc(discussaoId).get();
      if (!doc.exists) return null;
      return DiscussaoModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      debugPrint('Erro ao buscar discussão: $e');
      return null;
    }
  }

  /// Stream de uma discussão específica
  Stream<DiscussaoModel?> streamDiscussao(String discussaoId) {
    return _discussoesCollection.doc(discussaoId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return DiscussaoModel.fromMap(doc.data()!, doc.id);
    });
  }

  /// Stream de discussões de um curso
  Stream<List<DiscussaoModel>> streamDiscussoesByCurso(
    String cursoId, {
    String? usuarioId,
  }) {
    return _discussoesCollection
        .where('cursoId', isEqualTo: cursoId)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) {
      final discussoes = snapshot.docs
          .map((doc) => DiscussaoModel.fromMap(doc.data(), doc.id))
          .toList();

      // Filtra privadas (só mostra públicas ou do próprio usuário)
      if (usuarioId != null) {
        return discussoes
            .where((d) => !d.isPrivada || d.autorId == usuarioId)
            .toList();
      }

      return discussoes.where((d) => !d.isPrivada).toList();
    });
  }

  /// Cria uma nova discussão
  Future<String?> criarDiscussao({
    required String cursoId,
    required String cursoTitulo,
    String? aulaId,
    String? aulaTitulo,
    String? topicoId,
    String? topicoTitulo,
    required String titulo,
    required String conteudo,
    required String autorId,
    required String autorNome,
    String? autorFoto,
    bool isPrivada = false,
    List<String>? tags,
  }) async {
    try {
      final discussaoData = {
        'cursoId': cursoId,
        'cursoTitulo': cursoTitulo,
        if (aulaId != null) 'aulaId': aulaId,
        if (aulaTitulo != null) 'aulaTitulo': aulaTitulo,
        if (topicoId != null) 'topicoId': topicoId,
        if (topicoTitulo != null) 'topicoTitulo': topicoTitulo,
        'titulo': titulo,
        'conteudo': conteudo,
        'autorId': autorId,
        'autorNome': autorNome,
        if (autorFoto != null) 'autorFoto': autorFoto,
        'autorTipo': TipoAutor.aluno.name,
        'status': StatusDiscussao.aberta.name,
        'isPrivada': isPrivada,
        'isPinned': false,
        'isDestaque': false,
        'dataCriacao': FieldValue.serverTimestamp(),
        'dataAtualizacao': FieldValue.serverTimestamp(),
        'totalRespostas': 0,
        'tags': tags ?? [],
      };

      final docRef = await _discussoesCollection.add(discussaoData);
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao criar discussão: $e');
      return null;
    }
  }

  // === Respostas ===

  /// Busca respostas de uma discussão
  Future<List<RespostaDiscussaoModel>> getRespostasByDiscussao(
    String discussaoId,
  ) async {
    try {
      final snapshot = await _respostasCollection(discussaoId)
          .orderBy('dataCriacao', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => RespostaDiscussaoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar respostas: $e');
      return [];
    }
  }

  /// Stream de respostas de uma discussão
  Stream<List<RespostaDiscussaoModel>> streamRespostasByDiscussao(
    String discussaoId,
  ) {
    return _respostasCollection(discussaoId)
        .orderBy('dataCriacao', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RespostaDiscussaoModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Adiciona uma resposta à discussão
  Future<bool> adicionarResposta({
    required String discussaoId,
    required String conteudo,
    required String autorId,
    required String autorNome,
    String? autorFoto,
    required TipoAutor autorTipo,
  }) async {
    try {
      // Busca discussão para notificação
      final discussao = await getDiscussaoById(discussaoId);

      final respostaData = {
        'discussaoId': discussaoId,
        'conteudo': conteudo,
        'autorId': autorId,
        'autorNome': autorNome,
        if (autorFoto != null) 'autorFoto': autorFoto,
        'autorTipo': autorTipo.name,
        'isSolucao': false,
        'isResposta': false,
        'likes': 0,
        'likedBy': <String>[],
        'dataCriacao': FieldValue.serverTimestamp(),
      };

      await _respostasCollection(discussaoId).add(respostaData);

      // Atualiza contador e status da discussão
      await _discussoesCollection.doc(discussaoId).update({
        'totalRespostas': FieldValue.increment(1),
        'dataAtualizacao': FieldValue.serverTimestamp(),
        'status': StatusDiscussao.respondida.name,
      });

      // Notifica o autor da discussão (se não for ele mesmo respondendo)
      if (discussao != null && discussao.autorId != autorId) {
        await _notificacaoService.notificarRespostaDiscussao(
          discussaoId: discussaoId,
          discussaoTitulo: discussao.titulo,
          destinatarioId: discussao.autorId,
          remetenteId: autorId,
          remetenteNome: autorNome,
          cursoId: discussao.cursoId,
        );
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao adicionar resposta: $e');
      return false;
    }
  }

  /// Curtir/descurtir uma resposta
  Future<bool> toggleLikeResposta({
    required String discussaoId,
    required String respostaId,
    required String usuarioId,
    String? usuarioNome,
  }) async {
    try {
      final respostaRef = _respostasCollection(discussaoId).doc(respostaId);
      final doc = await respostaRef.get();

      if (!doc.exists) return false;

      final resposta = RespostaDiscussaoModel.fromMap(doc.data()!, doc.id);
      final likedBy = List<String>.from(doc.data()?['likedBy'] ?? []);
      final jaLiked = likedBy.contains(usuarioId);

      if (jaLiked) {
        // Descurtir
        likedBy.remove(usuarioId);
        await respostaRef.update({
          'likedBy': likedBy,
          'likes': FieldValue.increment(-1),
        });
      } else {
        // Curtir
        likedBy.add(usuarioId);
        await respostaRef.update({
          'likedBy': likedBy,
          'likes': FieldValue.increment(1),
        });

        // Notifica o autor da resposta (se não for ele mesmo curtindo)
        if (resposta.autorId != usuarioId && usuarioNome != null) {
          await _notificacaoService.notificarRespostaCurtida(
            discussaoId: discussaoId,
            respostaId: respostaId,
            destinatarioId: resposta.autorId,
            remetenteId: usuarioId,
            remetenteNome: usuarioNome,
          );
        }
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao toggle like: $e');
      return false;
    }
  }

  /// Marca uma resposta como solução (apenas autor da discussão ou admin)
  Future<bool> marcarComoSolucao({
    required String discussaoId,
    required String respostaId,
    required bool isSolucao,
    String? usuarioId,
    String? usuarioNome,
  }) async {
    try {
      // Busca discussão e resposta para notificação
      final discussao = await getDiscussaoById(discussaoId);
      final respostaDoc =
          await _respostasCollection(discussaoId).doc(respostaId).get();

      // Se está marcando como solução, desmarca as outras
      if (isSolucao) {
        final respostas = await _respostasCollection(discussaoId)
            .where('isSolucao', isEqualTo: true)
            .get();

        for (final doc in respostas.docs) {
          await doc.reference.update({
            'isSolucao': false,
            'isResposta': false,
          });
        }
      }

      // Atualiza a resposta selecionada
      await _respostasCollection(discussaoId).doc(respostaId).update({
        'isSolucao': isSolucao,
        'isResposta': isSolucao,
      });

      // Atualiza o status da discussão
      await _discussoesCollection.doc(discussaoId).update({
        'status': isSolucao
            ? StatusDiscussao.fechada.name
            : StatusDiscussao.respondida.name,
        'dataAtualizacao': FieldValue.serverTimestamp(),
        if (isSolucao && usuarioId != null) 'fechadaPor': usuarioId,
        if (isSolucao) 'dataFechamento': FieldValue.serverTimestamp(),
      });

      // Notifica o autor da resposta (se não for ele mesmo marcando)
      if (isSolucao &&
          discussao != null &&
          respostaDoc.exists &&
          usuarioId != null &&
          usuarioNome != null) {
        final resposta =
            RespostaDiscussaoModel.fromMap(respostaDoc.data()!, respostaDoc.id);

        // Só notifica se quem marcou não é o autor da resposta
        if (resposta.autorId != usuarioId) {
          await _notificacaoService.notificarRespostaMarcadaSolucao(
            discussaoId: discussaoId,
            discussaoTitulo: discussao.titulo,
            respostaId: respostaId,
            destinatarioId: resposta.autorId,
            remetenteId: usuarioId,
            remetenteNome: usuarioNome,
          );
        }
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao marcar como solução: $e');
      return false;
    }
  }

  /// Fecha/marca discussão como resolvida (sem necessariamente marcar uma resposta)
  Future<bool> fecharDiscussao({
    required String discussaoId,
    required String usuarioId,
  }) async {
    try {
      // Busca discussão para verificar se o usuário é o autor
      final discussao = await getDiscussaoById(discussaoId);
      if (discussao == null || discussao.autorId != usuarioId) {
        debugPrint('Usuário não autorizado a fechar esta discussão');
        return false;
      }

      await _discussoesCollection.doc(discussaoId).update({
        'status': StatusDiscussao.fechada.name,
        'fechadaPor': usuarioId,
        'dataFechamento': FieldValue.serverTimestamp(),
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });

      // Busca participantes para notificar (quem respondeu)
      final respostas = await getRespostasByDiscussao(discussaoId);
      final participantes = respostas
          .map((r) => r.autorId)
          .where((id) => id != usuarioId)
          .toSet()
          .toList();

      // Notifica participantes que a discussão foi fechada
      if (participantes.isNotEmpty) {
        await _notificacaoService.notificarDiscussaoFechada(
          discussaoId: discussaoId,
          discussaoTitulo: discussao.titulo,
          destinatariosIds: participantes,
          remetenteId: usuarioId,
          cursoId: discussao.cursoId,
        );
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao fechar discussão: $e');
      return false;
    }
  }

  /// Reabre uma discussão fechada
  Future<bool> reabrirDiscussao({
    required String discussaoId,
    required String usuarioId,
  }) async {
    try {
      // Busca discussão para verificar se o usuário é o autor
      final discussao = await getDiscussaoById(discussaoId);
      if (discussao == null || discussao.autorId != usuarioId) {
        debugPrint('Usuário não autorizado a reabrir esta discussão');
        return false;
      }

      // Define o status baseado se tem respostas ou não
      final novoStatus = discussao.totalRespostas > 0
          ? StatusDiscussao.respondida
          : StatusDiscussao.aberta;

      await _discussoesCollection.doc(discussaoId).update({
        'status': novoStatus.name,
        'fechadaPor': null,
        'dataFechamento': null,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });

      // Desmarca qualquer resposta marcada como solução
      final respostas = await _respostasCollection(discussaoId)
          .where('isSolucao', isEqualTo: true)
          .get();

      for (final doc in respostas.docs) {
        await doc.reference.update({
          'isSolucao': false,
          'isResposta': false,
        });
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao reabrir discussão: $e');
      return false;
    }
  }

  /// Edita uma discussão (apenas autor)
  Future<bool> editarDiscussao({
    required String discussaoId,
    required String titulo,
    required String conteudo,
  }) async {
    try {
      await _discussoesCollection.doc(discussaoId).update({
        'titulo': titulo,
        'conteudo': conteudo,
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Discussão editada: $discussaoId');
      return true;
    } catch (e) {
      debugPrint('Erro ao editar discussão: $e');
      return false;
    }
  }

  /// Deleta uma discussão e todas suas respostas (apenas autor)
  Future<bool> deletarDiscussao({
    required String discussaoId,
  }) async {
    try {
      // Deleta todas as respostas primeiro
      final respostas = await _respostasCollection(discussaoId).get();
      for (final doc in respostas.docs) {
        await doc.reference.delete();
      }

      // Deleta a discussão
      await _discussoesCollection.doc(discussaoId).delete();

      debugPrint('✅ Discussão deletada: $discussaoId');
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar discussão: $e');
      return false;
    }
  }
}
