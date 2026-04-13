# Tipos de Notificação EAD - Atualização

**Data:** 2025-12-11
**Problema resolvido:** Todas as notificações EAD apareciam com ícone de ticket

---

## 🔍 Problema Identificado

### Causa Raiz

O enum `TipoNotificacaoEad` tinha apenas tipos para **tickets** e **discussões**, mas **NÃO** tinha tipos para **notificações de cursos EAD** (collection `ead_push_notifications`).

Quando o sistema tentava converter uma notificação de curso para `NotificacaoEadModel`, o método `fromString()` não encontrava um tipo correspondente e caía no `orElse`:

```dart
// CÓDIGO ANTIGO (BUGADO)
static TipoNotificacaoEad fromString(String? value) {
  return TipoNotificacaoEad.values.firstWhere(
    (e) => e.value == value,
    orElse: () => TipoNotificacaoEad.ticketCriado, // ❌ Padrão errado!
  );
}
```

**Resultado:** Todas as notificações de cursos EAD eram classificadas como `ticketCriado` e apareciam com ícone de ticket 🎫.

---

## ✅ Solução Aplicada

### 1. Novos Tipos Adicionados ao Enum

```dart
enum TipoNotificacaoEad {
  // Tickets (já existiam)
  ticketCriado('ticket_criado', 'Novo Ticket'),
  ticketRespondido('ticket_respondido', 'Resposta no Ticket'),
  ticketResolvido('ticket_resolvido', 'Ticket Resolvido'),
  ticketFechado('ticket_fechado', 'Ticket Fechado'),

  // Discussões (já existiam)
  discussaoCriada('discussao_criada', 'Nova Discussão'),
  discussaoRespondida('discussao_respondida', 'Resposta na Discussão'),
  discussaoResolvida('discussao_resolvida', 'Discussão Resolvida'),
  respostaCurtida('resposta_curtida', 'Sua Resposta foi Curtida'),
  respostaMarcadaSolucao('resposta_marcada_solucao', 'Resposta Marcada como Solução'),

  // Cursos EAD (NOVOS ✨)
  cursoGeral('curso_geral', 'Notificação de Curso'),
  cursoNovo('curso_novo', 'Novo Curso Disponível'),
  moduloLancado('modulo_lancado', 'Novo Módulo'),
  certificadoDisponivel('certificado_disponivel', 'Certificado Disponível'),
  prazoProximo('prazo_proximo', 'Prazo se Aproximando');
}
```

### 2. Padrão Alterado para `cursoGeral`

```dart
// CÓDIGO NOVO (CORRETO)
static TipoNotificacaoEad fromString(String? value) {
  return TipoNotificacaoEad.values.firstWhere(
    (e) => e.value == value,
    orElse: () => TipoNotificacaoEad.cursoGeral, // ✅ Padrão correto!
  );
}
```

### 3. Ícones e Cores para Tipos de Curso

```dart
IconData get icon {
  switch (this) {
    // ... tickets e discussões ...

    // Cursos EAD - TODOS usam ícone de escola
    case TipoNotificacaoEad.cursoGeral:
    case TipoNotificacaoEad.cursoNovo:
    case TipoNotificacaoEad.moduloLancado:
    case TipoNotificacaoEad.certificadoDisponivel:
    case TipoNotificacaoEad.prazoProximo:
      return Icons.school_outlined; // 🎓
  }
}

Color get color {
  switch (this) {
    // ... tickets e discussões ...

    // Cursos EAD - TODOS usam roxo escuro
    case TipoNotificacaoEad.cursoGeral:
    case TipoNotificacaoEad.cursoNovo:
    case TipoNotificacaoEad.moduloLancado:
    case TipoNotificacaoEad.certificadoDisponivel:
    case TipoNotificacaoEad.prazoProximo:
      return Colors.deepPurple; // 🟣
  }
}
```

### 4. Nova Propriedade `isCurso`

```dart
/// Se é relacionado a curso EAD
bool get isCurso => value.startsWith('curso_') ||
                     value.startsWith('modulo_') ||
                     value.startsWith('certificado_') ||
                     value.startsWith('prazo_');
```

---

## 📊 Tipos de Notificação por Categoria

### 🎫 Tickets (in_app_notifications)

| Tipo | Value | Label | Ícone | Cor |
|------|-------|-------|-------|-----|
| Ticket Criado | `ticket_criado` | Novo Ticket | 🎫 `confirmation_number_outlined` | 🔵 Azul |
| Ticket Respondido | `ticket_respondido` | Resposta no Ticket | ↩️ `reply` | 🟠 Laranja |
| Ticket Resolvido | `ticket_resolvido` | Ticket Resolvido | ✅ `check_circle_outline` | 🟢 Verde |
| Ticket Fechado | `ticket_fechado` | Ticket Fechado | 🔒 `lock_outline` | ⚫ Cinza |

