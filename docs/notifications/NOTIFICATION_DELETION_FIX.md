# Correção do Bug de Deleção de Notificações

## Problema Identificado

Quando o usuário deletava uma notificação EAD, ela desaparecia temporariamente da lista, mas reaparecia ao navegar de volta para a tela de notificações.

**Sintoma:** No Firebase, o campo `ocultado` permanecia como `false` ao invés de `true`, e o campo `lido` era resetado de `true` para `false`.

## Causa Raiz

O código estava criando um NOVO objeto `UserNotificationState` com valores padrão (`lido: false, ocultado: false`), e então chamava `marcarComoOcultada()`. Isso resultava em `{lido: false, ocultado: true}`, que sobrescrevia o estado existente no Firestore, perdendo a informação de que a notificação havia sido lida.

### Métodos Afetados

1. `_ocultarNotificacaoEad()` em [notificacoes_repository.dart](lib/data/repositories/notificacoes_repository.dart)
2. `_ocultarNotificacaoGlobal()` em [notificacoes_repository.dart](lib/data/repositories/notificacoes_repository.dart)
3. `ocultarNotificacao()` em [notificacao_ead_service.dart](lib/data/services/notificacao_ead_service.dart)

## Solução Implementada

### 1. Preservação de Estado

Modificados os 3 métodos para **buscar o estado atual** do usuário ANTES de marcar como ocultado:

```dart
// ANTES (INCORRETO)
final state = UserNotificationState(userId: userId); // ❌ Novo objeto com valores padrão
final newState = state.marcarComoOcultada(); // lido: false, ocultado: true

// DEPOIS (CORRETO)
// 1. Buscar estado atual do Firestore
final userStateDoc = await notificationRef
    .collection('user_states')
    .doc(userId)
    .get();

// 2. Usar estado existente ou criar novo se não existir
final currentState = userStateDoc.exists
    ? UserNotificationState.fromMap(userStateDoc.data()!, userId)
    : UserNotificationState(userId: userId);

// 3. Marcar como ocultado PRESERVANDO todos os campos existentes
final newState = currentState.marcarComoOcultada(); // ✅ lido: true, ocultado: true
```

### 2. Debug Logging

Adicionado logging extensivo com emojis para facilitar debugging:

- 🔵 = `removerNotificacao()` (método principal)
- 🟢 = `NotificacaoEadService.ocultarNotificacao()` (in_app_notifications)
- 🔴 = `_ocultarNotificacaoEad()` (ead_push_notifications)
- ⏭️ = Notificação pulada por estar ocultada

### 3. Stream Melhorado

O `streamNotificacoesUnificadas()` foi expandido para monitorar TODAS as queries possíveis:

**ead_push_notifications (4 streams):**
1. `destinatarioId` = userId
2. `destinatarioTipo` = 'Todos'
3. `destinatariosIds` arrayContains userId
4. `destinatariosEmails` arrayContains userEmail

**global_push_notifications (3-4 streams):**
1. `recipientsRef` arrayContains userRef
2. `typeRecipients` = 'Todos'
3. `recipientEmail` = userEmail (se usuário tiver email)

**in_app_notifications (1 stream):**
1. Stream do NotificacaoEadService

**Otimizações:**
- Email do usuário é buscado UMA VEZ no início do stream (ao invés de 2x)
- Cada listener tem debug log com emoji 🔔 para identificar qual query disparou
- Email só é usado se disponível e não-vazio

Isso garante que:
1. A UI atualize imediatamente quando uma notificação for criada, editada ou deletada
2. O ícone de notificações no AppBar atualize automaticamente
3. Todas as formas de targetar usuários sejam monitoradas (individual, grupo, curso, todos)

## Arquivos Modificados

### 1. [lib/data/repositories/notificacoes_repository.dart](lib/data/repositories/notificacoes_repository.dart)

**Linhas 152-155:** Adicionado log quando notificação é pulada
```dart
if (userState.ocultado) {
  debugPrint('⏭️ Pulando notificação ${doc.id} - ocultado: true');
  continue;
}
```

**Linhas 305-404:** Stream expandido para monitorar todas as queries
- Antes: 3 streams (1 in_app, 1 ead_push, 1 global)
- Depois: 8-9 streams (1 in_app, 4 ead_push, 3-4 global)

**Linhas 507-541:** Debug logging em `removerNotificacao()`

**Linhas 544-587:** Fix em `_ocultarNotificacaoEad()` com preservação de estado e debug logging

