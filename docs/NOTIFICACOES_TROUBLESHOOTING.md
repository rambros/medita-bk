# Troubleshooting - Notificações não aparecem

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
// Collection: notificacoes_ead
{
  titulo: "Título da notificação",
  conteudo: "Conteúdo da notificação",
  tipo: "ticket_respondido",  // ou outro tipo válido
  destinatarioId: "UID_DO_USUARIO",  // ⚠️ IMPORTANTE: deve ser exatamente o UID do Firebase Auth
  relatedType: "ticket",
  relatedId: "123",
  remetenteId: "admin_id",
  remetenteNome: "Admin",
  dataCriacao: Timestamp,
  lido: false,
  dados: { /* dados extras */ }
}
```

**⚠️ ATENÇÃO**: O campo `destinatarioId` deve ser exatamente igual ao UID retornado por `currentUserUid`.

### 3. Verificar Nome da Collection

O app está buscando da collection: **`notificacoes_ead`**

Se o módulo admin está salvando em outra collection (ex: `notificacoes`), as notificações não vão aparecer.

### 4. Verificar Regras do Firestore

As regras de segurança devem permitir leitura:

```javascript
// firestore.rules
match /notificacoes_ead/{notificacaoId} {
  // Usuário pode ler suas próprias notificações
  allow read: if request.auth != null && 
              resource.data.destinatarioId == request.auth.uid;
  
  // Admin pode criar notificações
  allow create: if request.auth != null && 
                hasAdminRole(request.auth.uid);
}
```

### 5. Verificar Índices Compostos

O Firestore precisa de um índice composto para a query:

**Collection:** `notificacoes_ead`
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
  conteudo: "Notificação de teste",
  tipo: "ticket_criado",
  destinatarioId: "SEU_UID_AQUI",  // ⚠️ Copiar do debug info
  dataCriacao: [Timestamp now],
  lido: false
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
// No admin web
await admin.firestore()
  .collection('notificacoes_ead')
  .add({
    titulo: 'Nova resposta',
    conteudo: 'Admin respondeu seu ticket',
    tipo: 'ticket_respondido',
    destinatarioId: userId,  // UID do usuário do app
    relatedType: 'ticket',
    relatedId: ticketId,
    remetenteId: adminUid,
    remetenteNome: 'Admin',
    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    lido: false,
    dados: { ticketId: ticketId }
  });

// Atualizar contador
await admin.firestore()
  .collection('contadores_comunicacao')
  .doc(userId)
  .set({
    ticketsNaoLidos: admin.firestore.FieldValue.increment(1),
    totalNaoLidas: admin.firestore.FieldValue.increment(1),
    ultimaAtualizacao: admin.firestore.FieldValue.serverTimestamp()
  }, { merge: true });
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
App busca em: "notificacoes_ead"
Admin salva em: "notificacoes"
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
   - Collection: `notificacoes_ead`
   - Campo: `destinatarioId` = UID copiado

3. **Se não existir**, criar manualmente para testar

4. **Se existir mas não aparece**, verificar:
   - Índice composto criado?
   - Regras permitem leitura?
   - Campo `dataCriacao` existe?

5. **Atualizar app** (pull to refresh ou reabrir)

6. **Verificar contadores** em `contadores_comunicacao/{userId}`

## 📞 Suporte

Se após todas as verificações ainda não funcionar, fornecer:
- Screenshot do debug info
- Screenshot do documento no Firestore
- Screenshot das regras do Firestore
- Screenshot dos índices

---

**Nota**: O widget de debug pode ser removido depois de diagnosticar o problema.

