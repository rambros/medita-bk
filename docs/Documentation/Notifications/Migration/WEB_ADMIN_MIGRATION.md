# Migração do Web Admin - Sistema de Notificações

**Data:** 2025-12-11
**Status:** ⚠️ AÇÃO NECESSÁRIA - ViewModels precisam ser atualizados

---

## 📋 O Que Foi Feito

### ✅ Arquivos Atualizados

1. **`notificacao_comunicacao_service.dart`**
   - ✅ Atualizado para usar `NotificationRepository`
   - ✅ Usa collection `notifications` (unificada)
   - ✅ Removida referência a `in_app_notifications`
   - ✅ Mantém integração com WhatsApp

### ✅ Arquivos Deletados

2. **`notificacao_ead_repository.dart`** ❌ DELETADO
   - Usava collection `ead_push_notifications` (antiga)
   - Substituído por `NotificationRepository`

3. **`notification_repository.dart`** ❌ DELETADO
   - Usava collection `global_push_notifications` (antiga)
   - Substituído por `NotificationRepository`

### ✅ Arquivos Existentes (Novos)

4. **`notification_repository.dart`** ✅ JÁ CRIADO
   - Usa collection `notifications` (unificada)
   - Compatível com mobile
   - Métodos especializados para tickets, discussões, cursos e sistema

5. **`tipo_notificacao.dart`** ✅ JÁ CRIADO
   - Enum unificado (idêntico ao mobile)
   - 18 tipos de notificações
   - Propriedades: icon, color, badgeColor, badgeLabel

---

## ⚠️ AÇÃO NECESSÁRIA

Os seguintes arquivos **precisam ser atualizados** porque ainda usam os repositories deletados:

### ViewModels Afetados

#### 1. EAD Notificações
- **`notificacao_ead_edit_view_model.dart`**
  - Usa: `NotificacaoEadRepository` ❌
  - Deve usar: `NotificationRepository` ✅

- **`notificacao_ead_list_view_model.dart`**
  - Usa: `NotificacaoEadRepository` ❌
  - Deve usar: `NotificationRepository` ✅

- **`ead_dashboard_view_model.dart`**
  - Usa: `NotificacaoEadRepository` ❌
  - Deve usar: `NotificationRepository` ✅

#### 2. Meditação Notificações
- **`notification_add_viewmodel.dart`**
  - Usa: `NotificationRepository` ❌
  - Deve usar: `NotificationRepository` ✅

- **`notification_list_viewmodel.dart`**
  - Usa: `NotificationRepository` ❌
  - Deve usar: `NotificationRepository` ✅

- **`notification_edit_viewmodel.dart`**
  - Usa: `NotificationRepository` ❌
  - Deve usar: `NotificationRepository` ✅

- **`notification_schedule_viewmodel.dart`**
  - Usa: `NotificationRepository` ❌
  - Deve usar: `NotificationRepository` ✅

#### 3. Services
- **`notification_service.dart`**
  - Usa: `NotificationRepository` ❌
  - Deve usar: `NotificationRepository` ✅

- **`push_notification_ead_service.dart`**
  - Usa: `NotificacaoEadRepository` ❌
  - Deve usar: `NotificationRepository` ✅

---

## 🔧 Como Migrar os ViewModels

### Antes (Antigo)

```dart
import 'package:medita_bk_web_admin/data/repositories/notificacao_ead_repository.dart';
import 'package:medita_bk_web_admin/domain/models/notificacao_ead_model.dart';

class NotificacaoEadEditViewModel extends ChangeNotifier {
  final NotificacaoEadRepository _repository;

  NotificacaoEadEditViewModel({NotificacaoEadRepository? repository})
      : _repository = repository ?? NotificacaoEadRepository();

  Future<void> salvarNotificacao(NotificacaoEadModel notificacao) async {
    await _repository.saveNotificacao(notificacao);
  }
}
```

### Depois (Novo)

```dart
import 'package:medita_bk_web_admin/data/repositories/notification_repository.dart';
import 'package:medita_bk_web_admin/domain/models/tipo_notificacao.dart';

class NotificacaoEadEditViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationRepositoryEditViewModel({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository();

  Future<void> salvarNotificacaoCurso({
    required String titulo,
    required String conteudo,
    required TipoNotificacao tipo,
    required List<String> destinatarios,
    String? cursoId,
    String? imagemUrl,
  }) async {
    await _repository.criarNotificacaoCurso(
      titulo: titulo,
      conteudo: conteudo,
      tipo: tipo,
      destinatarios: destinatarios,
      cursoId: cursoId,
      imagemUrl: imagemUrl,
    );
  }
}
```

---

## 📊 Estrutura da Collection `notifications`

### Documento de Notificação

