# Troubleshooting - Notificações não aparecem

> **📝 Nota:** As collections foram renomeadas em Dezembro/2024:
> - `notificacoes` → `in_app_notifications` (Notificações in-app)
> - `notificacoes_ead` → `ead_push_notifications` (Push notifications EAD)
> - `notifications` → `global_push_notifications` (Push notifications globais)

## 🔍 Checklist de Diagnóstico

### 1. Verificar Autenticação
```dart
// O usuário está autenticado?
print('User ID: ${currentUserUid}');
print('Autenticado: ${currentUserUid.isNotEmpty}');
```

### 2. Verificar Estrutura do Documento no Firestore

A notificação deve ter esta estrutura:

```javascript
// Collection: in_app_notifications (para notificações in-app)
{
  titulo: "Título da notificação",
  corpo: "Conteúdo da notificação",
  tipo: "ticket_resposta",  // ou outro tipo válido
  destinatarioId: "UID_DO_USUARIO",  // ⚠️ IMPORTANTE: deve ser exatamente o UID do Firebase Auth
  dados: {
    ticketId: "123",
    ticketNumero: 123,
    mensagemId: "msg_456"
  },
  dataCriacao: Timestamp,
  lida: false
}
```

**⚠️ ATENÇÃO**: O campo `destinatarioId` deve ser exatamente igual ao UID retornado por `currentUserUid`.

### 3. Verificar Nome da Collection

O app busca nas seguintes collections:
- **`in_app_notifications`** - Para notificações internas (tickets/discussões)
- **`ead_push_notifications`** - Para push notifications EAD
- **`global_push_notifications`** - Para push notifications globais

Se o módulo admin está salvando em collection antiga, as notificações não vão aparecer.

### 4. Verificar Regras do Firestore

As regras de segurança devem permitir leitura:

```javascript
// firestore.rules
match /in_app_notifications/{notificacaoId} {
  // Usuário pode ler suas próprias notificações
  allow read: if request.auth != null &&
              resource.data.destinatarioId == request.auth.uid;

  // Apenas o app pode criar notificações ou admins
  allow create: if request.auth != null;
}

match /ead_push_notifications/{notificacaoId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null &&
                hasAdminRole(request.auth.uid);
}

match /global_push_notifications/{notificacaoId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null &&
                hasAdminRole(request.auth.uid);
}
```

### 5. Verificar Índices Compostos

O Firestore precisa de índices compostos para as queries:

**Collection:** `in_app_notifications`
**Campos indexados:**
- `destinatarioId` (Ascending)
- `dataCriacao` (Descending)

**Como criar:**
1. Abrir Firebase Console
2. Firestore Database → Indexes
3. Criar índice composto com os campos acima

Ou o Firebase vai sugerir criar quando você tentar buscar pela primeira vez (link no erro).

### 6. Query Usada pelo App

```dart
_notificacoesCollection
  .where('destinatarioId', isEqualTo: usuarioId)
  .orderBy('dataCriacao', descending: true)
  .limit(50)
```

### 7. Testar Manualmente no Firestore Console

1. Abrir Firebase Console
2. Firestore Database
3. Collection `notificacoes_ead`
4. Adicionar documento manualmente:

```javascript
{
  titulo: "Teste",
  corpo: "Notificação de teste",
  tipo: "ticket_resposta",
  destinatarioId: "SEU_UID_AQUI",  // ⚠️ Copiar do debug info
  dados: {
    ticketId: "test123",
    ticketNumero: 123
  },
  dataCriacao: [Timestamp now],
  lida: false
}
```

5. Atualizar o app → deve aparecer

## 🐛 Debug Info Widget

Um widget de debug foi adicionado temporariamente à página de notificações que mostra:
- User ID atual
- Status de autenticação
- Total de notificações retornadas
- Dados da última notificação
- Contador de não lidas

## 📊 Como Testar do Admin

### Criar Notificação Corretamente

O módulo admin deve usar este código:

```javascript
// No admin web - Para notificações in-app
await admin.firestore()
  .collection('in_app_notifications')
  .add({
    titulo: 'Nova resposta',
    corpo: 'Admin respondeu seu ticket',
    tipo: 'ticket_resposta',
    destinatarioId: userId,  // UID do usuário do app
    dados: {
      ticketId: ticketId,
      ticketNumero: 123,
      mensagemId: mensagemId
    },
    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    lida: false
  });
```

## 🔄 Verificações Comuns

### ❌ Problema: UID Diferente
```
App espera: "abc123xyz"
Admin enviou para: "ABC123XYZ"
Resultado: Notificação não aparece
```

### ❌ Problema: Collection Errada
```
App busca em: "in_app_notifications"
Admin salva em: "notificacoes_ead" (collection antiga)
Resultado: Notificação não aparece
```

### ❌ Problema: Índice Faltando
```
Error: The query requires an index
Link: https://console.firebase.google.com/...
Resultado: Erro na query
```

### ❌ Problema: Regras Bloqueando
```
Error: Missing or insufficient permissions
Resultado: Notificação não carrega
```

## ✅ Solução Passo a Passo

1. **Copiar UID do usuário** do debug info na página de notificações

2. **Verificar no Firestore** se existe documento com:
   - Collection: `in_app_notifications` (para notificações in-app)
   - Campo: `destinatarioId` = UID copiado

3. **Se não existir**, criar manualmente para testar

4. **Se existir mas não aparece**, verificar:
   - Índice composto criado?
   - Regras permitem leitura?
   - Campo `dataCriacao` existe?
   - Está usando `corpo` ao invés de `conteudo`?

5. **Atualizar app** (pull to refresh ou reabrir)

## 📞 Suporte

Se após todas as verificações ainda não funcionar, fornecer:
- Screenshot do debug info
- Screenshot do documento no Firestore
- Screenshot das regras do Firestore
- Screenshot dos índices

---

**Nota**: O widget de debug pode ser removido depois de diagnosticar o problema.

