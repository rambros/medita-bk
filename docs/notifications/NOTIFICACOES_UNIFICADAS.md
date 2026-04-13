# 🔗 Sistema de Notificações Unificadas

## 📋 Visão Geral

O app mobile agora unifica notificações de **TRÊS collections diferentes**:

| Collection | Admin | Conteúdo | Status |
|-----------|-------|----------|--------|
| `in_app_notifications` | App Mobile | Tickets, Discussões | ✅ Unificado |
| `ead_push_notifications` | Cursos EAD | Push Notifications EAD | ✅ Unificado |
| `global_push_notifications` | Meditações | Push Notifications Globais | ✅ Unificado |

> **📝 Nota:** As collections foram renomeadas em Dezembro/2024:
> - `notificacoes` → `in_app_notifications`
> - `notificacoes_ead` → `ead_push_notifications`
> - `notifications` → `global_push_notifications`

**✨ Resultado**: O usuário vê TODAS as notificações em uma única lista, com badge contador unificado!

## 🎯 Como Funciona

### 1. Modelo Unificado (`UnifiedNotification`)

Criado um adapter que unifica ambos os modelos:

```dart
// Funciona com ambas as collections
final notification = UnifiedNotification.fromEad(notificacaoEad);
// ou
final notification = UnifiedNotification.fromLegacy(notificationLegacy);

// Campos comuns
notification.id
notification.titulo
notification.conteudo
notification.dataCriacao
notification.lido
notification.icon    // Ícone apropriado
notification.color   // Cor apropriada
notification.source  // NotificationSource.ead ou .legacy
```

### 2. Repository Unificado

O `NotificacoesRepository` agora busca de ambas as collections:

```dart
// Busca notificações unificadas
final notificacoes = await repository.getNotificacoesUnificadas();

// Stream unificado
repository.streamNotificacoesUnificadas()

// Conta não lidas de ambas
final total = await repository.contarNaoLidasUnificadas();
```

### 3. Badge Contador Unificado

O badge no ícone do app conta notificações de ambas as collections:

```dart
// Badge mostra total de:
// - Notificações EAD não lidas
// + Todas notificações de meditações
```

## 📱 UI/UX

### Lista de Notificações

Cada notificação mostra:
- ✅ Ícone apropriado ao tipo
- ✅ Título e conteúdo
- ✅ Tempo desde criação
- ✅ **Badge de origem** (EAD ou Meditações)
- ✅ Indicador de não lida (ponto vermelho)

### Badges de Origem

Cada notificação tem um badge mostrando de qual collection veio:

```
🟢 In-App       → in_app_notifications (tickets/discussões)
🟣 EAD Push     → ead_push_notifications
🔵 Global Push  → global_push_notifications
```

### Ações Disponíveis

**Notificações In-App (`in_app_notifications`):**
- ✅ Marcar como lida
- ✅ Remover (ocultar)
- ✅ Navegar para ticket/discussão

**Notificações EAD Push (`ead_push_notifications`):**
- ✅ Marcar como lida
- ✅ Remover (ocultar)
- ✅ Navegar (se tiver dados de navegação)

**Notificações Global Push (`global_push_notifications`):**
- ✅ Marcar como lida
- ✅ Remover (ocultar)
- ❌ Navegação específica (sem dados de navegação)

## 🔧 Para os Admins

### Admin de Cursos EAD

Salve em `ead_push_notifications`:

```javascript
await firestore.collection('ead_push_notifications').add({
  titulo: "Nova resposta",
  conteudo: "Admin respondeu seu ticket",
  tipo: "ticket_respondido",
  destinatarioId: userId,
  dataCriacao: FieldValue.serverTimestamp(),
  lido: false,
  // ...
});
```

### Admin de Meditações

Salve em `global_push_notifications`:

```javascript
await firestore.collection('global_push_notifications').add({
  title: "Nova meditação disponível",
  content: "Confira a nova meditação...",
  type: "Enviada",
  dataEnvio: FieldValue.serverTimestamp(),
  recipientsRef: [userRef1, userRef2],
  // ...
});
```

**⚠️ Importante**: Ambos os admins podem continuar trabalhando independentemente. O app mobile unifica tudo automaticamente!

## 📊 Diferenças Entre as Collections

| Aspecto | in_app_notifications | ead_push_notifications | global_push_notifications |
|---------|---------------------|------------------------|---------------------------|
| Campo usuário | `destinatarioId` (UID) | `destinatarioId` (UID) ou `destinatarioTipo` | `recipientsRef` (array de refs) |
| Marcação lida | user_states | user_states | user_states |
| Campos | Português | Português | Inglês |
| Destinatários | 1 por documento | 1 ou "Todos" | N por documento (array) |
| Navegação | Sim (tickets/discussões) | Sim (se tiver dados) | Não |

## 🎨 Visualização

### Badge no Ícone

```
🔔    → Sem notificações
🔔 5  → 5 notificações (EAD + Meditações)
```

### Lista de Notificações

```
━━━━━━━━━━━━━━━━━━
 NÃO LIDAS
━━━━━━━━━━━━━━━━━━
🟣 [EAD] Nova resposta no ticket    • 2h
🔵 [Meditações] Nova meditação      • 5h
━━━━━━━━━━━━━━━━━━
 ANTERIORES
━━━━━━━━━━━━━━━━━━
🟣 [EAD] Ticket resolvido           1d
🔵 [Meditações] Lembrete...         3d
```

## 🔍 Debug Info

O widget de debug agora mostra:

```
📊 Collection: in_app_notifications
Total: X notificações

📊 Collection: ead_push_notifications
Total de documentos: Y
Por destinatarioId=userId: A
Por destinatarioTipo=Todos: B

📊 Collection: global_push_notifications
Total: Z notificações

📊 TOTAL GERAL: X+Y+Z notificações
```

## ✅ Vantagens da Unificação

1. **Experiência única** para o usuário
2. **Badge contador** mostra tudo
3. **Lista unificada** ordenada por data
4. **Admins trabalham independentes**
5. **Não quebra sistemas existentes**
6. **Fácil adicionar mais fontes** no futuro

## 🚀 Futuras Melhorias (Opcional)

- [ ] Filtros por origem (só EAD, só Meditações)
- [ ] Cores diferentes por origem
- [ ] Sons diferentes por origem
- [ ] Estatísticas por origem
- [ ] Sincronizar campo "lido" para notifications

## 🔄 Migração Futura (Opcional)

Se quiser unificar completamente as collections no futuro:

1. Migrar dados de `global_push_notifications` para `ead_push_notifications`
2. Adicionar campo `origem` ou `categoria`
3. Remover suporte a `global_push_notifications`

**Mas não é necessário!** O sistema atual funciona perfeitamente com ambas.

## 📞 Suporte

### Verificar se está funcionando:

1. Abra o app → Notificações
2. Veja o debug info no topo
3. Deve mostrar notificações de ambas as collections
4. Badge deve mostrar total unificado

### Testar:

1. **Admin EAD**: Crie notificação em `ead_push_notifications`
2. **Admin Meditações**: Crie notificação em `global_push_notifications`
3. **App Mobile**: Deve mostrar ambas na lista
4. **Badge**: Deve mostrar contagem total

---

**🎉 Sistema unificado e funcionando! Ambos os admins podem trabalhar independentemente!**

