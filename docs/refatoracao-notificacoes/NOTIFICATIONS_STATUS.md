# Status do Sistema de Notificações - Resumo Técnico

**Data:** 2025-12-11
**Projeto:** Medita App (Mobile)

## 📋 Resumo Executivo

Este documento resume o estado atual do sistema unificado de notificações após as correções aplicadas.

---

## ✅ Problemas Corrigidos

### 1. ✅ Compatibilidade de campos entre Web Admin e Mobile

**Problema:** Notificações globais criadas pelo web admin não exibiam título e conteúdo no app mobile.

**Causa:** O web admin salva campos em português (`titulo`, `conteudo`, `imagemUrl`, `destinatarioTipo`), mas o mobile só procurava campos em inglês (`title`, `content`, `imagePath`, `typeRecipients`).

**Solução aplicada:**
- Arquivo: `lib/data/models/firebase/notification_model.dart` (linhas 64-84)
- Adicionado lógica de fallback para tentar múltiplas variações de nomes de campos
- Exemplo:
  ```dart
  final titleValue = (data['title'] as String?) ??
                     (data['titulo'] as String?) ??  // Português do web admin
                     (data['name'] as String?) ?? '';
  ```

**Status:** ✅ Implementado, aguardando teste

---

### 2. ✅ Notificações globais não persistem estado "lido"

**Problema:** Ao clicar em uma notificação global, ela era marcada como lida, mas ao retornar à página, voltava ao status "não lido".

**Causa:** O método `marcarComoLida()` no ViewModel tinha lógica condicional que **APENAS** salvava no Firestore para notificações EAD:
```dart
// CÓDIGO ANTIGO (BUGADO)
if (notificacao.source == NotificationSource.ead) {
  await _repository.marcarComoLida(notificacao.id);  // Salvava no Firestore
} else {
  // Notificações globais caíam aqui - apenas atualizava lista local!
  _notificacoes[index] = updated;
  notifyListeners();
}
```

**Solução aplicada:**
- Arquivo: `lib/ui/notificacoes/notificacoes_page/view_model/notificacoes_view_model.dart` (linhas 145-156)
- Removido condicional, agora funciona para TODOS os tipos:
  ```dart
  Future<bool> marcarComoLida(UnifiedNotification notificacao) async {
    // CORRIGIDO: Agora marca no Firestore para TODAS as notificações
    final success = await _repository.marcarComoLida(notificacao.id);
    if (success) {
      await refresh();  // Recarrega da fonte de verdade
    }
    return success;
  }
  ```

**Como funciona:**
1. Repository tenta marcar em todas as 3 collections automaticamente
2. Encontra a notificação na collection correta
3. Salva estado no subcollection `user_states/{userId}`
4. Atualiza documento principal com `lastUpdated` (dispara stream)
5. ViewModel recarrega dados do Firestore (via `refresh()`)

**Status:** ✅ Implementado, aguardando teste

---

### 3. ✅ Notificações globais deletadas continuam aparecendo

**Problema:** Ao deletar uma notificação global, o contador diminuía mas a notificação continuava na lista após retornar à página.

**Causa:** Mesma do problema #2 - método `removerNotificacao()` tinha lógica condicional.

**Solução aplicada:**
- Arquivo: `lib/ui/notificacoes/notificacoes_page/view_model/notificacoes_view_model.dart` (linhas 173-183)
- Mesma correção aplicada:
  ```dart
  Future<bool> removerNotificacao(UnifiedNotification notificacao) async {
    // CORRIGIDO: Agora oculta no Firestore para TODAS as notificações
    final success = await _repository.removerNotificacao(notificacao.id);
    if (success) {
      await refresh();
    }
    return success;
  }
  ```

**Nota:** As notificações NÃO são deletadas do Firestore, apenas marcadas como `ocultado: true` no `user_states`. Isso preserva os dados e permite análise futura.

**Status:** ✅ Implementado, aguardando teste

---

## 🔍 Problema Em Investigação

### 4. 🔍 Navegação de in_app_notifications (tickets/discussões) não funciona

**Problema reportado:** "Cliquei em resposta de ticket e não fez nada"

**Código de navegação existente:**
- Arquivo: `lib/ui/notificacoes/notificacoes_page/notificacoes_page.dart` (linhas 311-320)
- Rotas configuradas:
  - Tickets: `/suporte/ticket/{id}`
  - Discussões: `/ead/curso/{cursoId}/discussoes/{id}`

**Debug adicionado:**
- Arquivo: `notificacoes_page.dart` (linhas 302-339) - Marcadores 🔵
- Arquivo: `notificacoes_view_model.dart` (linhas 228-264) - Marcadores 🟦

**Próximos passos:**
1. ✅ Rodar o app em debug mode
2. ✅ Clicar em uma notificação de ticket ou discussão
3. ✅ Verificar logs no console com emojis 🔵 e 🟦
4. ⏭️ Enviar logs para análise

**Logs esperados:**
```
🟦 onNotificacaoTap: Iniciando...
🟦 notificacao.source: NotificationSource.ead
🟦 EAD notification detected
🟦 ead.relatedType: ticket
🟦 ead.relatedId: abc123
🔵 _handleNotificacaoTap: Iniciando...
🔵 type: ticket, id: abc123
🔵 Navegando para ticket: /suporte/ticket/abc123
```

**Status:** 🔍 Aguardando logs do usuário para diagnóstico

---

## 🏗️ Arquitetura do Sistema de Notificações

### Collections do Firestore

