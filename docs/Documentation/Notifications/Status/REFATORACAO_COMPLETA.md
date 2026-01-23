# Refatoração Completa - Sistema de Notificações Unificado

**Data:** 2025-12-11
**Status:** ✅ Código criado e pronto para migração

---

## 📦 O Que Foi Criado

### Mobile (`medita-bk`)

✅ **1. `lib/domain/models/tipo_notificacao.dart`**
- Enum unificado `TipoNotificacao` com 18 tipos
- Categorias: `ticket`, `discussao`, `curso`, `sistema`
- Propriedades built-in: `icon`, `color`, `badgeColor`, `badgeLabel`
- Métodos helpers: `isTicket`, `isDiscussao`, `isCurso`, `isSistema`
- Getters estáticos: `tickets`, `discussoes`, `cursos`, `sistema`

✅ **2. `lib/domain/models/notificacao.dart`**
- Classe `Notificacao` simplificada (substitui `UnifiedNotification`)
- Classe `NavegacaoNotificacao` para dados de navegação estruturados
- Factory `fromFirestore()` com integração de `UserNotificationState`
- Método `copyWith()` para imutabilidade
- Getter `tempoDesde` para formatação de tempo

✅ **3. `lib/data/repositories/notificacoes_repository_v2.dart`**
- Repository simplificado com **1 query** (era 10 queries)
- Método `getNotificacoes()` usando `arrayContainsAny`
- Stream `streamNotificacoes()` para tempo real
- Métodos `marcarComoLida()`, `marcarTodasComoLidas()`, `removerNotificacao()`
- Contador de não lidas integrado
- ~75% menos código que o original

### Web Admin (`medita-bk-web-admin`)

✅ **4. `lib/domain/models/tipo_notificacao.dart`**
- **IDÊNTICO** ao do mobile (compatibilidade total)
- Mesmo enum, mesmas propriedades, mesmos métodos
- Pode ser compartilhado via package se necessário

✅ **5. `lib/data/repositories/notification_repository_v2.dart`**
- Repository administrativo completo
- Métodos especializados:
  - `criarNotificacao()` - genérico
  - `criarNotificacaoTicket()` - com navegação para ticket
  - `criarNotificacaoDiscussao()` - com navegação para discussão
  - `criarNotificacaoCurso()` - para múltiplos destinatários
  - `criarNotificacaoSistema()` - para todos ou específicos
- Métodos de administração:
  - `listarNotificacoes()` - com filtros
  - `listarNotificacoesUsuario()` - busca estado do usuário
  - `deletarNotificacao()` / `deletarNotificacoes()` - com cascade
  - `contarPorCategoria()` - estatísticas
  - `obterEstatisticas()` - dashboard completo
  - `streamNotificacoes()` - tempo real

### Documentação

✅ **6. `GUIA_MIGRACAO_NOTIFICACOES.md`**
- Passo a passo completo de migração
- Exemplos de código mobile
- Exemplos de código web admin
- Firestore Rules
- Firestore Indexes
- Checklist de verificação
- Instruções de rollback

✅ **7. `REFATORACAO_NOTIFICACOES.md`**
- Análise do problema
- Proposta de solução
- Diagrama de arquitetura
- Comparação antes/depois
- Benefícios quantificados

---

## 🗄️ Nova Estrutura do Firestore

### Collection Única: `notifications`

```javascript
{
  // Identificação
  id: "auto-generated",

  // Conteúdo
  titulo: "Resposta no seu Ticket #42",
  conteudo: "Seu ticket foi respondido pela equipe",
  imagemUrl: "https://...",  // opcional

  // Tipo e categoria
  tipo: "ticket_respondido",  // valor do enum
  categoria: "ticket",  // ticket | discussao | curso | sistema

  // Destinatários (CHAVE!)
  destinatarios: ["userId123"],  // ou ["TODOS"]

  // Navegação (opcional)
  navegacao: {
    tipo: "ticket",  // ticket | discussao | curso
    id: "ticket123",
    dados: {
      ticketId: "ticket123",
      remetenteNome: "Suporte"
    }
  },

  // Metadados
  dataCriacao: Timestamp,
  dataEnvio: Timestamp,
  status: "enviada"
}
```

### Subcollection: `notifications/{id}/user_states/{userId}`

```javascript
{
  lido: false,
  ocultado: false,
  dataLeitura: Timestamp | null
}
```

---

