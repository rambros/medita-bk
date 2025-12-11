# 🔗 Sistema de Notificações Unificadas

## 📋 Visão Geral

O app mobile agora unifica notificações de **DUAS collections diferentes**:

| Collection | Admin | Conteúdo | Status |
|-----------|-------|----------|--------|
| `notificacoes_ead` | Cursos EAD | Tickets, Discussões | ✅ Unificado |
| `notifications` | Meditações | Notificações gerais | ✅ Unificado |

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

Cada notificação tem um badge mostrando de qual sistema veio:

```
🟣 EAD          → notificacoes_ead
🔵 Meditações   → notifications
```

### Ações Disponíveis

**Notificações EAD:**
- ✅ Marcar como lida
- ✅ Remover
- ✅ Navegar para ticket/discussão

**Notificações de Meditações:**
- ✅ Visualizar (não tem "lida")
- ❌ Não pode remover (sistema antigo)
- ❌ Não tem navegação específica

## 🔧 Para os Admins

### Admin de Cursos EAD

Continue salvando em `notificacoes_ead`:

```javascript
await firestore.collection('notificacoes_ead').add({
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

Continue salvando em `notifications`:

```javascript
await firestore.collection('notifications').add({
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

| Aspecto | notificacoes_ead | notifications |
|---------|------------------|---------------|
| Campo usuário | `destinatarioId` (UID) | `recipientsRef` (array de refs) |
| Marcação lida | Campo `lido` | ❌ Não tem |
| Campos | Português | Inglês |
| Destinatários | 1 por documento | N por documento (array) |
| Navegação | Sim (related*) | Não |

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
📊 Collection: notificacoes_ead
Total: X notificações

📊 Collection: notifications
Total: Y notificações

📊 TOTAL GERAL: X+Y notificações
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

1. Migrar dados de `notifications` para `notificacoes_ead`
2. Adicionar campo `origem` ou `categoria`
3. Remover suporte a `notifications`

**Mas não é necessário!** O sistema atual funciona perfeitamente com ambas.

## 📞 Suporte

### Verificar se está funcionando:

1. Abra o app → Notificações
2. Veja o debug info no topo
3. Deve mostrar notificações de ambas as collections
4. Badge deve mostrar total unificado

### Testar:

1. **Admin EAD**: Crie notificação em `notificacoes_ead`
2. **Admin Meditações**: Crie notificação em `notifications`
3. **App Mobile**: Deve mostrar ambas na lista
4. **Badge**: Deve mostrar contagem total

---

**🎉 Sistema unificado e funcionando! Ambos os admins podem trabalhar independentemente!**

