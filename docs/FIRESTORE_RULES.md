# Firestore Security Rules — MeditaBK

**Projeto Firebase:** `meditabk2020`
**Arquivo de regras (este projeto):** `firebase/firestore.rules`
**Arquivo de regras (admin panel):** `../medita-bk-web-admin/firebase/firestore.rules`

> ⚠️ **Os dois projetos compartilham o mesmo Firebase (`meditabk2020`).
> Os arquivos `firestore.rules` devem ser sempre idênticos entre os dois projetos.**

**Deploy:** `cd firebase && firebase deploy --only firestore:rules --project meditabk2020`

---

## Obrigatoriedade ao criar nova collection

> **REGRA DE OURO:** Toda nova collection criada no Firestore **precisa ter uma regra correspondente** em `firebase/firestore.rules`. Sem regra explícita, o Firestore nega todo acesso por padrão — leitura e escrita.

### Checklist para nova collection

- [ ] Identificar quem acessa: app mobile, admin panel, ou ambos
- [ ] Definir o nível de permissão (ver tabela abaixo)
- [ ] Adicionar o bloco `match` em `firebase/firestore.rules` **nos dois projetos** (medita-bk e medita-bk-web-admin)
- [ ] Se houver subcoleção, adicionar regra separada aninhada
- [ ] Fazer deploy: `firebase deploy --only firestore:rules --project meditabk2020`
- [ ] Verificar no Firebase Console que o ruleset foi atualizado

---

## Funções auxiliares disponíveis

Definidas no topo de `firebase/firestore.rules`:

| Função | Descrição |
|---|---|
| `isAuth()` | Usuário autenticado |
| `isOwner(userId)` | UID do usuário == documento |
| `isAdmin()` | Role `Admin` ou `admin` no array `userRole` |
| `isEditorOrAbove()` | Roles: `Admin`, `Editor`, `Tester`, `Autor` (maiúsculo ou minúsculo) |
| `fieldUnchanged(field)` | Impede alteração de um campo específico no update |

> **Importante:** Roles são armazenadas como **array** no campo `userRole` do documento do usuário (ex.: `['Admin', 'Editor']`). Nunca usar `data.role` (campo não existe).

---

## Padrões de regra por tipo de collection

### 1. Conteúdo público (somente leitura pelo app)
```javascript
match /nome_collection/{docId} {
  allow read: if isAuth();
  allow write: if isEditorOrAbove(); // ou isAdmin()
}
```
Uso: `meditations`, `cursos`, `category`, `settings`

---

### 2. Dados do próprio usuário
```javascript
match /nome_collection/{docId} {
  allow read, write: if isOwner(docId);
}
```
Uso: `user_states`, `contadores_comunicacao`

---

### 3. Usuário cria/lê os próprios; admin gerencia todos
```javascript
match /nome_collection/{docId} {
  allow read: if isAuth() && (
    resource.data.usuarioId == request.auth.uid || isEditorOrAbove()
  );
  allow create: if isAuth() &&
    request.resource.data.usuarioId == request.auth.uid;
  allow update: if isAuth() && (
    resource.data.usuarioId == request.auth.uid || isEditorOrAbove()
  );
  allow delete: if isAdmin();
}
```
Uso: `tickets`, `inscricoes_cursos`, `avaliacoes_cursos`

---

### 4. Exclusivo admin panel
```javascript
match /nome_collection/{docId} {
  allow read, write: if isAdmin();
}
```
Uso: `email_tags`, `email_templates`, `emails_ead`, `whatsapp_ead`

---

### 5. Collection com subcoleção
```javascript
match /nome_collection/{docId} {
  allow read: if isAuth();
  allow write: if isEditorOrAbove();

  match /subcollection/{subDocId} {
    allow read: if isAuth();
    allow write: if isAuth();
  }
}
```
Uso: `cursos/aulas`, `tickets/mensagens`, `notifications/user_states`

---

## Mapa completo de collections e regras

