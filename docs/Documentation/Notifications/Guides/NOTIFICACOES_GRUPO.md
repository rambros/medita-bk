# 👥 Notificações de Grupo - EAD Push Notifications

## 📋 Visão Geral

As notificações `ead_push_notifications` podem ser enviadas para **grupos** de usuários. Para que os usuários do app mobile recebam essas notificações, o web admin deve incluir arrays com os IDs ou emails dos destinatários.

## 🎯 Como Funciona

### 1. Estrutura da Notificação de Grupo

```javascript
// Collection: ead_push_notifications
{
  titulo: "Nova aula disponível",
  mensagem: "O Curso X liberou uma nova aula",
  tipo: "notificacao_geral",

  // Tipo de destinatário
  destinatarioTipo: "Grupo",  // ou "Curso", "Todos"

  // ID do grupo/curso
  grupoId: "grupo_123",
  cursoId: "curso_456",

  // ⚠️ IMPORTANTE: Arrays de destinatários
  destinatariosIds: [         // Array de UIDs do Firebase Auth
    "uid_user1",
    "uid_user2",
    "uid_user3"
  ],

  destinatariosEmails: [      // Array de emails dos usuários
    "user1@example.com",
    "user2@example.com",
    "user3@example.com"
  ],

  dataCriacao: Timestamp,
  status: "Enviada"
}
```

### 2. Queries que o App Mobile Faz

O app mobile busca notificações de 4 formas diferentes:

```dart
// 1. Notificação individual (destinatarioId = UID do usuário)
.where('destinatarioId', isEqualTo: userId)

// 2. Notificação para todos (destinatarioTipo = 'Todos')
.where('destinatarioTipo', isEqualTo: 'Todos')

// 3. Notificação de grupo por UID (destinatariosIds contém UID do usuário)
.where('destinatariosIds', arrayContains: userId)

// 4. Notificação de grupo por email (destinatariosEmails contém email do usuário)
.where('destinatariosEmails', arrayContains: userEmail)
```

## 📊 Campos Importantes

### destinatariosIds (Array de UIDs)

**Recomendado**: Use sempre que possível, pois UID é único e permanente.

```javascript
destinatariosIds: [
  "abc123xyz",  // UID do Firebase Auth
  "def456uvw",
  "ghi789rst"
]
```

**Como obter os UIDs:**
- No web admin, ao selecionar um grupo, busque os membros do grupo
- Para cada membro, pegue o campo `uid` do documento na collection `users`

### destinatariosEmails (Array de Emails)

**Fallback**: Use quando não tiver acesso aos UIDs.

```javascript
destinatariosEmails: [
  "usuario1@gmail.com",
  "usuario2@yahoo.com",
  "usuario3@hotmail.com"
]
```

**Vantagens:**
- ✅ Mais fácil de obter (geralmente visível no admin)
- ✅ Funciona mesmo se UID mudar (raro)

**Desvantagens:**
- ❌ Usuário pode mudar email
- ❌ Requer query adicional no app para buscar email

## 🛠️ Implementação no Web Admin

### Ao criar notificação de grupo:

```javascript
// 1. Buscar membros do grupo
const grupoDoc = await admin.firestore()
  .collection('grupos')
  .doc(grupoId)
  .get();

const membrosIds = grupoDoc.data().membrosIds; // Array de UIDs

// 2. Buscar emails dos membros (opcional)
const membrosEmails = [];
for (const userId of membrosIds) {
  const userDoc = await admin.firestore()
    .collection('users')
    .doc(userId)
    .get();

  if (userDoc.exists && userDoc.data().email) {
    membrosEmails.push(userDoc.data().email);
  }
}

// 3. Criar notificação com arrays
await admin.firestore()
  .collection('ead_push_notifications')
  .add({
    titulo: "Nova aula",
    mensagem: "Conteúdo disponível",
    tipo: "notificacao_geral",
    destinatarioTipo: "Grupo",
    grupoId: grupoId,

    // ⚠️ IMPORTANTE: Incluir arrays
    destinatariosIds: membrosIds,
    destinatariosEmails: membrosEmails,

    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    status: "Enviada"
  });
```