**Linhas 590-619:** Fix em `_ocultarNotificacaoGlobal()` com preservação de estado

### 2. [lib/data/services/notificacao_ead_service.dart](lib/data/services/notificacao_ead_service.dart)

**Linhas 255-298:** Fix em `ocultarNotificacao()` com preservação de estado e debug logging

## Verificação

Os logs confirmam que a correção está funcionando:

```
🔴 _ocultarNotificacaoEad: Estado atual - lido: true, ocultado: false
🔴 _ocultarNotificacaoEad: Novo estado - lido: true, ocultado: true
🔴 _ocultarNotificacaoEad: Salvando no Firestore: {
  lido: true,
  ocultado: true,
  dataLeitura: Timestamp(...),
  dataOcultacao: Timestamp(...)
}
🔴 _ocultarNotificacaoEad: Salvo com sucesso!
```

## Comportamento Esperado

1. Usuário recebe notificação EAD → `{lido: false, ocultado: false}`
2. Usuário lê notificação → `{lido: true, ocultado: false}`
3. Usuário deleta notificação → `{lido: true, ocultado: true}` ✅
4. Ao navegar de volta → Notificação não aparece na lista (filtrada por `ocultado: true`)

## Próximos Passos (Se Necessário)

Se o problema persistir após esta correção:

1. Verificar no **Firebase Console** se os dados estão sendo salvos corretamente
2. Verificar se há **Firestore Security Rules** bloqueando a escrita
3. Verificar se há algum **cache** local que não está sendo invalidado
4. Verificar se há algum **listener** sobrescrevendo os dados após o save

## Problema Adicional: Ícone de Notificações Não Atualizava

### Problema 1: Nova Notificação Criada

#### Sintoma
Quando uma nova notificação era criada no web admin, o ícone de notificações na home page não atualizava automaticamente para mostrar o badge com o contador.

#### Causa
O stream `streamNotificacoesUnificadas()` não estava monitorando todas as possíveis formas de uma notificação targetar um usuário. Por exemplo:
- Notificações de grupo via `destinatariosIds` ou `destinatariosEmails` não eram monitoradas
- Notificações "Todos" de `ead_push_notifications` não eram monitoradas
- Notificações por email de `global_push_notifications` não eram monitoradas

#### Solução
Expandido o stream de 3 listeners para 8-9 listeners, cobrindo TODAS as queries possíveis. Agora o `NotificationBadgeIcon` recebe atualizações em tempo real de qualquer mudança em qualquer collection.

#### Como Testar
1. Abra o app mobile e vá para a home page
2. No web admin, crie uma nova notificação EAD (qualquer tipo: individual, grupo, curso ou todos)
3. O badge no ícone de notificações deve aparecer/atualizar IMEDIATAMENTE sem precisar fechar e reabrir o app
4. Observe os logs com 🔔 para ver qual stream detectou a mudança

---

### Problema 2: Marcar como Lida/Ocultar Não Atualizava

#### Sintoma
Quando o usuário marca uma notificação como lida ou a oculta (deleta), o ícone de notificações não atualiza automaticamente. É necessário navegar para outra tela e voltar.

#### Causa Raiz
**Limitação do Firestore:** Streams monitoram apenas a **collection principal**, NÃO as **subcollections**.

Quando marcamos uma notificação como lida ou ocultada:
1. Alteramos `ead_push_notifications/{id}/user_states/{userId}` (subcollection)
2. O documento principal `ead_push_notifications/{id}` NÃO é modificado
3. Portanto, o stream que monitora `ead_push_notifications` **NÃO dispara**
4. A UI não atualiza automaticamente

#### Solução Implementada
**"Dummy Update"** no documento principal para forçar disparo do stream:

Após atualizar o `user_state` (subcollection), fazemos um update no documento principal:

```dart
// 1. Atualiza user_state (subcollection)
await notificationRef
    .collection('user_states')
    .doc(userId)
    .set(newState.toMap(), SetOptions(merge: true));

// 2. CRITICAL: Força disparo do stream
await notificationRef.update({
  'lastUpdated': FieldValue.serverTimestamp(),
});
```

Isso adiciona/atualiza o campo `lastUpdated` no documento principal, fazendo com que:
1. O Firestore detecte mudança no documento principal
2. Os streams que monitoram a collection disparem
3. O `streamNotificacoesUnificadas()` recarregue todas as notificações
4. O badge atualize instantaneamente

