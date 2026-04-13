# Correção da Navegação de Notificações

**Data:** 2025-12-11
**Problema:** Navegação de tickets/discussões não funcionava

---

## 🔍 Diagnóstico

### Logs do Problema

```
🟦 ead.relatedType: null
🟦 ead.relatedId: null
🟦 ead.dados: {mensagemId: iVSLP5jwcemwzAEgUYEZ, ticketId: 4fDB3hu2XM6Pn1V7FnmS, ticketNumero: 3}
🟦 ❌ relatedType ou relatedId é null
```

### Causa Raiz

As notificações criadas pelo sistema de tickets/discussões estavam salvando os dados de navegação **apenas** no campo `dados`, mas **NÃO** nos campos `relatedType` e `relatedId`.

**Estrutura esperada:**
```json
{
  "relatedType": "ticket",
  "relatedId": "4fDB3hu2XM6Pn1V7FnmS",
  "dados": {...}
}
```

**Estrutura real encontrada:**
```json
{
  "relatedType": null,
  "relatedId": null,
  "dados": {
    "ticketId": "4fDB3hu2XM6Pn1V7FnmS",
    "mensagemId": "iVSLP5jwcemwzAEgUYEZ"
  }
}
```

---

## ✅ Solução Aplicada

### Fallback de Extração de Dados

Modificado `onNotificacaoTap()` para ter **dois níveis de busca**:

1. **Nível 1 (Preferencial):** Tenta usar `relatedType` e `relatedId` diretos
2. **Nível 2 (Fallback):** Se nulos, extrai de `dados.ticketId` ou `dados.discussaoId`

### Código Implementado

```dart
// Tenta primeiro os campos diretos relatedType/relatedId
if (ead.relatedType != null && ead.relatedId != null) {
  return {
    'type': ead.relatedType,
    'id': ead.relatedId,
    'dados': ead.dados,
  };
}

// FALLBACK: Se relatedType/relatedId são null, extrai de 'dados'
if (ead.dados != null && ead.dados!.isNotEmpty) {
  // Busca ticketId
  if (ead.dados!.containsKey('ticketId')) {
    final ticketId = ead.dados!['ticketId'] as String?;
    if (ticketId != null && ticketId.isNotEmpty) {
      return {
        'type': 'ticket',
        'id': ticketId,
        'dados': ead.dados,
      };
    }
  }

  // Busca discussaoId
  if (ead.dados!.containsKey('discussaoId')) {
    final discussaoId = ead.dados!['discussaoId'] as String?;
    final cursoId = ead.dados!['cursoId'] as String?;
    if (discussaoId != null && discussaoId.isNotEmpty) {
      return {
        'type': 'discussao',
        'id': discussaoId,
        'dados': {...?ead.dados, if (cursoId != null) 'cursoId': cursoId},
      };
    }
  }
}
```

---

## 📊 Fluxo de Navegação Corrigido

```
┌─────────────────────────────────────────┐
│  Usuário clica na notificação           │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  _handleNotificacaoTap()                │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  onNotificacaoTap()                     │
│  - Marca como lida                      │
│  - Extrai dados de navegação            │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  Tenta Nível 1:                         │
│  relatedType + relatedId                │
└─────────────┬───────────────────────────┘
              │
         ┌────┴────┐
         │         │
      Sucesso   Falha
         │         │
         │         ▼
         │    ┌─────────────────────────┐
         │    │  Tenta Nível 2 (NOVO):  │
         │    │  dados.ticketId ou      │
         │    │  dados.discussaoId      │
         │    └─────────┬───────────────┘
         │              │
         │         ┌────┴────┐
         │         │         │
         │      Sucesso   Falha
         │         │         │
         └────┬────┘         │
              │              ▼
              │         Sem navegação
              ▼
┌─────────────────────────────────────────┐
│  Retorna navData:                       │
│  {                                      │
│    'type': 'ticket',                    │
│    'id': '4fDB3hu2...',                 │
│    'dados': {...}                       │
│  }                                      │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  _handleNotificacaoTap()                │
│  - Identifica type: 'ticket'            │
│  - Navega: /suporte/ticket/{id}         │
└─────────────────────────────────────────┘
```

