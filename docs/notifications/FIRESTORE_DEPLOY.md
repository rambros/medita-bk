# Guia de Deploy - Firestore Rules e Índices

**Data:** 2025-12-11
**Objetivo:** Deploy das regras de segurança e índices do Firestore para o sistema de notificações unificado

---

## 📋 Pré-requisitos

1. **Firebase CLI instalado:**
   ```bash
   npm install -g firebase-tools
   ```

2. **Login no Firebase:**
   ```bash
   firebase login
   ```

3. **Inicializar projeto (se ainda não foi feito):**
   ```bash
   cd /Users/rodrigoambros/Documents/Desenv/0.Clientes/Agencia/ProjGW/codigo/medita-bk
   firebase init
   ```

   Selecionar:
   - ✅ Firestore
   - Usar arquivos existentes: `firestore.rules` e `firestore.indexes.json`

---

## 🚀 Deploy

### Opção 1: Deploy Completo (Rules + Indexes)

```bash
firebase deploy --only firestore
```

### Opção 2: Deploy Apenas Rules

```bash
firebase deploy --only firestore:rules
```

### Opção 3: Deploy Apenas Indexes

```bash
firebase deploy --only firestore:indexes
```

---

## 📝 Arquivos Criados

### 1. `firestore.rules`

Regras de segurança que incluem:

✅ **Collection `notifications` (nova):**
- Leitura: usuários que estão em `destinatarios` ou quando é "TODOS"
- Escrita: apenas admins
- Subcollection `user_states/{userId}`: cada usuário só acessa seu próprio estado

✅ **Collections antigas (mantidas temporariamente):**
- `in_app_notifications`
- `ead_push_notifications`
- `global_push_notifications`
- `user_states`

✅ **Outras collections:**
- `users`
- `cursos`
- `grupos`
- `tickets`

✅ **Helper function:**
- `hasAdminRole()` - verifica se usuário é admin através do campo `users/{uid}.role`

### 2. `firestore.indexes.json`

Índices compostos para otimizar queries:

✅ **Índice 1:** `notifications` → `destinatarios` (array) + `dataCriacao` (desc)
- Para query principal: buscar notificações do usuário ordenadas por data

✅ **Índice 2:** `notifications` → `categoria` (asc) + `dataCriacao` (desc)
- Para filtrar por categoria (ticket, discussao, curso, sistema)

✅ **Índice 3:** `notifications` → `destinatarios` (array) + `categoria` (asc) + `dataCriacao` (desc)
- Para filtrar notificações do usuário por categoria

✅ **Índice 4:** `notifications` → `status` (asc) + `dataCriacao` (desc)
- Para admin filtrar por status (enviada, agendada, rascunho)

---

## ✅ Verificação Pós-Deploy

### 1. Verificar Rules no Console

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Vá em **Firestore Database** > **Rules**
4. Verifique se as rules foram atualizadas

### 2. Verificar Índices no Console

1. No Firebase Console, vá em **Firestore Database** > **Indexes**
2. Verifique se os 4 índices foram criados:
   - `notifications` (destinatarios, dataCriacao)
   - `notifications` (categoria, dataCriacao)
   - `notifications` (destinatarios, categoria, dataCriacao)
   - `notifications` (status, dataCriacao)
3. Status deve estar como **Enabled** (pode levar alguns minutos)

### 3. Testar Queries

No mobile ou web admin, teste se as queries funcionam:

```dart
// Esta query deve funcionar sem erro
final snapshot = await FirebaseFirestore.instance
    .collection('notifications')
    .where('destinatarios', arrayContainsAny: [userId, 'TODOS'])
    .orderBy('dataCriacao', descending: true)
    .limit(20)
    .get();
```

Se a query falhar com erro **"missing index"**, o Firebase fornecerá um link para criar o índice automaticamente.

---

## 🔐 Segurança das Rules

### Testando Permissões

Você pode testar as rules no Firebase Console:

1. Vá em **Firestore Database** > **Rules**
2. Clique em **Rules Playground**
3. Teste cenários:

**Cenário 1: Usuário lendo suas notificações**
```
Location: /notifications/notif123
Read
Authenticated: Yes
UID: user123

Documento simulado:
{
  "titulo": "Teste",
  "destinatarios": ["user123"],
  ...
}

Resultado esperado: ✅ Allow
```

**Cenário 2: Usuário lendo notificação de outro**
```
Location: /notifications/notif123
Read
Authenticated: Yes
UID: user123

Documento simulado:
{
  "titulo": "Teste",
  "destinatarios": ["user456"],
  ...
}

Resultado esperado: ❌ Deny
```

**Cenário 3: Usuário lendo notificação para TODOS**
```
Location: /notifications/notif123
Read
Authenticated: Yes
UID: user123

Documento simulado:
{
  "titulo": "Teste",
  "destinatarios": ["TODOS"],
  ...
}

Resultado esperado: ✅ Allow
```

**Cenário 4: Usuário tentando criar notificação (sem ser admin)**
```
Location: /notifications/notif123
Write
Authenticated: Yes
UID: user123

users/user123:
{
  "role": "user"
}

Resultado esperado: ❌ Deny
```

**Cenário 5: Admin criando notificação**
```
Location: /notifications/notif123
Write
Authenticated: Yes
UID: admin123

users/admin123:
{
  "role": "admin"
}

Resultado esperado: ✅ Allow
```

---

## 🗑️ Após Migração Completa

Quando a migração estiver 100% completa e testada, você pode **remover as rules das collections antigas** do arquivo `firestore.rules`:

```javascript
// REMOVER após migração:
match /in_app_notifications/{notifId} { ... }
match /ead_push_notifications/{notifId} { ... }
match /global_push_notifications/{notifId} { ... }
```

E fazer novo deploy:
```bash
firebase deploy --only firestore:rules
```

---

## 🔄 Rollback

Se precisar reverter as rules:

### Opção 1: Via Console

1. Firebase Console > Firestore Database > Rules
2. Clique em **History**
3. Selecione versão anterior
4. Clique em **Restore**

### Opção 2: Via CLI

1. Reverter arquivo `firestore.rules` para versão anterior (git)
2. Deploy novamente:
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## 📊 Monitoramento

### Ver Uso de Índices

No Firebase Console:
1. **Firestore Database** > **Usage**
2. Verifique se os índices estão sendo utilizados
3. Monitore performance das queries

### Ver Violações de Rules

No Firebase Console:
1. **Firestore Database** > **Rules**
2. Clique em **View recent activity**
3. Verifique se há tentativas de acesso negado suspeitas

---

## ⚠️ Importante

1. **Backup:** As rules antigas são mantidas temporariamente para compatibilidade
2. **Índices:** Podem levar alguns minutos para serem criados (até 10-15 min)
3. **Testing:** Sempre teste as rules em ambiente de desenvolvimento primeiro
4. **Admin Role:** Certifique-se que os admins têm `role: 'admin'` no documento `users/{uid}`

---

## 📝 Checklist de Deploy

- [ ] Firebase CLI instalado e autenticado
- [ ] Arquivos `firestore.rules` e `firestore.indexes.json` criados
- [ ] Deploy realizado: `firebase deploy --only firestore`
- [ ] Verificado status dos índices no Console (Enabled)
- [ ] Testado query básica no mobile/web
- [ ] Testado permissões no Rules Playground
- [ ] Monitorar logs por 24h para verificar erros

---

**Criado por:** Claude Code
**Data:** 2025-12-11
**Status:** ✅ Pronto para deploy