#### Métodos Modificados
1. `_marcarComoLidaEad()` - linha 564-568
2. `_marcarComoLidaGlobal()` - linha 620-623
3. `_ocultarNotificacaoEad()` - linha 727-730
4. `_ocultarNotificacaoGlobal()` - linha 765-768

#### Como Testar
1. Abra o app e vá para a lista de notificações
2. Marque uma notificação EAD como lida
3. Volte para a home page
4. O badge deve atualizar IMEDIATAMENTE (contador diminui)
5. Observe os logs:
   ```
   🟡 _marcarComoLidaEad: ✅ Marcado como lida e stream disparado!
   🔔 Stream: Mudança detectada em ead_push_notifications (...)
   ```

## Debug Logging: Global Notifications

### Problema Reportado (2025-12-11)

Usuário criou uma notificação global (global_push_notifications) mas ela não aparece na lista de notificações nem atualiza o contador do badge.

### Debug Logging Adicionado

Adicionado logging extensivo com emoji 🟣 para facilitar debugging de notificações globais:

**Em `getNotificacoesUnificadas()` - linhas 182-317:**

```dart
🟣 GLOBAL: Iniciando busca de notificações globais para userId: ...
🟣 GLOBAL: UserRef path: users/...
🟣 GLOBAL: Email do usuário: ...

// Query 1: recipientsRef arrayContains
🟣 GLOBAL Query 1: Buscando por recipientsRef arrayContains...
🟣 GLOBAL Query 1: Encontrou X notificações

// Query 2: typeRecipients == 'Todos'
🟣 GLOBAL Query 2: Buscando typeRecipients == "Todos"...
🟣 GLOBAL Query 2: Encontrou X notificações
🟣 GLOBAL Query 2: Doc ID: ...
🟣 GLOBAL Query 2: Data: {...}

// Query 3: recipientEmail
🟣 GLOBAL Query 3: Buscando por recipientEmail == "..."...
🟣 GLOBAL Query 3: Encontrou X notificações

// Processamento
🟣 GLOBAL: Combinando resultados...
🟣 GLOBAL: Total de X docs únicos após combinar queries
🟣 GLOBAL: Processando doc ...
🟣 GLOBAL: Doc ID - Estado: lido=..., ocultado=...
🟣 GLOBAL: ✅ Doc ID adicionado às notificações unificadas
🟣 GLOBAL: Resumo - Total: X, Processados: Y, Pulados (ocultado): Z, Pulados (lido): W
```

### Solução Implementada

**Problema:** As queries estavam usando `.orderBy('dataEnvio')`, que **falhava silenciosamente** se algum documento não tivesse esse campo.

**Fix aplicado:**
1. Removido `orderBy('dataEnvio')` das 3 queries de `global_push_notifications`
2. Aumentado limite para `limite * 2` para compensar
3. Ordenação agora feita em memória após buscar todos os documentos (linha 336)
4. Adicionado try-catch individual em cada query para capturar erros
5. Queries agora retornam nullable (`QuerySnapshot?`) e são verificadas antes de processar

**Benefícios:**
- Queries funcionam mesmo se `dataEnvio` estiver ausente em alguns docs
- Erros de query individuais não quebram as outras queries
- Debug logs mostram exatamente qual query falhou

**Linhas modificadas:**
- Queries em `getNotificacoesUnificadas()`: linhas 202-252
- Streams em `streamNotificacoesUnificadas()`: linhas 456-504

### Como Investigar

1. Abra o app mobile e navegue para a página de notificações
2. Observe os logs com 🟣 para entender o que está acontecendo:
   - As queries estão encontrando documentos?
   - Os documentos estão sendo processados ou pulados?
   - Há algum erro ao processar os documentos?

3. Possíveis problemas restantes:
   - **Campo `typeRecipients` com valor diferente**: Ex: 'todos' (minúsculo) ao invés de 'Todos'
   - **Documentos sendo pulados**: Verifique se não estão marcados como ocultado=true
   - **Erro ao parsear**: Verifique se todos os campos esperados existem

4. Verificar no Firebase Console:
   - Abra `global_push_notifications` collection
   - Verifique se o documento criado tem os campos básicos:
     - `typeRecipients` (String) - 'Todos', 'Individual', etc.
     - `title` (String)
     - `content` (String)
     - `type` (String)
     - `imagePath` (String, pode ser vazio)
     - `recipientEmail` (String, pode ser vazio)
     - `recipientsRef` (Array de References, pode ser vazio)
     - `dataEnvio` (Timestamp, opcional - mas recomendado para ordenação)

## Data da Correção

2025-12-11