| Collection | Leitura | Escrita | Quem usa |
|---|---|---|---|
| `users` | `isAuth()` | dono (sem alterar userRole) ou admin | ambos |
| `users/{id}/fcm_tokens` | dono ou admin | dono | mobile |
| `meditations` | `isAuth()` | `isEditorOrAbove()` + update parcial mobile | ambos |
| `meditations_draft` | `isEditorOrAbove()` | `isEditorOrAbove()` | admin |
| `category` | `isAuth()` | `isEditorOrAbove()` | ambos |
| `musics` | `isAuth()` | `isAdmin()` | admin |
| `musicas` | `isAuth()` | `isAdmin()` | mobile |
| `traffic_control_musics` | `isAuth()` | `isAdmin()` | admin |
| `cursos` | `isAuth()` | `isEditorOrAbove()` | ambos |
| `cursos/{id}/aulas` | `isAuth()` | `isEditorOrAbove()` | ambos |
| `cursos/{id}/aulas/{id}/topicos` | `isAuth()` | `isEditorOrAbove()` | ambos |
| `inscricoes_cursos` | dono ou editor+ | dono (create), dono/editor+ (update) | mobile |
| `avaliacoes_cursos` | dono ou editor+ | dono (create/update) | mobile |
| `grupos` | `isAuth()` | `isAdmin()` | admin |
| `grupos_ead` | `isEditorOrAbove()` | `isAdmin()` | admin |
| `tickets` | dono ou editor+ | dono (create), dono/editor+ (update) | ambos |
| `tickets/{id}/mensagens` | dono do ticket ou editor+ | `isAuth()` (create) | ambos |
| `contadores_comunicacao` | dono ou editor+ | dono ou editor+ | mobile |
| `discussoes` | `isAuth()` | `isAuth()` (create), dono/editor+ (update/delete) | mobile |
| `discussoes/{id}/respostas` | `isAuth()` | `isAuth()` (create), dono/editor+ (update/delete) | mobile |
| `notifications` | destinatário ou editor+ | `isEditorOrAbove()` | ambos |
| `notifications/{id}/user_states` | dono ou editor+ | dono ou editor+ | mobile |
| `notificacoes_ead` | próprio usuário ou editor+ | `isEditorOrAbove()` | mobile |
| `ff_push_notifications` | `isAdmin()` | `isAdmin()` | admin |
| `ff_user_push_notifications` | `false` | remetente autenticado | mobile |
| `email_tags` | `isAdmin()` | `isAdmin()` | admin |
| `email_templates` | `isAdmin()` | `isAdmin()` | admin |
| `emails_ead` | `isAdmin()` | `isAdmin()` | admin |
| `whatsapp_ead` | `isAdmin()` | `isAdmin()` | admin |
| `whatsapp_notifications_log` | `isAdmin()` | `isAdmin()` | admin |
| `ead_whatsapp_messages` | `isAdmin()` | `isAdmin()` | admin |
| `settings` | `isAuth()` | `isAdmin()` | ambos |
| `desafio21` | `isAuth()` | `isAdmin()` | mobile |
| `messages` | `isAuth()` | `isAdmin()` | mobile |
| `item_count` | `isAuth()` | `isAdmin()` | admin |
| `user_states` | dono | dono | mobile |
| `in_app_notifications` | próprio usuário ou editor+ | `isEditorOrAbove()` | mobile |
| `_rowy_` | custom claims | `isAdmin()` | interno |

---

## Como manter os dois projetos sincronizados

Como os dois projetos compartilham o mesmo Firebase, **o arquivo `firestore.rules` deve ser sempre igual nos dois**.

Fluxo recomendado ao alterar as regras:

1. Editar `firebase/firestore.rules` no projeto **medita-bk-web-admin** (fonte de verdade)
2. Copiar o arquivo para **medita-bk**:
   ```bash
   cp ../medita-bk-web-admin/firebase/firestore.rules ./firebase/firestore.rules
   ```
3. Fazer deploy a partir de qualquer um dos projetos:
   ```bash
   firebase deploy --only firestore:rules --project meditabk2020
   ```
4. Atualizar a tabela de collections neste documento e no admin panel (`docs/06-infrastructure/FIRESTORE_RULES.md`)

---

## Problema histórico (resolvido em 29/03/2026)

As regras anteriores usavam `data.role == 'admin'` para verificar permissão de admin. O campo correto é `userRole` (array). Isso fazia todos os `allow write: if isAdmin()` retornarem `false` silenciosamente. Corrigido para `data.userRole.hasAny(['Admin', 'admin'])`.