```
┌─────────────────────────────────────────────────────────┐
│                  3 Collections de Notificações           │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  1. in_app_notifications                                 │
│     └─ user_states/{userId}                              │
│        ├─ lido: boolean                                  │
│        ├─ ocultado: boolean                              │
│        └─ dataLeitura: timestamp                         │
│                                                           │
│  2. ead_push_notifications                               │
│     └─ user_states/{userId}                              │
│        ├─ lido: boolean                                  │
│        ├─ ocultado: boolean                              │
│        └─ dataLeitura: timestamp                         │
│                                                           │
│  3. global_push_notifications                            │
│     └─ user_states/{userId}                              │
│        ├─ lido: boolean                                  │
│        ├─ ocultado: boolean                              │
│        └─ dataLeitura: timestamp                         │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

### Fluxo de Dados

```
┌──────────────┐
│ Firestore    │ (3 collections)
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│ NotificacoesRepo     │ (busca unificada + tries all 3)
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UnifiedNotification  │ (model unificado)
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ NotificacoesViewModel│ (lógica de negócio)
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ NotificacoesPage     │ (UI)
└──────────────────────┘
```

### Padrão "Dummy Update"

Para disparar streams do Firestore quando subcollections mudam:

```dart
// 1. Atualiza subcollection user_states
await notificationRef
    .collection('user_states')
    .doc(userId)
    .set(newState.toMap());

// 2. CRITICAL: Atualiza documento principal para disparar stream
await notificationRef.update({
  'lastUpdated': FieldValue.serverTimestamp(),
});
```

**Por que isso é necessário?**
- Firestore streams **NÃO** detectam mudanças em subcollections
- Atualizar o documento principal força o stream a emitir evento
- Isso garante que a UI recarrega automaticamente

---

## 📊 Queries do Repository

### Notificações Globais (3 queries)

```dart
// Query 1: Por recipientsRef (array de DocumentReference)
.where('recipientsRef', arrayContains: userRef)

// Query 2: Por destinatarioTipo = "usuarios"
.where('destinatarioTipo', isEqualTo: 'usuarios')

// Query 3: Por recipientEmail (email do usuário)
.where('recipientEmail', isEqualTo: userEmail)
```

### Notificações EAD (4 queries)

```dart
// Query 1: Por destinatarioId (usuário específico)
.where('destinatarioId', isEqualTo: userId)

// Query 2: Para todos
.where('destinatarioTipo', isEqualTo: 'Todos')

// Query 3: Por array de IDs
.where('destinatariosIds', arrayContains: userId)

// Query 4: Por array de emails
.where('destinatariosEmails', arrayContains: userEmail)
```

**Nota:** Resultados são combinados e deduplicados usando `Map<String, Doc>`.

---

## 🔧 Testes Necessários

### ✅ Para testar correções aplicadas:

1. **Teste de compatibilidade de campos:**
   - [ ] Criar notificação global no web admin com título e conteúdo
   - [ ] Verificar se exibe corretamente no app mobile
   - [ ] Verificar se campos `titulo`, `conteudo`, `imagemUrl` são lidos

2. **Teste de persistência "lido":**
   - [ ] Marcar notificação global como lida
   - [ ] Sair da página de notificações
   - [ ] Retornar à página
   - [ ] Verificar se continua como "lida" ✅
   - [ ] Verificar logs 🟡 no console

3. **Teste de remoção:**
   - [ ] Deletar notificação global
   - [ ] Verificar se contador diminui
   - [ ] Sair da página
   - [ ] Retornar à página
   - [ ] Verificar se notificação NÃO aparece mais ✅
   - [ ] Verificar logs 🔴 no console

4. **Teste de navegação:**
   - [ ] Criar notificação de ticket/discussão
   - [ ] Clicar na notificação
   - [ ] Verificar logs 🔵 e 🟦 no console
   - [ ] Enviar logs para análise
   - [ ] Verificar se navega corretamente (após fix)

---

## 📁 Arquivos Modificados

### Correções aplicadas:
1. `lib/data/models/firebase/notification_model.dart`
   - Linhas 64-84: Fallback de nomes de campos

2. `lib/ui/notificacoes/notificacoes_page/view_model/notificacoes_view_model.dart`
   - Linhas 145-156: Fix `marcarComoLida()`
   - Linhas 173-183: Fix `removerNotificacao()`

### Debug adicionado:
1. `lib/ui/notificacoes/notificacoes_page/notificacoes_page.dart`
   - Linhas 302-339: Logs 🔵 em `_handleNotificacaoTap`

2. `lib/ui/notificacoes/notificacoes_page/view_model/notificacoes_view_model.dart`
   - Linhas 228-264: Logs 🟦 em `onNotificacaoTap`

---

## 🎯 Próximas Ações

### Imediatas:
1. **Testar correções aplicadas** (persistência de estado)
2. **Rodar app e coletar logs de navegação** 🔵🟦
3. **Analisar logs e identificar onde navegação quebra**

### Após diagnóstico de navegação:
- Aplicar fix baseado nos logs recebidos
- Testar navegação para tickets
- Testar navegação para discussões

---

## 📚 Referências

- Web Admin: `/Users/rodrigoambros/Documents/Desenv/0.Clientes/Agencia/ProjGW/codigo/medita-bk-web-admin`
- Mobile App: `/Users/rodrigoambros/Documents/Desenv/0.Clientes/Agencia/ProjGW/codigo/medita-bk`
- Repository: `lib/data/repositories/notificacoes_repository.dart`
- ViewModel: `lib/ui/notificacoes/notificacoes_page/view_model/notificacoes_view_model.dart`

---

**Documento criado em:** 2025-12-11
**Última atualização:** 2025-12-11