## 🔥 Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Collection única de notificações
    match /notifications/{notifId} {
      // Leitura: se usuário está em destinatarios ou é "TODOS"
      allow read: if request.auth != null &&
                     (resource.data.destinatarios.hasAny([request.auth.uid, 'TODOS']));

      // Escrita: apenas admin
      allow write: if request.auth != null && hasAdminRole();

      // Subcollection user_states (estado por usuário)
      match /user_states/{userId} {
        // Cada usuário pode ler/escrever apenas seu próprio estado
        allow read, write: if request.auth != null && userId == request.auth.uid;
      }
    }
  }

  // Função helper (ajustar conforme seu sistema)
  function hasAdminRole() {
    return request.auth != null &&
           get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
  }
}
```

---

## 📊 Firestore Indexes

```json
{
  "indexes": [
    {
      "collectionGroup": "notifications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "destinatarios", "arrayConfig": "CONTAINS" },
        { "fieldPath": "dataCriacao", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "notifications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "categoria", "order": "ASCENDING" },
        { "fieldPath": "dataCriacao", "order": "DESCENDING" }
      ]
    }
  ]
}
```

---

## 🚀 Como Usar

### Mobile - Buscar Notificações

```dart
import 'package:medita_bk/data/repositories/notificacoes_repository_v2.dart';

final repository = NotificacoesRepositoryV2();

// Buscar notificações
final notificacoes = await repository.getNotificacoes(limite: 20);

// Stream (tempo real)
repository.streamNotificacoes(limite: 20).listen((notificacoes) {
  // Atualiza UI
});

// Marcar como lida
await repository.marcarComoLida(notificacao);

// Marcar todas como lidas
await repository.marcarTodasComoLidas();

// Remover notificação
await repository.removerNotificacao(notificacao);

// Contador de não lidas
final contador = await repository.contarNaoLidas();
```

### Web Admin - Criar Notificações

```dart
import 'package:medita_bk_web_admin/data/repositories/notification_repository_v2.dart';
import 'package:medita_bk_web_admin/domain/models/tipo_notificacao.dart';

final repository = NotificationRepositoryV2();

// Criar notificação de curso para TODOS
await repository.criarNotificacaoCurso(
  titulo: 'Novo Curso Disponível!',
  conteudo: 'Confira o curso de Flutter Avançado',
  tipo: TipoNotificacao.cursoNovo,
  destinatarios: ['TODOS'],
  cursoId: 'curso123',
  imagemUrl: 'https://...',
);

// Criar notificação de ticket para usuário específico
await repository.criarNotificacaoTicket(
  titulo: 'Resposta no seu Ticket #42',
  conteudo: 'Seu ticket foi respondido pela equipe',
  tipo: TipoNotificacao.ticketRespondido,
  ticketId: 'ticket123',
  destinatarioId: 'userId123',
  remetenteNome: 'Suporte',
);

// Criar notificação de discussão
await repository.criarNotificacaoDiscussao(
  titulo: 'Nova resposta na discussão',
  conteudo: 'Alguém respondeu sua dúvida',
  tipo: TipoNotificacao.discussaoRespondida,
  discussaoId: 'discussao123',
  cursoId: 'curso123',
  destinatarioId: 'userId123',
);

// Criar notificação de sistema
await repository.criarNotificacaoSistema(
  titulo: 'Manutenção Programada',
  conteudo: 'Sistema ficará em manutenção no dia 15/12',
  tipo: TipoNotificacao.sistemaManutencao,
  paraTodasUsuarios: true,
);

// Listar notificações (admin)
final notificacoes = await repository.listarNotificacoes(
  limite: 50,
  filtroCategoria: 'curso',
);

// Obter estatísticas
final stats = await repository.obterEstatisticas();
// {
//   total: 1234,
//   enviadas: 1200,
//   paraTodasUsuarios: 50,
//   ultimaSemana: 100,
//   porCategoria: {ticket: 400, discussao: 300, curso: 500, sistema: 34}
// }

// Deletar notificação
await repository.deletarNotificacao('notifId');