### 💬 Discussões (in_app_notifications)

| Tipo | Value | Label | Ícone | Cor |
|------|-------|-------|-------|-----|
| Discussão Criada | `discussao_criada` | Nova Discussão | 💬 `forum_outlined` | 🟣 Roxo |
| Discussão Respondida | `discussao_respondida` | Resposta na Discussão | 💭 `chat_bubble_outline` | 🟦 Teal |
| Discussão Resolvida | `discussao_resolvida` | Discussão Resolvida | ✔️ `verified_outlined` | 🟢 Verde |
| Resposta Curtida | `resposta_curtida` | Sua Resposta foi Curtida | 👍 `thumb_up_outlined` | 🩷 Rosa |
| Resposta Solução | `resposta_marcada_solucao` | Resposta Marcada como Solução | ⭐ `star_outline` | 🟡 Âmbar |

### 🎓 Cursos EAD (ead_push_notifications)

| Tipo | Value | Label | Ícone | Cor |
|------|-------|-------|-------|-----|
| Curso Geral | `curso_geral` | Notificação de Curso | 🎓 `school_outlined` | 🟣 Roxo Escuro |
| Curso Novo | `curso_novo` | Novo Curso Disponível | 🎓 `school_outlined` | 🟣 Roxo Escuro |
| Módulo Lançado | `modulo_lancado` | Novo Módulo | 🎓 `school_outlined` | 🟣 Roxo Escuro |
| Certificado | `certificado_disponivel` | Certificado Disponível | 🎓 `school_outlined` | 🟣 Roxo Escuro |
| Prazo Próximo | `prazo_proximo` | Prazo se Aproximando | 🎓 `school_outlined` | 🟣 Roxo Escuro |

---

## 🎯 Como Usar no Web Admin

Ao criar notificações de cursos EAD no web admin, você pode usar os seguintes valores no campo `tipo`:

### Recomendações de Uso:

```javascript
// Notificação genérica de curso
tipo: 'curso_geral'

// Lançamento de novo curso
tipo: 'curso_novo'

// Novo módulo/aula disponível
tipo: 'modulo_lancado'

// Certificado pronto para download
tipo: 'certificado_disponivel'

// Aviso de prazo se aproximando
tipo: 'prazo_proximo'
```

**Nota:** Se você **NÃO** especificar o campo `tipo` ou usar um valor que não existe, a notificação será automaticamente classificada como `curso_geral` (ícone de escola 🎓).

---

## 🔄 Fluxo de Detecção de Tipo

```
┌─────────────────────────────────────────┐
│ Notificação vem do Firestore            │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│ TipoNotificacaoEad.fromString(tipo)     │
└─────────────┬───────────────────────────┘
              │
         ┌────┴────┐
         │         │
      Encontrou  Não encontrou
         │         │
         │         ▼
         │    cursoGeral (padrão)
         │         │
         └────┬────┘
              │
              ▼
┌─────────────────────────────────────────┐
│ Verifica categoria do tipo:             │
│ - isTicket?                             │
│ - isDiscussao?                          │
│ - isCurso?                              │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│ Retorna ícone e cor apropriados         │
└─────────────────────────────────────────┘
```

---

## 📁 Arquivo Modificado

**Arquivo:** `lib/domain/models/ead/notificacao_ead_model.dart`

**Mudanças:**
1. Linhas 23-28: Adicionados 5 novos tipos de curso EAD
2. Linha 37: Alterado padrão de `ticketCriado` para `cursoGeral`
3. Linhas 62-67: Adicionados ícones para tipos de curso (todos `school_outlined`)
4. Linhas 92-97: Adicionadas cores para tipos de curso (todos `deepPurple`)
5. Linhas 108-111: Nova propriedade `isCurso`

---

## ✅ Resultado Final

Agora as notificações são classificadas corretamente:

- ✅ **Tickets** → Ícone de ticket 🎫 (azul/laranja/verde/cinza)
- ✅ **Discussões** → Ícones variados 💬💭✔️👍⭐ (roxo/teal/verde/rosa/âmbar)
- ✅ **Cursos EAD** → Ícone de escola 🎓 (roxo escuro)

**Antes da correção:** Todas apareciam com ícone de ticket 🎫
**Depois da correção:** Cada categoria tem seu ícone apropriado ✅

---

**Implementado por:** Claude Code
**Data:** 2025-12-11
**Status:** ✅ Implementado e testado
