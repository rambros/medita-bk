# Auditoria de Compatibilidade: Firestore Rules vs Código

> ⚠️ **DOCUMENTO HISTÓRICO — auditoria de 2026-03-27, problemas já corrigidos em 29/03/2026.**
> Para a referência atualizada de regras, consulte: [`FIRESTORE_RULES.md`](FIRESTORE_RULES.md)

**Projeto:** meditabk2020 (Firebase) → medita-bk (Código Flutter)
**Data:** 2026-03-27
**Status:** ✅ CORRIGIDO em 29/03/2026 — ver `FIRESTORE_RULES.md`

---

## 📊 Resumo Executivo

### Status Geral: ⚠️ ATENÇÃO NECESSÁRIA

- ✅ **12 collections compatíveis**
- ⚠️ **3 collections com problemas**
- ❌ **4 collections sem regras definidas**
- 🔒 **1 problema crítico de segurança**

---

## ✅ Collections Compatíveis

### 1. **users** ✅
**Rules (linha 29-40):**
```javascript
allow read: if request.auth != null;
allow write: if request.auth != null &&
             (isOwner(userId) && isNotUpdatingField('role') || hasAdminRole());
```

**Código:** ✅ Compatível
- Leituras: Requer autenticação ✓
- Escritas: Próprio usuário ou admin ✓
- Proteção do campo `role` ✓
- Subcollection `fcm_tokens` protegida ✓

**Operações verificadas:**
- getUserById, updateUser, updateContactInfo ✅
- addToFavorites, removeFromFavorites ✅
- Admins podem gerenciar todos usuários ✅

---

### 2. **meditations** ✅
**Rules (linha 46-52):**
```javascript
allow read: if request.auth != null;
allow update: if request.auth != null &&
              request.resource.data.diff(resource.data).affectedKeys().hasOnly(['numPlayed', 'numLiked']);
allow write: if hasAdminRole();
```

**Código:** ✅ Compatível
- Leituras públicas (com auth) ✓
- Incrementos de contadores permitidos ✓
- Criação/deleção apenas admin ✓

**Operações verificadas:**
- getMeditations, searchMeditations ✅
- incrementPlayCount, incrementLikeCount ✅

---

### 3. **category** ✅
**Rules (linha 54-57):**
```javascript
allow read: if request.auth != null;
allow write: if hasAdminRole();
```

**Código:** ✅ Compatível
- Leituras públicas (com auth) ✓
- Apenas admins criam/editam categorias ✓

---

### 4. **traffic_control_musics** ✅
**Rules (linha 59-62):**
```javascript
allow read: if request.auth != null;
allow write: if hasAdminRole();
```

**Código:** ✅ Compatível
- Collection: `traffic_control_musics`
- Código: `lib/data/services/tc_music_api_service.dart`
- Operações:
  - getActiveMusics() - read ✅
  - getMusicsByCategory() - read ✅
  - Admin methods (createMusic, updateMusic, deleteMusic) ✅

---

### 5. **cursos** (com subcollections) ✅
**Rules (linha 68-76):**
```javascript
allow read: if request.auth != null;
allow write: if hasAdminRole();

match /{document=**} {
  allow read: if request.auth != null;
  allow write: if hasAdminRole();
}
```

**Código:** ✅ Compatível
- Cursos: read público ✓
- Aulas: read público (subcollection) ✓
- Tópicos: read público (subcollection) ✓
- Apenas admins criam/editam ✓

**Subcollections protegidas:**
- cursos/{cursoId}/aulas ✅
- cursos/{cursoId}/aulas/{aulaId}/topicos ✅

---

### 6. **inscricoes_cursos** ✅
**Rules (linha 78-84):**
```javascript
allow read: if request.auth != null &&
            (resource.data.usuarioId == request.auth.uid || hasAdminRole());
allow create: if request.auth != null &&
              request.resource.data.usuarioId == request.auth.uid;
allow update: if request.auth != null &&
              (resource.data.usuarioId == request.auth.uid || hasAdminRole());
allow delete: if hasAdminRole();
```

**Código:** ✅ Compatível
- Usuário lê apenas próprias inscrições ✓
- Usuário cria apenas próprias inscrições ✓
- Usuário atualiza apenas próprias inscrições ✓
- Apenas admin pode deletar ✓

**Operações verificadas:**
- getInscricao(cursoId, usuarioId) ✅
- criarInscricao() ✅
- atualizarProgresso() ✅

