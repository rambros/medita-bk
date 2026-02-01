import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/models/ead/index.dart';

/// Repositório para gerenciar avaliações de cursos
class AvaliacaoRepository {
  final FirebaseFirestore _firestore;

  AvaliacaoRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // === Buscar Avaliação do Curso ===

  /// Busca a configuração de avaliação de um curso
  Future<AvaliacaoCursoModel?> getAvaliacaoCurso(String cursoId) async {
    try {
      final doc = await _firestore.collection('cursos').doc(cursoId).get();

      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      // Avaliação está dentro do documento do curso
      final avaliacaoMap = data['avaliacao'] as Map<String, dynamic>?;
      if (avaliacaoMap == null) return null;

      return AvaliacaoCursoModel.fromMap(avaliacaoMap);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar avaliação do curso: $e');
      }
      return null;
    }
  }

  // === Verificar se Aluno Já Respondeu ===

  /// Verifica se o aluno já preencheu a avaliação
  Future<bool> jaRespondeu(String inscricaoId) async {
    try {
      final doc = await _firestore.collection('avaliacoes_cursos').doc(inscricaoId).get();

      return doc.exists;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar se já respondeu: $e');
      }
      return false;
    }
  }

  // === Buscar Resposta do Aluno ===

  /// Busca a resposta de avaliação do aluno
  Future<RespostaAvaliacaoModel?> getResposta(String inscricaoId) async {
    try {
      final doc = await _firestore.collection('avaliacoes_cursos').doc(inscricaoId).get();

      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      return RespostaAvaliacaoModel.fromMap(data, doc.id);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar resposta: $e');
      }
      return null;
    }
  }

  // === Salvar Resposta ===

  /// Salva a resposta da avaliação do aluno
  Future<void> salvarResposta(RespostaAvaliacaoModel resposta) async {
    try {
      // Salvar resposta na collection avaliacoes_cursos
      await _firestore.collection('avaliacoes_cursos').doc(resposta.inscricaoId).set(resposta.toMap());

      // Atualizar flag na inscrição
      await _firestore.collection('inscricoes_cursos').doc(resposta.inscricaoId).update({
        'avaliacaoPreenchida': true,
        'dataAvaliacaoPreenchida': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Resposta de avaliação salva com sucesso: ${resposta.inscricaoId}');
      }

      // Tentar enviar notificação por email (não bloqueante)
      _notificarAdmins(resposta).catchError((e) {
        if (kDebugMode) {
          print('Erro ao enviar notificação de avaliação: $e');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar resposta: $e');
      }
      rethrow;
    }
  }

  // === Validar Respostas ===

  /// Valida se todas as perguntas obrigatórias foram respondidas
  bool validarRespostas({required AvaliacaoCursoModel avaliacao, required Map<String, dynamic> respostas}) {
    // Pegar apenas perguntas obrigatórias
    final obrigatorias = avaliacao.perguntasObrigatorias;

    // Verificar se todas foram respondidas
    for (final pergunta in obrigatorias) {
      final resposta = respostas[pergunta.id];

      // Se não tem resposta, inválido
      if (resposta == null) return false;

      // Se é string vazia, inválido
      if (resposta is String && resposta.trim().isEmpty) return false;

      // Para emoji scale, verificar se é número válido (1-5)
      if (pergunta.tipo == TipoPerguntaAvaliacao.emojiScale) {
        if (resposta is! int || resposta < 1 || resposta > 5) return false;
      }
    }

    return true;
  }

  /// Calcula o percentual de perguntas respondidas
  double calcularProgresso({required AvaliacaoCursoModel avaliacao, required Map<String, dynamic> respostas}) {
    if (avaliacao.totalPerguntas == 0) return 0;

    int respondidas = 0;
    for (final pergunta in avaliacao.perguntas) {
      final resposta = respostas[pergunta.id];
      if (resposta != null) {
        if (resposta is String && resposta.trim().isNotEmpty) {
          respondidas++;
        } else if (resposta is! String) {
          respondidas++;
        }
      }
    }

    return (respondidas / avaliacao.totalPerguntas) * 100;
  }
  // === Notificações ===

  /// Envia email de notificação para admins
  Future<void> _notificarAdmins(RespostaAvaliacaoModel resposta) async {
    try {
      // 1. Buscar configurações do curso
      final cursoDoc = await _firestore.collection('cursos').doc(resposta.cursoId).get();
      if (!cursoDoc.exists) return;

      final cursoData = cursoDoc.data();
      if (cursoData == null) return;

      final notificar = cursoData['notificarAvaliacao'] as bool? ?? false;
      final emailsDynamic = cursoData['emailsNotificacao'] as List<dynamic>? ?? [];
      final emails = emailsDynamic.map((e) => e.toString()).toList();

      if (!notificar || emails.isEmpty) return;

      // 2. Buscar configurações do Resend
      final settingsDoc = await _firestore.collection('settings').doc('app_settings').get();
      if (!settingsDoc.exists) {
        if (kDebugMode) print('Configurações do app não encontradas');
        return;
      }

      final settingsData = settingsDoc.data();
      final apiKey = settingsData?['resendApiKey'] as String?;
      final fromEmail = settingsData?['resendFromEmail'] as String?;
      final fromName = settingsData?['resendFromName'] as String? ?? 'Brahma Kumaris EAD';

      if (apiKey == null || apiKey.isEmpty || fromEmail == null || fromEmail.isEmpty) {
        if (kDebugMode) print('Configurações do Resend incompletas');
        return;
      }

      // 3. Montar email
      final assunto = 'Nova Avaliação: ${resposta.usuarioNome}';

      final now = DateTime.now();
      final horaFormatada = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      final dataFormatada =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} às $horaFormatada';

      // Buscar definições das perguntas
      final avaliacaoMap = cursoData['avaliacao'] as Map<String, dynamic>?;
      final avaliacao = AvaliacaoCursoModel.fromMap(avaliacaoMap);

      // Criar mapa de ID -> Texto da Pergunta
      final perguntasMap = <String, String>{};
      for (final p in avaliacao.perguntas) {
        perguntasMap[p.id] = p.texto;
      }

      String corpoHtml = '<h2>Nova avaliação recebida</h2>';
      corpoHtml += '<p><strong>Aluno:</strong> ${resposta.usuarioNome} (${resposta.usuarioEmail})</p>';
      corpoHtml += '<p><strong>Data:</strong> $dataFormatada</p>';

      // Título do curso (se disponível)
      final tituloCurso = cursoData['titulo'] as String? ?? 'Curso sem título';
      corpoHtml += '<p><strong>Curso:</strong> $tituloCurso</p>';

      corpoHtml += '<h3>Respostas:</h3><ul>';

      resposta.respostas.forEach((perguntaId, valor) {
        final textoPergunta = perguntasMap[perguntaId] ?? 'Pergunta ($perguntaId)';
        corpoHtml += '<li style="margin-bottom: 10px;">';
        corpoHtml += '<div><strong>$textoPergunta</strong></div>';
        corpoHtml += '<div style="margin-top: 4px;">$valor</div>';
        corpoHtml += '</li>';
      });
      corpoHtml += '</ul>';

      // 4. Enviar via Resend
      final url = Uri.parse('https://api.resend.com/emails');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        body: jsonEncode({'from': '$fromName <$fromEmail>', 'to': emails, 'subject': assunto, 'html': corpoHtml}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (kDebugMode) print('Email de notificação enviado com sucesso');
      } else {
        if (kDebugMode) print('Erro ao enviar email: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro interno ao notificar admins: $e');
      }
      // Não rethrow para não falhar o salvamento da resposta
    }
  }
}