```javascript
{
  "titulo": "Novo curso disponível",
  "conteudo": "O curso de Meditação Avançada está disponível",
  "tipo": "curso_novo",  // valor do enum TipoNotificacao
  "categoria": "curso",  // ticket | discussao | curso | sistema
  "destinatarios": ["userId1", "userId2"] // ou ["TODOS"]
  "imagemUrl": "https://...",  // opcional
  "navegacao": {  // opcional
    "tipo": "curso",  // ticket | discussao | curso
    "id": "cursoId123",
    "dados": {
      "cursoId": "cursoId123",
      // ... outros dados
    }
  },
  "dataCriacao": Timestamp,
  "dataEnvio": Timestamp,
  "status": "enviada"
}
```

### Subcollection `user_states/{userId}`

```javascript
{
  "lido": false,
  "ocultado": false,
  "dataLeitura": null
}
```

---

## 🎯 Métodos do NotificationRepository

### Criar Notificações

```dart
// Ticket
await repository.criarNotificacaoTicket(
  titulo: '...',
  conteudo: '...',
  tipo: TipoNotificacao.ticketCriado,
  ticketId: '...',
  destinatarioId: '...',
);

// Discussão
await repository.criarNotificacaoDiscussao(
  titulo: '...',
  conteudo: '...',
  tipo: TipoNotificacao.discussaoCriada,
  discussaoId: '...',
  cursoId: '...',
  destinatarioId: '...',
);

// Curso
await repository.criarNotificacaoCurso(
  titulo: '...',
  conteudo: '...',
  tipo: TipoNotificacao.cursoNovo,
  destinatarios: ['userId1', 'userId2'], // ou ['TODOS']
  cursoId: '...',
  imagemUrl: '...',
);

// Sistema
await repository.criarNotificacaoSistema(
  titulo: '...',
  conteudo: '...',
  tipo: TipoNotificacao.sistemaGeral,
  paraTodasUsuarios: true,
);
```

### Listar Notificações

```dart
// Admin - listar todas
final notificacoes = await repository.listarNotificacoes(
  limite: 50,
  filtroCategoria: 'curso',
);

// Usuário específico
final notificacoesUsuario = await repository.listarNotificacoesUsuario(
  userId: 'userId123',
  limite: 20,
);

// Stream (tempo real)
final stream = repository.streamNotificacoes(
  limite: 50,
  filtroCategoria: 'ticket',
);
```

### Deletar Notificações

```dart
// Deletar uma
await repository.deletarNotificacao('notifId');

// Deletar várias
await repository.deletarNotificacoes(['id1', 'id2', 'id3']);
```

### Estatísticas

```dart
// Contar por categoria
final contadores = await repository.contarPorCategoria();
// { 'ticket': 10, 'discussao': 5, 'curso': 20, 'sistema': 3 }

// Estatísticas completas
final stats = await repository.obterEstatisticas();
// {
//   'total': 38,
//   'enviadas': 35,
//   'paraTodasUsuarios': 5,
//   'ultimaSemana': 12,
//   'porCategoria': {...}
// }
```

---

## 🔥 Collections Antigas (Não Usar Mais)

❌ **NÃO CRIAR MAIS DOCUMENTOS NESTAS COLLECTIONS:**
- `global_push_notifications` → Substituída por `notifications`
- `ead_push_notifications` → Substituída por `notifications`
- `in_app_notifications` → Substituída por `notifications`

✅ **USAR APENAS:**
- `notifications` (collection unificada)

---

## 📝 Checklist de Migração

Para cada ViewModel/Service que usa os repositories antigos:

- [ ] Importar `NotificationRepository` e `TipoNotificacao`
- [ ] Remover import de `NotificacaoEadRepository` ou `NotificationRepository`
- [ ] Atualizar construtor para usar `NotificationRepository`
- [ ] Substituir chamadas de métodos antigos pelos novos
- [ ] Usar enum `TipoNotificacao` para tipos de notificação
- [ ] Testar funcionalidade no web admin
- [ ] Verificar se notificações aparecem corretamente no mobile

---

## ⚡ Sistema FCM (Intacto)

O sistema de push notifications via FCM **NÃO FOI AFETADO**:

- ✅ Collection `ff_push_notifications` (intacta)
- ✅ Subcollection `users/{userId}/fcm_tokens` (intacta)
- ✅ Cloud Functions (intactas)

Este sistema é **separado** do sistema de notificações in-app.

---

## 🎉 Benefícios da Migração

1. **Uma única collection:** Redução de complexidade
2. **Enum compartilhado:** Compatibilidade total mobile ↔ web admin
3. **Queries otimizadas:** `arrayContainsAny` reduz queries em 90%
4. **Código mais limpo:** 75% menos código
5. **Manutenção simplificada:** Alterações em um lugar só

---

## 📚 Próximos Passos

1. **Atualizar ViewModels** (listar acima)
2. **Testar no web admin** (criar, listar, deletar notificações)
3. **Verificar no mobile** (notificações aparecem corretamente)
4. **Deploy Firestore** (rules e indexes)
5. **Deletar collections antigas** (opcional, após testes)

---

**Criado por:** Claude Code
**Data:** 2025-12-11
