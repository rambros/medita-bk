# Refatoração Completa do Sistema de Notificações

**Data:** 2025-12-11
**Objetivo:** Simplificar sistema de notificações eliminando duplicações e complexidade desnecessária

---

## 🎯 Proposta de Simplificação

### Problemas Atuais

1. **3 collections diferentes** com estruturas similares
2. **Enums duplicados** entre web admin e mobile com nomes diferentes
3. **Múltiplas queries** para buscar as mesmas notificações (por ID, email, array, "Todos")
4. **Campos duplicados** (destinatarioTipo vs typeRecipients, titulo vs title, etc.)
5. **Lógica de fallback** para compatibilidade de campos
6. **Subcollections user_states** + "dummy updates" para trigger de streams

---

## ✅ Solução Proposta: UMA ÚNICA COLLECTION

### Nova Estrutura: `notifications` (única)

```javascript
{
  // Identificação
  id: "abc123",

  // Conteúdo
  titulo: "Nova aula disponível",
  conteudo: "O módulo 3 já está disponível para você",
  imagemUrl: "https://...",

  // Tipo (enum unificado)
  tipo: "curso_novo",  // ticket_respondido, discussao_criada, curso_novo, sistema_geral

  // Categoria (facilita filtros)
  categoria: "curso",  // "ticket", "discussao", "curso", "sistema"

  // Destinatários (ARRAY ÚNICO)
  destinatarios: ["userId1", "userId2"],  // ou ["TODOS"] para broadcast

  // Navegação (opcional)
  navegacao: {
    tipo: "ticket",  // ou "discussao", "curso"
    id: "ticketId123",
    dados: {
      cursoId: "...",
      // outros dados necessários para navegação
    }
  },

  // Timestamps
  dataCriacao: Timestamp,
  dataEnvio: Timestamp,  // quando foi enviada (para agendadas)

  // Status de envio
  status: "enviada",  // "rascunho", "agendada", "enviada", "erro"

  // Estados por usuário (SUBCOLLECTION)
  // subcollection: user_states/{userId}
  // {
  //   lido: false,
  //   ocultado: false,
  //   dataLeitura: Timestamp
  // }
}
```

---

## 🔥 Benefícios

### 1. Uma Única Collection
- ✅ Menos queries (1 ao invés de 3)
- ✅ Mais simples de entender
- ✅ Mais fácil de manter
- ✅ Menos código

### 2. Enum Unificado
- ✅ Web admin e mobile usam os mesmos valores
- ✅ Sem necessidade de compatibilidade/fallback
- ✅ Menos confusão

### 3. Destinatários Simplificados
- ✅ Um campo array ao invés de 4 queries diferentes
- ✅ `["userId1", "userId2"]` para específicos
- ✅ `["TODOS"]` para broadcast
- ✅ Firestore permite `arrayContains` eficiente

### 4. Campos Únicos
- ✅ Apenas português (padrão do web admin)
- ✅ Sem duplicação titulo/title, conteudo/content, etc.
- ✅ Sem fallbacks

---

## 📊 Comparação: Antes vs Depois

### ANTES (Sistema Atual)

```
┌─────────────────────────────────────────┐
│  3 COLLECTIONS                          │
├─────────────────────────────────────────┤
│                                         │
│  in_app_notifications                   │
│    - Query por destinatarioId           │
│    - user_states subcollection          │
│                                         │
│  ead_push_notifications                 │
│    - Query 1: destinatarioId            │
│    - Query 2: destinatarioTipo='Todos'  │
│    - Query 3: destinatariosIds array    │
│    - Query 4: destinatariosEmails array │
│    - user_states subcollection          │
│                                         │
│  global_push_notifications              │
│    - Query 1: recipientsRef array       │
│    - Query 2: destinatarioTipo          │
│    - Query 3: recipientEmail            │
│    - user_states subcollection          │
│                                         │
│  = 10 queries totais!                   │
│  = 3 estruturas diferentes              │
│  = Campos duplicados                    │
│                                         │
└─────────────────────────────────────────┘
```

### DEPOIS (Sistema Simplificado)