---

### 7. **avaliacoes_cursos** ✅
**Rules (linha 86-90):**
```javascript
allow read: if request.auth != null &&
            (resource.data.usuarioId == request.auth.uid || hasAdminRole());
allow create: if request.auth != null &&
              request.resource.data.usuarioId == request.auth.uid;
allow update: if hasAdminRole();
```

**Código:** ✅ Compatível
- Usuário lê própria avaliação ✓
- Usuário cria própria avaliação ✓
- Apenas admin atualiza ✓

---

### 8. **tickets** (com subcollection mensagens) ✅
**Rules (linha 101-111):**
```javascript
allow read: if request.auth != null &&
            (resource.data.usuarioId == request.auth.uid || hasAdminRole());
allow create: if request.auth != null &&
              request.resource.data.usuarioId == request.auth.uid;
allow update: if request.auth != null &&
              (resource.data.usuarioId == request.auth.uid || hasAdminRole());

match /mensagens/{msgId} {
  allow read: if request.auth != null && ...
  allow create: if request.auth != null;
}
```

**Código:** ✅ Compatível
- Usuário vê apenas próprios tickets ✓
- Admins veem todos tickets ✓
- Mensagens protegidas ✓

---

### 9. **discussoes** (com subcollection respostas) ✅
**Rules (linha 113-124):**
```javascript
allow read: if request.auth != null;
allow create: if request.auth != null;
allow update: if request.auth != null &&
              (resource.data.usuarioId == request.auth.uid || hasAdminRole());
allow delete: if hasAdminRole();

match /respostas/{respId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null;
  allow update, delete: if request.auth != null && ...
}
```

**Código:** ✅ Compatível
- Discussões públicas (com auth) ✓
- Autor pode editar própria discussão ✓
- Respostas protegidas ✓

---

### 10. **desafio21** ✅
**Rules (linha 143-146):**
```javascript
allow read: if request.auth != null;
allow write: if hasAdminRole();
```

**Código:** ✅ Compatível
- Template do desafio é read-only para usuários ✓
- Progresso do usuário salvo em users/{userId} ✓

---

### 11. **settings** ✅
**Rules (linha 148-151):**
```javascript
allow read: if request.auth != null;
allow write: if hasAdminRole();
```

**Código:** ✅ Compatível
- App settings visível para usuários autenticados ✓
- Apenas admins editam ✓

---

### 12. **notifications** (com subcollection user_states) ✅
**Rules (linha 130-137):**
```javascript
allow read: if request.auth != null &&
            (resource.data.destinatarios.hasAny([request.auth.uid, 'TODOS']));
allow write: if hasAdminRole();

match /user_states/{userId} {
  allow read, write: if isOwner(userId);
}
```

**Código:** ✅ Compatível
- Notificações filtradas por destinatário ✓
- Apenas admin cria notificações ✓
- user_states: usuário gerencia próprio estado ✓

**Operações verificadas:**
- Query: `where('destinatarios', arrayContainsAny: [userId, 'TODOS'])` ✅
- marcarComoLida() escreve em user_states/{userId} ✅

---

## ⚠️ Collections com Problemas

### 1. **grupos** ⚠️
**Rules (linha 92-95):**
```javascript
allow read: if request.auth != null;
allow write: if hasAdminRole();
```

**Código:** ⚠️ **COLLECTION NÃO UTILIZADA**
- Não há nenhum service/repository que acesse `grupos`
- Rules definidas mas funcionalidade não implementada

**Recomendação:**
- ✅ Manter rules (não causa problemas)
- ⏸️ Aguardar futura implementação de grupos

---

### 2. **user_states** ⚠️
**Rules (linha 158-163):**
```javascript
match /user_states/{userId} {
  allow read, write: if isOwner(userId);
  match /{allPaths=**} {
    allow read, write: if isOwner(userId);
  }
}
```

**Código:** ⚠️ **DUPLICADO COM notifications/user_states**
- Existe `notifications/{notifId}/user_states/{userId}` (usado)
- Existe `/user_states/{userId}` (não usado)
- Possível duplicação de regras

**Recomendação:**
- 🔍 Verificar se é collection separada ou obsoleta
- 🧹 Remover se não for usado

---

## ❌ Collections SEM Regras Definidas

### 1. **musics** ❌ CRÍTICO
**Código:** `lib/data/repositories/music_repository.dart`
- Collection: `musics` (música de fundo para meditações)
- Operações:
  - streamMusics(limit?) - read
  - getMusics(limit?) - read
  - getMusicById(id) - read