## 🔍 Debug no App Mobile

O widget de debug mostra quantas notificações foram encontradas por cada query:

```
📊 Collection: ead_push_notifications
Total de documentos: 10
Por destinatarioId=userId: 2
Por destinatarioTipo=Todos: 3
Por destinatariosIds (grupo): 4      ← Notificações de grupo por UID
Por destinatariosEmails (grupo): 1   ← Notificações de grupo por email
```

## ✅ Checklist para Notificações de Grupo

### Web Admin:
- [ ] Ao selecionar grupo, buscar membros do grupo
- [ ] Obter array de UIDs dos membros
- [ ] (Opcional) Obter array de emails dos membros
- [ ] Incluir `destinatariosIds` na notificação
- [ ] (Opcional) Incluir `destinatariosEmails` na notificação
- [ ] Definir `destinatarioTipo` = "Grupo"
- [ ] Incluir `grupoId` ou `cursoId`

### App Mobile:
- [x] Buscar por `destinatariosIds` (arrayContains)
- [x] Buscar por `destinatariosEmails` (arrayContains)
- [x] Processar user_states para cada notificação
- [x] Filtrar notificações ocultadas
- [x] Unificar com outras collections

## 🎨 Exemplo Completo

### Web Admin cria notificação:

```javascript
{
  titulo: "Nova aula: Introdução ao Flutter",
  mensagem: "A primeira aula do curso está disponível!",
  tipo: "notificacao_curso",
  destinatarioTipo: "Grupo",
  grupoId: "turma_2024_flutter",
  cursoId: "curso_flutter_basico",

  // Arrays de destinatários
  destinatariosIds: [
    "user_123_abc",
    "user_456_def",
    "user_789_ghi"
  ],

  destinatariosEmails: [
    "aluno1@gmail.com",
    "aluno2@yahoo.com",
    "aluno3@hotmail.com"
  ],

  dataCriacao: serverTimestamp(),
  status: "Enviada"
}
```

### App Mobile recebe notificação:

1. **aluno1@gmail.com** (UID: user_123_abc)
   - ✅ Encontrada via `destinatariosIds` (arrayContains user_123_abc)
   - ✅ Encontrada via `destinatariosEmails` (arrayContains aluno1@gmail.com)
   - Sistema remove duplicata e mostra apenas 1 vez

2. **aluno2@yahoo.com** (UID: user_456_def)
   - ✅ Encontrada via `destinatariosIds` (arrayContains user_456_def)
   - ✅ Encontrada via `destinatariosEmails` (arrayContains aluno2@yahoo.com)
   - Sistema remove duplicata e mostra apenas 1 vez

## 🚨 Importante

### Índices Compostos Necessários

O Firestore pode exigir índices compostos para as queries:

**Collection:** `ead_push_notifications`

**Índice 1:**
- `destinatariosIds` (Arrays)
- `dataCriacao` (Descending)

**Índice 2:**
- `destinatariosEmails` (Arrays)
- `dataCriacao` (Descending)

**Como criar:**
- Firebase Console vai sugerir criar automaticamente quando executar a query pela primeira vez
- Ou criar manualmente em: Firestore Database → Indexes

## 📞 Troubleshooting

### Notificação de grupo não aparece no app:

1. **Verificar arrays no Firestore:**
   - Abrir documento da notificação
   - Verificar se `destinatariosIds` ou `destinatariosEmails` existem
   - Verificar se contém UID ou email do usuário

2. **Verificar debug info no app:**
   - Ver quantas notificações foram encontradas por cada query
   - Se "Por destinatariosIds (grupo): 0", significa que:
     - Array não existe, ou
     - UID do usuário não está no array, ou
     - Índice composto faltando

3. **Verificar índice composto:**
   - Se aparecer erro "requires an index", criar índice sugerido

4. **Verificar user_states:**
   - Notificação pode estar ocultada (`ocultado: true`)
   - Verificar subcollection `user_states/{userId}`

---

**💡 Dica**: Sempre inclua tanto `destinatariosIds` quanto `destinatariosEmails` para máxima compatibilidade!