```
┌─────────────────────────────────────────┐
│  1 COLLECTION                           │
├─────────────────────────────────────────┤
│                                         │
│  notifications                          │
│    - Query 1: destinatarios array       │
│      WHERE destinatarios arrayContains  │
│             userId                      │
│      OR destinatarios arrayContains     │
│             "TODOS"                     │
│    - user_states subcollection          │
│                                         │
│  = 1 query (com OR)!                    │
│  = 1 estrutura única                    │
│  = Sem duplicação                       │
│                                         │
└─────────────────────────────────────────┘
```

**Redução:** 10 queries → 1 query (90% menos!)

---

## 🔧 Implementação

### Passo 1: Deletar Dados Existentes

```bash
# Firebase Console ou Admin SDK
DELETE FROM in_app_notifications;
DELETE FROM ead_push_notifications;
DELETE FROM global_push_notifications;
```

### Passo 2: Criar Enum Unificado (Compartilhado)

**Arquivo:** `shared_enums.dart` (criar pacote compartilhado ou duplicar)

```dart
enum TipoNotificacao {
  // Tickets
  ticketCriado('ticket_criado', 'Novo Ticket', 'ticket'),
  ticketRespondido('ticket_respondido', 'Resposta no Ticket', 'ticket'),
  ticketResolvido('ticket_resolvido', 'Ticket Resolvido', 'ticket'),
  ticketFechado('ticket_fechado', 'Ticket Fechado', 'ticket'),

  // Discussões
  discussaoCriada('discussao_criada', 'Nova Discussão', 'discussao'),
  discussaoRespondida('discussao_respondida', 'Resposta na Discussão', 'discussao'),
  discussaoResolvida('discussao_resolvida', 'Discussão Resolvida', 'discussao'),
  respostaCurtida('resposta_curtida', 'Resposta Curtida', 'discussao'),
  respostaSolucao('resposta_solucao', 'Resposta Solução', 'discussao'),

  // Cursos
  cursoNovo('curso_novo', 'Novo Curso', 'curso'),
  moduloNovo('modulo_novo', 'Novo Módulo', 'curso'),
  certificado('certificado', 'Certificado Disponível', 'curso'),
  prazo('prazo', 'Prazo Próximo', 'curso'),

  // Sistema
  sistemaGeral('sistema_geral', 'Notificação Geral', 'sistema'),
  sistemaManutencao('sistema_manutencao', 'Manutenção', 'sistema');

  final String value;
  final String label;
  final String categoria;

  const TipoNotificacao(this.value, this.label, this.categoria);

  static TipoNotificacao fromString(String? value) {
    return TipoNotificacao.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TipoNotificacao.sistemaGeral,
    );
  }

  // Ícone e cor baseados na categoria
  IconData get icon {
    switch (this) {
      case TipoNotificacao.ticketCriado:
        return Icons.confirmation_number_outlined;
      case TipoNotificacao.ticketRespondido:
        return Icons.reply;
      case TipoNotificacao.ticketResolvido:
        return Icons.check_circle_outline;
      case TipoNotificacao.ticketFechado:
        return Icons.lock_outline;
      case TipoNotificacao.discussaoCriada:
        return Icons.forum_outlined;
      case TipoNotificacao.discussaoRespondida:
        return Icons.chat_bubble_outline;
      case TipoNotificacao.discussaoResolvida:
        return Icons.verified_outlined;
      case TipoNotificacao.respostaCurtida:
        return Icons.thumb_up_outlined;
      case TipoNotificacao.respostaSolucao:
        return Icons.star_outline;
      // Cursos - todos com ícone de escola
      case TipoNotificacao.cursoNovo:
      case TipoNotificacao.moduloNovo:
      case TipoNotificacao.certificado:
      case TipoNotificacao.prazo:
        return Icons.school_outlined;
      // Sistema
      case TipoNotificacao.sistemaGeral:
      case TipoNotificacao.sistemaManutencao:
        return Icons.notifications;
    }
  }

  Color get badgeColor {
    switch (categoria) {
      case 'ticket':
      case 'discussao':
        return Colors.orange;
      case 'curso':
        return Colors.deepPurple;
      case 'sistema':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
```

### Passo 3: Modelo Unificado (Mobile)