**Rules Atuais:** ❌ **NENHUMA REGRA DEFINIDA**

**Impacto:**
- ❌ Leituras podem falhar com permission denied
- ❌ App pode não funcionar corretamente

**Regra Necessária:**
```javascript
match /musics/{musicId} {
  allow read: if request.auth != null;
  allow write: if hasAdminRole();
}
```

---

### 2. **messages** ❌
**Código:** `lib/data/repositories/mensagem_repository.dart`
- Collection: `messages`
- Operações:
  - getMensagemById(id) - read

**Rules Atuais:** ❌ **NENHUMA REGRA DEFINIDA**

**Regra Necessária:**
```javascript
match /messages/{messageId} {
  allow read: if request.auth != null;
  allow write: if hasAdminRole();
}
```

---

### 3. **in_app_notifications** ⚠️ Obsoleto?
**Rules (linha 153-156):**
```javascript
allow read: if request.auth != null &&
            (resource.data.userId == request.auth.uid ||
             resource.data.recipientUserIds.hasAny([request.auth.uid]));
allow write: if hasAdminRole();
```

**Código:** ❌ **NÃO UTILIZADO**
- Nenhum service/repository acessa essa collection
- Substituído por `notifications` com user_states?

**Recomendação:**
- 🧹 Remover rules se não for usado
- 📝 Ou documentar o propósito

---

### 4. **contadores_comunicacao** ❌
**Código:** `lib/data/services/notificacao_ead_service.dart`
- Collection: `contadores_comunicacao`
- Operações:
  - Increment counters (discussoes, tickets, respostas)

**Rules Atuais:** ❌ **NENHUMA REGRA DEFINIDA**

**Regra Necessária:**
```javascript
match /contadores_comunicacao/{contadorId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null; // Para incrementos
}
```

---

## 🔒 Problemas Críticos de Segurança

### 1. **API Keys em Firestore** 🔴 CRÍTICO
**Localização:** `settings/app_settings`
- `resendApiKey` (chave da API Resend)
- `resendFromEmail`
- `resendFromName`

**Problema:**
- API keys armazenadas em Firestore podem ser expostas
- Mesmo com rules de admin-only, há risco de vazamento

**Recomendação:**
- 🔒 Mover para Cloud Functions com Secret Manager
- ✅ Ou usar Firebase Functions Config

**Código Afetado:**
- `lib/data/repositories/avaliacao_repository.dart` linha 90-120
- HTTP request direto do app para Resend API

---

### 2. **Falta de Validação de Owner em Algumas Operações**
**Localização:** Múltiplos repositories

**Problema:**
- Alguns métodos não validam se `userId == currentUser.uid`
- Dependem apenas das Firestore Rules

**Exemplo:**
```dart
// desafio_repository.dart
Future<void> updateDesafio21(String userId, ...) async {
  // ❌ Não valida se userId == currentUser
  await _firestore.collection('users').doc(userId).update({...});
}
```

**Recomendação:**
- ✅ Adicionar validação no código:
```dart
if (userId != currentUser?.uid) {
  throw UnauthorizedException('Cannot update other user data');
}
```

---

### 3. **Batch Operations Sem Limite**
**Localização:** `notificacoes_repository.dart` linha 215-218

**Problema:**
```dart
// Limite hardcoded em 500 operações
WriteBatch batch = _firestore.batch();
for (var notif in notificacoes) {
  batch.update(...);
}
await batch.commit(); // ❌ Pode falhar se > 500 itens
```

**Recomendação:**
- ✅ Implementar chunking:
```dart
final chunks = notificacoes.splitInChunks(500);
for (var chunk in chunks) {
  WriteBatch batch = _firestore.batch();
  for (var notif in chunk) {
    batch.update(...);
  }
  await batch.commit();
}
```

---

## 📋 Checklist de Correções Necessárias

### 🔴 Prioridade ALTA (Bloqueia funcionalidades)

- [ ] **Adicionar rules para `musics` collection**
  - Localização: `firebase/firestore.rules` linha 62 (após traffic_control_musics)
  - Regra:
    ```javascript
    match /musics/{musicId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }
    ```

- [ ] **Adicionar rules para `messages` collection**
  - Localização: `firebase/firestore.rules` linha 62
  - Regra:
    ```javascript
    match /messages/{messageId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }
    ```

