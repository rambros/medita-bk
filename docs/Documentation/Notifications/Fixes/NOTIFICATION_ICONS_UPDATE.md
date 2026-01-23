# Atualização de Ícones das Notificações

**Data:** 2025-12-11

## 📝 Mudanças Aplicadas

Diferenciação visual entre os 3 tipos de notificações do sistema unificado.

---

## 🎨 Novos Ícones e Cores

### 1️⃣ Notificações de **Suporte** (in_app_notifications)

**Collection:** `in_app_notifications`
**Badge:** "Suporte"
**Cor do Badge:** 🟠 Laranja (Orange)
**Ícones específicos por tipo:**

| Tipo | Ícone | Cor |
|------|-------|-----|
| Ticket Criado | `Icons.confirmation_number_outlined` | 🔵 Azul |
| Ticket Respondido | `Icons.reply` | 🟠 Laranja |
| Ticket Resolvido | `Icons.check_circle_outline` | 🟢 Verde |
| Ticket Fechado | `Icons.lock_outline` | ⚫ Cinza |
| Discussão Criada | `Icons.forum_outlined` | 🟣 Roxo |
| Discussão Respondida | `Icons.chat_bubble_outline` | 🟦 Teal |
| Discussão Resolvida | `Icons.verified_outlined` | 🟢 Verde |
| Resposta Curtida | `Icons.thumb_up_outlined` | 🩷 Rosa |
| Resposta Solução | `Icons.star_outline` | 🟡 Âmbar |

---

### 2️⃣ Notificações de **Cursos EAD** (ead_push_notifications)

**Collection:** `ead_push_notifications`
**Badge:** "Cursos"
**Cor do Badge:** 🟣 Roxo Escuro (Deep Purple)
**Ícone:** 🎓 `Icons.school_outlined`
**Cor do Ícone:** 🟣 Roxo Escuro (Deep Purple)

**Quando usar:**
- Notificações de cursos criadas pelo web admin
- Comunicados sobre módulos, aulas, certificados
- Avisos sobre prazos de cursos
- Lançamento de novos conteúdos educacionais

---

### 3️⃣ Notificações de **Meditações** (global_push_notifications)

**Collection:** `global_push_notifications`
**Badge:** "Meditações"
**Cor do Badge:** 🔵 Azul (Blue)
**Ícone:** 🔔 `Icons.notifications` ou `Icons.notifications_active`
**Cor do Ícone:** 🔵 Azul

**Quando usar:**
- Comunicados gerais do app
- Avisos sobre meditações
- Mensagens para todos os usuários

---

## 🔍 Como Diferenciar

### Lógica Implementada

```dart
// No UnifiedNotification.icon getter:

if (source == NotificationSource.ead && originalData is NotificacaoEadModel) {
  final eadModel = originalData as NotificacaoEadModel;

  // Verifica o TIPO da notificação
  if (eadModel.tipo.isTicket || eadModel.tipo.isDiscussao) {
    // ✅ É ticket/discussão → in_app_notifications (Suporte)
    return eadModel.tipo.icon; // Ícones específicos de ticket/discussão
  }

  // ✅ Não é ticket/discussão → ead_push_notifications (Cursos)
  return Icons.school_outlined; // 🎓 Ícone de educação
}
```

**Campo chave:** `tipo.isTicket` e `tipo.isDiscussao`
- **ticket_* ou discussao_*:** Notificação de suporte → ícones específicos
- **Outros tipos:** Notificação de curso EAD → ícone de escola (🎓)

---

## 📊 Resumo Visual

```
┌─────────────────────────────────────────────────────────────┐
│                    TIPOS DE NOTIFICAÇÃO                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  🎫 SUPORTE (in_app_notifications)                           │
│     Badge: [Suporte] 🟠                                      │
│     Ícones: Variados por tipo (reply, forum, star, etc)      │
│     Cores: Específicas por tipo                              │
│                                                               │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  🎓 CURSOS (ead_push_notifications)                          │
│     Badge: [Cursos] 🟣                                       │
│     Ícone: school_outlined (🎓)                              │
│     Cor: Deep Purple                                         │
│                                                               │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  🧘 MEDITAÇÕES (global_push_notifications)                   │
│     Badge: [Meditações] 🔵                                   │
│     Ícone: notifications (🔔)                                │
│     Cor: Blue                                                │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Arquivos Modificados

### 1. `lib/domain/models/unified_notification.dart`

**Linhas 62-100:** Getters `icon` e `color`
- Adicionada lógica para diferenciar notificações com/sem `relatedType`
- Notificações **com** `relatedType` → Suporte (ícones específicos)
- Notificações **sem** `relatedType` → Cursos (ícone `school_outlined` 🎓)

**Linhas 122-137:** Getter `sourceLabel`
- Diferencia badges entre "Suporte", "Cursos" e "Meditações"
- Usa `relatedType` para identificar tipo correto

### 2. `lib/ui/notificacoes/notificacoes_page/widgets/notificacao_card.dart`

**Linhas 24-39:** Método `_getBadgeColor()`
- Retorna cor correta do badge baseado no `sourceLabel`
- Suporte: 🟠 Orange
- Cursos: 🟣 Deep Purple
- Meditações: 🔵 Blue

**Linhas 246-267:** Badge de origem
- Agora usa `_getBadgeColor()` para cor dinâmica
- Cores diferentes para cada tipo de notificação

---

## ✅ Benefícios

1. **Identificação Visual Imediata**
   - Usuário sabe de onde vem a notificação pelo ícone e badge
   - Cores diferentes facilitam escaneamento rápido da lista

2. **Organização Clara**
   - Notificações de suporte (tickets/discussões) mantêm ícones específicos
   - Notificações de cursos EAD agora têm identidade visual própria (🎓)
   - Notificações gerais continuam com visual padrão (🔔)

3. **Melhor UX**
   - Badges com nomes descritivos: "Suporte", "Cursos", "Meditações"
   - Cores consistentes em todo o card (ícone + badge)
   - Ícone de escola (🎓) é universalmente reconhecido para educação

---

## 🧪 Como Testar

1. **Criar notificação de curso no web admin:**
   ```
   Collection: ead_push_notifications
   Título: "Novo módulo disponível"
   Conteúdo: "O módulo 3 do curso de Mindfulness já está disponível"
   ```

   **Resultado esperado:**
   - Ícone: 🎓 (school_outlined)
   - Cor do ícone: Roxo Escuro
   - Badge: [Cursos] 🟣

2. **Responder um ticket:**
   ```
   Tipo: ticket_respondido
   ```

   **Resultado esperado:**
   - Ícone: ↩️ (reply)
   - Cor do ícone: Laranja
   - Badge: [Suporte] 🟠

3. **Criar notificação global:**
   ```
   Collection: global_push_notifications
   Título: "Manutenção programada"
   ```

   **Resultado esperado:**
   - Ícone: 🔔 (notifications)
   - Cor do ícone: Azul
   - Badge: [Meditações] 🔵

---

## 📖 Referências

- Ícone escolhido: [`Icons.school_outlined`](https://api.flutter.dev/flutter/material/Icons/school_outlined-constant.html)
- Alternativas consideradas:
  - `Icons.menu_book` (livro) - muito genérico
  - `Icons.class_outlined` (sala de aula) - menos intuitivo
  - `Icons.local_library` (biblioteca) - não relacionado a cursos online
  - ✅ `Icons.school_outlined` (escola) - **ESCOLHIDO** - melhor representa educação/cursos

---

**Implementado por:** Claude Code
**Data:** 2025-12-11