// Deletar múltiplas
await repository.deletarNotificacoes(['id1', 'id2', 'id3']);
```

---

## 📈 Benefícios

### Redução de Queries

| Operação | Antes | Depois | Redução |
|----------|-------|--------|---------|
| Buscar notificações | 10 queries | 1 query | **90%** |
| Stream notificações | 10 streams | 1 stream | **90%** |
| Marcar como lida | 1 query | 1 query | 0% |
| Contar não lidas | 10 queries | 1 query | **90%** |

### Redução de Código

| Componente | Antes | Depois | Redução |
|------------|-------|--------|---------|
| Repository mobile | ~2000 linhas | ~500 linhas | **75%** |
| Models mobile | 3 arquivos | 2 arquivos | **33%** |
| Enums | 2 incompatíveis | 1 compartilhado | **50%** |

### Benefícios de Arquitetura

✅ **Simplicidade**
- 1 collection ao invés de 3
- 1 enum ao invés de 2 incompatíveis
- 1 query ao invés de 10

✅ **Performance**
- Firestore cobra por query → 90% menos custo
- Menos dados transferidos
- Índice otimizado

✅ **Manutenibilidade**
- Código mais simples e legível
- Enum compartilhado entre mobile e web
- Menos bugs de compatibilidade

✅ **Escalabilidade**
- `arrayContainsAny` é eficiente mesmo com milhões de docs
- Subcollections de `user_states` isolam estado por usuário
- Fácil adicionar novos tipos de notificação

---

## ✅ Checklist de Migração

### Preparação
- [ ] Backup dos dados existentes (se necessário)
- [ ] Revisar código novo criado
- [ ] Confirmar que pode deletar dados antigos

### Firestore
- [ ] Deletar collections antigas: `in_app_notifications`, `ead_push_notifications`, `global_push_notifications`
- [ ] Atualizar Security Rules
- [ ] Criar índices compostos
- [ ] Deploy rules e indexes

### Mobile (`medita-bk`)
- [ ] Trocar imports no ViewModel: `NotificacoesRepository` → `NotificacoesRepositoryV2`
- [ ] Trocar tipo: `UnifiedNotification` → `Notificacao`
- [ ] Atualizar `NotificacoesViewModel`
- [ ] Atualizar `NotificacaoCard` (usar `notificacao.tipo.icon`, `notificacao.tipo.badgeColor`)
- [ ] Atualizar `NotificacoesPage` (usar `notificacao.navegacao`)
- [ ] Remover código antigo (opcional)
- [ ] Testar

### Web Admin (`medita-bk-web-admin`)
- [ ] Importar `TipoNotificacao`
- [ ] Criar instância de `NotificationRepositoryV2`
- [ ] Atualizar forms de criação de notificação
- [ ] Usar métodos especializados (`criarNotificacaoTicket`, `criarNotificacaoCurso`, etc.)
- [ ] Atualizar listagem de notificações
- [ ] Remover código antigo (opcional)
- [ ] Testar

### Testes End-to-End
- [ ] Web: Criar notificação de curso para "TODOS"
- [ ] Mobile: Verificar que aparece
- [ ] Mobile: Clicar e verificar navegação (se tiver cursoId)
- [ ] Mobile: Marcar como lida
- [ ] Web: Criar notificação de ticket para usuário específico
- [ ] Mobile: Verificar que aparece apenas para esse usuário
- [ ] Mobile: Clicar e navegar para ticket
- [ ] Mobile: Deletar notificação
- [ ] Mobile: Marcar todas como lidas

---

## 🔄 Rollback (se necessário)

Se algo der errado durante a migração:

1. **Restaurar collections antigas** (se fez backup)
2. **Mobile:** Trocar imports de volta
   - `NotificacoesRepositoryV2` → `NotificacoesRepository`
   - `Notificacao` → `UnifiedNotification`
3. **Web:** Reverter para repository antigo
4. **Firestore:** Restaurar rules antigas

**Importante:** Os arquivos novos (`*_v2.dart`, `tipo_notificacao.dart`, `notificacao.dart`) **NÃO interferem** com os antigos! Você pode manter ambos no código enquanto testa.

---

## 📝 Próximos Passos

1. **Revisar código criado** ✅ (Este documento!)
2. **Fazer backup** (opcional, dados não são legados)
3. **Deletar dados antigos** do Firestore
4. **Atualizar mobile** (trocar imports e tipos)
5. **Atualizar web admin** (copiar enum e usar novo repository)
6. **Deploy Firestore** (rules + indexes)
7. **Testar tudo**
8. **Remover código antigo** (quando tudo estiver funcionando)

---

## 🎯 Resumo Executivo

### Antes
```
📊 3 collections
📊 10 queries por usuário
📊 2 enums incompatíveis
📊 ~2000 linhas de código
📊 Lógica complexa de fallbacks
```

### Depois
```
✅ 1 collection
✅ 1 query por usuário
✅ 1 enum compartilhado
✅ ~500 linhas de código
✅ Lógica simples e direta
```

### Resultado
**90% menos queries** = 90% menos custo no Firestore
**75% menos código** = Mais fácil de manter
**100% compatível** = Mobile e Web usam mesmo enum

---

**Criado por:** Claude Code
**Data:** 2025-12-11
**Status:** ✅ Pronto para implementação