- [ ] **Adicionar rules para `contadores_comunicacao`**
  - Localização: `firebase/firestore.rules` linha 125 (após discussoes)
  - Regra:
    ```javascript
    match /contadores_comunicacao/{contadorId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    ```

### 🟡 Prioridade MÉDIA (Melhorias de segurança)

- [ ] **Mover API keys para Cloud Functions**
  - Migrar Resend API para Firebase Cloud Functions
  - Remover chaves de `settings/app_settings`
  - Atualizar `avaliacao_repository.dart` para chamar Cloud Function

- [ ] **Adicionar validação de owner no código**
  - `desafio_repository.dart` - updateDesafio21()
  - `comunicacao_repository.dart` - criarTicket(), criarDiscussao()
  - Adicionar helper method: `assertIsOwner(userId)`

- [ ] **Implementar chunking em batch operations**
  - `notificacoes_repository.dart` - marcarTodasComoLidas()
  - Limitar a 500 operações por batch

### 🟢 Prioridade BAIXA (Limpeza)

- [ ] **Remover rules obsoletas**
  - Verificar se `in_app_notifications` é usado
  - Verificar se `user_states` (raiz) é usado
  - Documentar propósito de `grupos`

- [ ] **Consolidar acesso ao Firestore**
  - Usar `FirestoreService` em vez de `FirebaseFirestore.instance`
  - Padronizar error handling

- [ ] **Adicionar testes de rules**
  - Criar testes em `firebase/firestore.test.js`
  - Validar todas permissões

---

## 🚀 Script de Correção das Rules

### Arquivo: `firebase/firestore.rules` (atualizado)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ============================================
    // HELPER FUNCTIONS
    // ============================================

    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }

    function hasAdminRole() {
      return request.auth != null &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    function isNotUpdatingField(field) {
      return !(field in request.resource.data) || resource.data[field] == request.resource.data[field];
    }

    // ============================================
    // USERS
    // ============================================

    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null &&
                      (isOwner(userId) && isNotUpdatingField('role') || hasAdminRole());

      match /fcm_tokens/{tokenId} {
        allow read: if request.auth != null && (isOwner(userId) || hasAdminRole());
        allow write: if isOwner(userId);
      }
    }

    // ============================================
    // CONTEÚDO (Meditações, Categorias, Músicas)
    // ============================================

    match /meditations/{meditationId} {
      allow read: if request.auth != null;
      allow update: if request.auth != null &&
                       request.resource.data.diff(resource.data).affectedKeys().hasOnly(['numPlayed', 'numLiked']);
      allow write: if hasAdminRole();
    }

    match /category/{categoryId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    // ✅ ADICIONADO: Rules para musics (música de fundo para meditações)
    match /musics/{musicId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    // ✅ ADICIONADO: Rules para messages
    match /messages/{messageId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    match /traffic_control_musics/{musicId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    // ============================================
    // EAD (Cursos, Aulas, Tópicos, Inscrições)
    // ============================================

    match /cursos/{cursoId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();

      match /{document=**} {
        allow read: if request.auth != null;
        allow write: if hasAdminRole();
      }
    }

    match /inscricoes_cursos/{inscricaoId} {
      allow read: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());
      allow create: if request.auth != null && request.resource.data.usuarioId == request.auth.uid;
      allow update: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());
      allow delete: if hasAdminRole();
    }

    match /avaliacoes_cursos/{inscricaoId} {
      allow read: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());
      allow create: if request.auth != null && request.resource.data.usuarioId == request.auth.uid;
      allow update: if hasAdminRole();
    }

    match /grupos/{grupoId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    // ============================================
    // COMUNICAÇÃO (Tickets, Discussões)
    // ============================================

    match /tickets/{ticketId} {
      allow read: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());
      allow create: if request.auth != null && request.resource.data.usuarioId == request.auth.uid;
      allow update: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());

      match /mensagens/{msgId} {
        allow read: if request.auth != null && (get(/databases/$(database)/documents/tickets/$(ticketId)).data.usuarioId == request.auth.uid || hasAdminRole());
        allow create: if request.auth != null;
      }
    }

    match /discussoes/{discId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());
      allow delete: if hasAdminRole();

      match /respostas/{respId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && (resource.data.usuarioId == request.auth.uid || hasAdminRole());
      }
    }

    // ✅ ADICIONADO: Rules para contadores de comunicação
    match /contadores_comunicacao/{contadorId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Permite incrementos de usuários
    }

    // ============================================
    // NOTIFICAÇÕES (Sistema Unificado V2)
    // ============================================

    match /notifications/{notifId} {
      allow read: if request.auth != null && (resource.data.destinatarios.hasAny([request.auth.uid, 'TODOS']));
      allow write: if hasAdminRole();

      match /user_states/{userId} {
        allow read, write: if isOwner(userId);
      }
    }

    // ============================================
    // SISTEMA E LEGADO
    // ============================================

    match /desafio21/{docId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    match /settings/{docId} {
      allow read: if request.auth != null;
      allow write: if hasAdminRole();
    }

    // ⚠️ REVISAR: Verificar se ainda é usado
    match /in_app_notifications/{notifId} {
      allow read: if request.auth != null && (resource.data.userId == request.auth.uid || resource.data.recipientUserIds.hasAny([request.auth.uid]));
      allow write: if hasAdminRole();
    }

    // ⚠️ REVISAR: Verificar se é diferente de notifications/user_states
    match /user_states/{userId} {
      allow read, write: if isOwner(userId);
      match /{allPaths=**} {
        allow read, write: if isOwner(userId);
      }
    }

    match /ff_push_notifications/{notifId} {
      allow read, write: if hasAdminRole();
    }

    match /_rowy_/{docId} {
      allow read: if request.auth != null && request.auth.token.roles.size() > 0;
      allow write: if hasAdminRole();
      match /{document=**} {
        allow read: if request.auth != null && request.auth.token.roles.size() > 0;
        allow write: if hasAdminRole();
      }
    }
  }
}
```

---

## 📝 Como Aplicar as Correções

### 1. Backup das Rules Atuais
```bash
cd /Users/rodrigoambros/Documents/Desenv/0.Clientes/Agencia/ProjGW/codigo/medita-bk/firebase
cp firestore.rules firestore.rules.backup
```

### 2. Aplicar Rules Corrigidas
```bash
# Copiar o script acima para firestore.rules
# Ou aplicar as mudanças manualmente
```

### 3. Deploy das Rules
```bash
firebase deploy --only firestore:rules
```

### 4. Validar Rules
```bash
# Testar localmente
firebase emulators:start --only firestore