---

## 🧪 Teste Esperado

### Logs Esperados Após Fix

```
🟦 onNotificacaoTap: Iniciando...
🟦 notificacao.source: NotificationSource.ead
🟦 EAD notification detected
🟦 ead.relatedType: null
🟦 ead.relatedId: null
🟦 ead.dados: {ticketId: 4fDB3hu2XM6Pn1V7FnmS, mensagemId: iVSLP5jwcemwzAEgUYEZ}
🟦 🔄 relatedType/relatedId null, tentando extrair de dados...
🟦 ✅ Retornando navData (extraído de dados.ticketId): {type: ticket, id: 4fDB3hu2XM6Pn1V7FnmS, dados: {...}}
🔵 navData retornado: {type: ticket, id: 4fDB3hu2XM6Pn1V7FnmS}
🔵 type: ticket, id: 4fDB3hu2XM6Pn1V7FnmS
🔵 Navegando para ticket: /suporte/ticket/4fDB3hu2XM6Pn1V7FnmS
```

### Comportamento Esperado

1. ✅ Clica na notificação de ticket
2. ✅ Sistema extrai `ticketId` do campo `dados`
3. ✅ Navega para `/suporte/ticket/4fDB3hu2XM6Pn1V7FnmS`
4. ✅ Página do ticket é aberta

---

## 📁 Arquivo Modificado

**Arquivo:** `lib/ui/notificacoes/notificacoes_page/view_model/notificacoes_view_model.dart`

**Linhas:** 209-263

**Mudanças:**
- Adicionado fallback para extrair `ticketId` de `dados`
- Adicionado fallback para extrair `discussaoId` de `dados`
- Logs detalhados do processo de extração

---

## 🔮 Próximos Passos

### Correção Permanente (Recomendado)

Para evitar esse problema no futuro, o sistema que **cria** as notificações de tickets/discussões deveria preencher os campos `relatedType` e `relatedId` corretamente:

```dart
// NO SISTEMA QUE CRIA A NOTIFICAÇÃO:
await _firestore.collection('in_app_notifications').add({
  'titulo': 'Resposta no Ticket',
  'conteudo': 'Você recebeu uma resposta...',
  'tipo': 'ticket_respondido',
  'relatedType': 'ticket',        // ⬅️ ADICIONAR
  'relatedId': ticketId,           // ⬅️ ADICIONAR
  'dados': {
    'ticketId': ticketId,
    'mensagemId': mensagemId,
  },
  // ...
});
```

**Benefícios:**
- Código mais limpo (não precisa de fallback)
- Performance melhor (menos verificações)
- Mais consistente com a arquitetura

**Localização dos sistemas que criam notificações:**
- Sistema de tickets (quando cria/responde ticket)
- Sistema de discussões (quando cria/responde discussão)

---

## 📝 Notas Técnicas

### Por que o fallback é necessário?

Notificações antigas podem ter sido criadas sem `relatedType`/`relatedId`. O fallback garante **retrocompatibilidade** - navegação funciona tanto para:
- ✅ Notificações novas (com relatedType/relatedId)
- ✅ Notificações antigas (sem relatedType/relatedId, só dados)

### Campos verificados no fallback

| Campo | Tipo de Navegação | Dados Necessários |
|-------|------------------|-------------------|
| `dados.ticketId` | Ticket | `ticketId` |
| `dados.discussaoId` | Discussão | `discussaoId` + `cursoId` (opcional) |

---

**Implementado por:** Claude Code
**Data:** 2025-12-11
**Status:** ✅ Correção aplicada, aguardando teste do usuário