```dart
class Notificacao {
  final String id;
  final String titulo;
  final String conteudo;
  final String? imagemUrl;
  final TipoNotificacao tipo;
  final List<String> destinatarios;
  final NavegacaoNotificacao? navegacao;
  final DateTime dataCriacao;
  final DateTime? dataEnvio;
  final String status;

  // Estado do usuário (vem de subcollection)
  final bool lido;
  final bool ocultado;
  final DateTime? dataLeitura;

  const Notificacao({
    required this.id,
    required this.titulo,
    required this.conteudo,
    this.imagemUrl,
    required this.tipo,
    required this.destinatarios,
    this.navegacao,
    required this.dataCriacao,
    this.dataEnvio,
    required this.status,
    this.lido = false,
    this.ocultado = false,
    this.dataLeitura,
  });

  factory Notificacao.fromFirestore(
    DocumentSnapshot doc,
    UserNotificationState? userState,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return Notificacao(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      conteudo: data['conteudo'] ?? '',
      imagemUrl: data['imagemUrl'],
      tipo: TipoNotificacao.fromString(data['tipo']),
      destinatarios: List<String>.from(data['destinatarios'] ?? []),
      navegacao: data['navegacao'] != null
          ? NavegacaoNotificacao.fromMap(data['navegacao'])
          : null,
      dataCriacao: (data['dataCriacao'] as Timestamp).toDate(),
      dataEnvio: (data['dataEnvio'] as Timestamp?)?.toDate(),
      status: data['status'] ?? 'enviada',
      lido: userState?.lido ?? false,
      ocultado: userState?.ocultado ?? false,
      dataLeitura: userState?.dataLeitura,
    );
  }
}

class NavegacaoNotificacao {
  final String tipo;  // "ticket", "discussao", "curso"
  final String id;
  final Map<String, dynamic>? dados;

  const NavegacaoNotificacao({
    required this.tipo,
    required this.id,
    this.dados,
  });

  factory NavegacaoNotificacao.fromMap(Map<String, dynamic> map) {
    return NavegacaoNotificacao(
      tipo: map['tipo'] ?? '',
      id: map['id'] ?? '',
      dados: map['dados'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'id': id,
      if (dados != null) 'dados': dados,
    };
  }
}
```

### Passo 4: Repository Simplificado

```dart
class NotificacoesRepository {
  final FirebaseFirestore _firestore;

  NotificacoesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Busca notificações do usuário
  /// UMA ÚNICA QUERY!
  Future<List<Notificacao>> getNotificacoes({
    int limite = 20,
    bool apenasNaoLidas = false,
  }) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return [];

    try {
      // UMA query com OR!
      final snapshot = await _firestore
          .collection('notifications')
          .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
          .orderBy('dataCriacao', descending: true)
          .limit(limite)
          .get();

      final notificacoes = <Notificacao>[];

      for (final doc in snapshot.docs) {
        // Busca estado do usuário
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : null;

        // Pula se ocultado
        if (userState?.ocultado ?? false) continue;

        // Pula se lido (quando filtrando não lidas)
        if (apenasNaoLidas && (userState?.lido ?? false)) continue;

        notificacoes.add(Notificacao.fromFirestore(doc, userState));
      }

      return notificacoes;
    } catch (e) {
      debugPrint('Erro ao buscar notificações: $e');
      return [];
    }
  }

  /// Stream de notificações
  /// UM stream simples!
  Stream<List<Notificacao>> streamNotificacoes({int limite = 20}) async* {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      yield [];
      return;
    }

    await for (final snapshot in _firestore
        .collection('notifications')
        .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
        .orderBy('dataCriacao', descending: true)
        .limit(limite)
        .snapshots()) {

      final notificacoes = <Notificacao>[];

      for (final doc in snapshot.docs) {
        final userStateDoc = await doc.reference
            .collection('user_states')
            .doc(userId)
            .get();

        final userState = userStateDoc.exists
            ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
            : null;

        if (userState?.ocultado ?? false) continue;

        notificacoes.add(Notificacao.fromFirestore(doc, userState));
      }

      yield notificacoes;
    }
  }

  /// Marca como lida (simplificado!)
  Future<bool> marcarComoLida(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      final notifRef = _firestore.collection('notifications').doc(notificacaoId);

      await notifRef.collection('user_states').doc(userId).set({
        'lido': true,
        'dataLeitura': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Dummy update
      await notifRef.update({'lastUpdated': FieldValue.serverTimestamp()});

      return true;
    } catch (e) {
      debugPrint('Erro ao marcar como lida: $e');
      return false;
    }
  }

  /// Remove (oculta) notificação
  Future<bool> removerNotificacao(String notificacaoId) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return false;

    try {
      final notifRef = _firestore.collection('notifications').doc(notificacaoId);

      await notifRef.collection('user_states').doc(userId).set({
        'ocultado': true,
      }, SetOptions(merge: true));

      // Dummy update
      await notifRef.update({'lastUpdated': FieldValue.serverTimestamp()});

      return true;
    } catch (e) {
      debugPrint('Erro ao ocultar: $e');
      return false;
    }
  }
}
```