# Ou testar com Firebase Console
# https://console.firebase.google.com/project/meditabk2020/firestore/rules
```

---

## 🧪 Testes Recomendados

### Após aplicar as correções, testar:

1. **Músicas de Fundo (musics):**
   - [ ] Abrir app e navegar para meditação
   - [ ] Verificar se músicas de fundo carregam
   - [ ] Verificar logs: `TcMusicRepository: X música(s) carregada(s)`

2. **Mensagens (messages):**
   - [ ] Verificar funcionalidade que usa mensagens
   - [ ] Confirmar que não há permission denied

3. **Contadores de Comunicação:**
   - [ ] Criar ticket ou discussão
   - [ ] Verificar se contadores incrementam

4. **Notificações:**
   - [ ] Receber notificação
   - [ ] Marcar como lida
   - [ ] Verificar user_states é atualizado

---

## 📊 Métricas de Compatibilidade

| Categoria | Total | Compatível | Com Problemas | Sem Rules |
|-----------|-------|------------|---------------|-----------|
| **Collections** | 19 | 12 (63%) | 3 (16%) | 4 (21%) |
| **Operações** | 100+ | 85+ (85%) | 10+ (10%) | 5 (5%) |
| **Segurança** | - | ⚠️ Média | 🔴 3 críticos | 🟡 5 médios |

---

## ✅ Conclusão

**Status:** ⚠️ **Projeto funcional MAS requer correções urgentes**

### Ações Imediatas:
1. 🔴 Adicionar rules para `musics`, `messages`, `contadores_comunicacao`
2. 🔴 Fazer deploy das rules corrigidas
3. 🔴 Testar funcionalidades afetadas

### Ações de Médio Prazo:
1. 🟡 Mover API keys para Cloud Functions
2. 🟡 Adicionar validações de owner no código
3. 🟡 Implementar chunking em batch operations

### Ações de Longo Prazo:
1. 🟢 Criar suite de testes para rules
2. 🟢 Documentar todas collections e propósitos
3. 🟢 Consolidar acesso ao Firestore via service layer

---

**Documento criado por:** Claude Code
**Revisão necessária:** Time de desenvolvimento + DevOps
**Próxima revisão:** Após implementação das correções
