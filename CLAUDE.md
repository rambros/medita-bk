# CLAUDE.md — MeditaBK (App Mobile)

Instruções obrigatórias para agentes de IA trabalhando neste projeto.

---

## Projeto

- **Nome:** MeditaBK (app mobile Flutter — iOS/Android)
- **Firebase Project ID:** `meditabk2020`
- **Admin panel relacionado:** `../medita-bk-web-admin`
- **Arquitetura:** Flutter + Firebase (Firestore, Storage, Auth, Functions) + MVVM

> ⚠️ **Este app e o admin panel (`medita-bk-web-admin`) compartilham o mesmo Firebase (`meditabk2020`).
> Qualquer mudança nas Firestore Rules impacta os dois projetos.**

---

## REGRA OBRIGATÓRIA — Nova Collection no Firestore

> Toda vez que criar ou usar uma nova collection no Firestore, **é obrigatório** adicionar a regra correspondente em `firebase/firestore.rules` **nos dois projetos** e fazer deploy.

### Passos obrigatórios:

1. Adicionar o bloco `match` em `firebase/firestore.rules` deste projeto
2. **Copiar o arquivo atualizado para o admin panel:**
   ```bash
   cp firebase/firestore.rules ../medita-bk-web-admin/firebase/firestore.rules
   ```
3. Fazer deploy:
   ```bash
   firebase deploy --only firestore:rules --project meditabk2020
   ```

### Referência completa de regras:
→ [`docs/FIRESTORE_RULES.md`](docs/FIRESTORE_RULES.md)

### Padrões rápidos:

```javascript
// Conteúdo público autenticado (leitura mobile + escrita admin panel)
match /nome_collection/{docId} {
  allow read: if isAuth();
  allow write: if isEditorOrAbove();
}

// Dados do próprio usuário
match /nome_collection/{docId} {
  allow read, write: if isOwner(docId);
}

// Usuário cria/lê os próprios; admin gerencia todos
match /nome_collection/{docId} {
  allow read: if isAuth() && (
    resource.data.usuarioId == request.auth.uid || isEditorOrAbove()
  );
  allow create: if isAuth() && request.resource.data.usuarioId == request.auth.uid;
  allow update: if isAuth() && (resource.data.usuarioId == request.auth.uid || isEditorOrAbove());
  allow delete: if isAdmin();
}

// Exclusivo admin panel
match /nome_collection/{docId} {
  allow read, write: if isAdmin();
}
```

### Funções auxiliares já definidas nas rules:
- `isAuth()` — autenticado
- `isOwner(userId)` — UID == documento
- `isAdmin()` — role `Admin` no array `userRole`
- `isEditorOrAbove()` — roles `Admin`, `Editor`, `Tester`, `Autor`

> **Nunca use** `data.role` — o campo correto é `userRole` (array).

---

## Estrutura do Projeto

```
lib/
├── data/
│   ├── models/          # Modelos de dados
│   ├── repositories/    # Acesso ao Firestore
│   └── services/        # Firebase Auth, Storage, Functions
├── domain/
│   └── models/          # Enums, entidades de domínio
├── ui/
│   └── [módulo]/
│       ├── [feature]_page.dart
│       ├── view_model/
│       └── widgets/
└── utils/
    └── auth/
        └── auth_util.dart
firebase/
├── firestore.rules       # Regras do Firestore (SEMPRE manter igual ao admin panel)
├── firestore.indexes.json
└── functions/
docs/
└── FIRESTORE_RULES.md    # Referência completa de regras e collections
```

---

## Roles e Permissões

Roles armazenadas como array no campo `userRole` do documento `users/{uid}`:

| Role | Acesso no app mobile |
|---|---|
| `Admin` | Tudo + funções de teste |
| `Editor` | Funções de editor |
| `Tester` | Funcionalidades em teste (feature flags) |
| `Autor` | Conteúdo autoral |
| `User` | Acesso padrão |

Verificação de `Tester` no app: `user.userRole.any((r) => r.toLowerCase() == 'tester')`