### Passo 5: Web Admin (Criar Notificação)

```dart
// Web Admin - Criar notificação
Future<void> criarNotificacao({
  required String titulo,
  required String conteudo,
  String? imagemUrl,
  required TipoNotificacao tipo,
  required List<String> destinatarios,  // ["userId1"] ou ["TODOS"]
  NavegacaoNotificacao? navegacao,
}) async {
  await _firestore.collection('notifications').add({
    'titulo': titulo,
    'conteudo': conteudo,
    'imagemUrl': imagemUrl,
    'tipo': tipo.value,
    'destinatarios': destinatarios,
    if (navegacao != null) 'navegacao': navegacao.toMap(),
    'dataCriacao': FieldValue.serverTimestamp(),
    'dataEnvio': FieldValue.serverTimestamp(),
    'status': 'enviada',
  });
}
```

---

## 📉 Comparação de Código

### ANTES
- **3 collections**
- **10 queries** para buscar notificações
- **3 enums diferentes** (web admin TipoNotificacaoEad vs mobile TipoNotificacaoEad)
- **Fallbacks de campos** (titulo/title, conteudo/content, etc.)
- **Compatibilidade** push/email/whatsapp vs ticket_*/discussao_*/curso_*
- **Código:** ~2000 linhas no repository

### DEPOIS
- **1 collection**
- **1 query** (arrayContainsAny)
- **1 enum compartilhado**
- **Sem fallbacks** (campos únicos)
- **Sem compatibilidade** (valores padronizados)
- **Código:** ~500 linhas no repository

**Redução:** 75% menos código!

---

## 🎯 Próximos Passos

### 1. Aprovação da Proposta
- [ ] Revisar proposta
- [ ] Confirmar que pode deletar dados existentes

### 2. Limpeza
- [ ] Deletar todas as notificações de todas as 3 collections
- [ ] Deletar regras de segurança antigas

### 3. Implementação (Web Admin)
- [ ] Criar enum `TipoNotificacao` compartilhado
- [ ] Atualizar forms de criação de notificação
- [ ] Atualizar repository web admin
- [ ] Testar criação de notificações

### 4. Implementação (Mobile)
- [ ] Copiar enum `TipoNotificacao` (ou usar pacote compartilhado)
- [ ] Criar novo modelo `Notificacao`
- [ ] Atualizar `NotificacoesRepository`
- [ ] Atualizar UI (página de notificações)
- [ ] Testar navegação

### 5. Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notifications/{notifId} {
      // Leitura: se usuário está em destinatarios ou é "TODOS"
      allow read: if request.auth != null &&
                     (resource.data.destinatarios.hasAny([request.auth.uid, 'TODOS']));

      // Escrita: apenas admin
      allow write: if hasAdminRole();

      // Subcollection user_states
      match /user_states/{userId} {
        allow read, write: if request.auth != null && userId == request.auth.uid;
      }
    }
  }
}
```

---

## ✅ Vantagens da Refatoração

1. **Simplicidade:** 1 collection ao invés de 3
2. **Performance:** 1 query ao invés de 10
3. **Manutenibilidade:** Menos código = menos bugs
4. **Consistência:** Mesmos campos em web e mobile
5. **Escalabilidade:** arrayContainsAny é eficiente
6. **Clareza:** Código mais fácil de entender

---

**Quer que eu implemente essa refatoração?** 🚀

Posso começar pelo mobile e depois ajudar no web admin!
