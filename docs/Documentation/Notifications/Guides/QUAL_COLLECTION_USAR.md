# 🔍 Qual Collection de Notificações Usar?

## 📋 Resumo Rápido

Existem **QUATRO collections** de notificações no sistema:

| Collection | Uso | Sistema | Campo Chave |
|-----------|-----|---------|------------|
| `ead_push_notifications` | ✅ Push EAD | Notificações push do módulo EAD | `destinatarioId` = UID do usuário |
| `global_push_notifications` | ✅ Push Global | Notificações push gerais | `recipientsRef` = array de refs |
| `in_app_notifications` | ✅ In-App | Notificações internas (Tickets/Discussões) | `destinatarioId` = UID do usuário |
| `ead_whatsapp_messages` | ✅ WhatsApp | Mensagens WhatsApp EAD | Múltiplos destinatários |

> **📝 Nota:** As collections foram renomeadas em Dezembro/2024:
> - `notificacoes_ead` → `ead_push_notifications`
> - `notifications` → `global_push_notifications`
> - `notificacoes` → `in_app_notifications`

## ✅ Para Notificações In-App (Tickets/Discussões): Use `in_app_notifications`

### Estrutura Correta do Documento

```javascript
// Collection: in_app_notifications
{
  // ⚠️ CAMPOS OBRIGATÓRIOS
  titulo: "Título da notificação",
  corpo: "Texto descritivo",
  tipo: "ticket_resposta",  // ou outro tipo válido (veja lista abaixo)
  destinatarioId: "abc123xyz",  // ⚠️ UID do usuário (Firebase Auth)
  dataCriacao: Timestamp,
  lida: false,

  // 📎 CAMPOS OPCIONAIS (úteis)
  dados: {
    // Dados extras para navegação
    ticketId: "ticket_123",
    ticketNumero: 123,
    mensagemId: "msg_456"
  }
}
```

### 🎯 Tipos de Notificação Válidos

**Tickets:**
- `ticket_resposta` - Nova resposta em um ticket
- `ticket_resolvido` - Ticket marcado como resolvido
- `ticket_reaberto` - Ticket reaberto

**Discussões (EAD):**
- `discussao_resposta` - Nova resposta em discussão
- `discussao_melhor_resposta` - Resposta marcada como melhor
- `discussao_solucao` - Resposta marcada como solução
- `discussao_like` - Alguém curtiu uma resposta

## 📊 Outras Collections de Notificações

### `global_push_notifications` (Push Notifications Globais)

Para notificações push gerais do app:

```javascript
// Collection: global_push_notifications
{
  title: "Nova meditação disponível",
  content: "Confira a nova meditação...",
  imagemUrl: "https://...",
  dataEnvio: Timestamp,
  status: "Enviada",
  typeRecipients: "Todos",  // ou "Específicos"
  recipientsRef: [],  // Array de DocumentReferences se específicos
  usuariosIds: [],
  usuariosEmails: []
}
```

**Características:**
- ✅ Notificações push globais via Firebase Cloud Messaging
- ✅ Suporta envio para todos os usuários ou específicos
- ✅ Suporta user_states para controle individual de leitura
- ✅ Campos em inglês (legado)

### `ead_push_notifications` (Push Notifications EAD)

Para notificações push específicas do módulo EAD:

```javascript
// Collection: ead_push_notifications
{
  titulo: "Nova aula disponível",
  mensagem: "Curso X liberou nova aula",
  destinatarioTipo: "Todos",  // "Curso", "Grupo", "Todos", "Individual"

  // Para notificações individuais
  destinatarioId: "user_uid",

  // Para notificações de grupo (IMPORTANTE!)
  destinatariosIds: ["uid1", "uid2", "uid3"],         // Array de UIDs
  destinatariosEmails: ["email1@..", "email2@.."],    // Array de emails

  // Contexto
  cursoId: "curso_123",
  grupoId: "grupo_456",

  status: "Pendente",
  dataAgendamento: Timestamp,
  dataCriacao: Timestamp
}
```

**Características:**
- ✅ Notificações push específicas do EAD
- ✅ Segmentação por curso ou grupo
- ✅ **Suporta notificações de grupo via arrays**
- ✅ Suporta agendamento
- ✅ Campos em português

> **📝 Para notificações de grupo:** Consulte [NOTIFICACOES_GRUPO.md](NOTIFICACOES_GRUPO.md)

## 🎯 Quando Usar Cada Collection?

### Use `in_app_notifications` quando:
- ✅ Notificação relacionada a ticket ou discussão
- ✅ Notificação interna do app (não push)
- ✅ Notificação para usuário específico

### Use `global_push_notifications` quando:
- ✅ Push notification geral para todos os usuários
- ✅ Avisos importantes do app
- ✅ Notificações de novas funcionalidades

### Use `ead_push_notifications` quando:
- ✅ Push notification relacionada a cursos EAD
- ✅ Avisos para alunos de curso específico
- ✅ Notificações de grupo de alunos

### Use `ead_whatsapp_messages` quando:
- ✅ Mensagem WhatsApp para alunos
- ✅ Comunicação via WhatsApp Business

## 🔄 Como Verificar no Firebase Console

1. Abra Firebase Console
2. Vá em Firestore Database
3. Verifique as collections:
   - `in_app_notifications` - Notificações internas
   - `global_push_notifications` - Push globais
   - `ead_push_notifications` - Push EAD
   - `ead_whatsapp_messages` - WhatsApp

## 🛠️ Exemplo de Criação

### Criar Notificação In-App (Tickets/Discussões):

```javascript
// Collection: in_app_notifications
await admin.firestore()
  .collection('in_app_notifications')
  .add({
    titulo: "Nova resposta no ticket",
    corpo: "Admin respondeu seu ticket #123",
    tipo: "ticket_resposta",
    destinatarioId: userId,  // UID do usuário
    dados: {
      ticketId: "ticket_123",
      ticketNumero: 123,
      mensagemId: "msg_456"
    },
    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    lida: false
  });
```

## 📊 Campos Importantes

### destinatarioId (CRÍTICO!)

Este é o campo mais importante. Deve ser o UID do Firebase Auth do usuário:

```javascript
// ✅ CORRETO - Usando UID do Firebase Auth
destinatarioId: "xYz123AbC456"  // Do Firebase Authentication

// ❌ ERRADO - Usando email ou outro identificador
destinatarioId: "user@example.com"  // Não funciona!
```

**Como obter o UID correto:**
- Do Firebase Authentication
- Geralmente fornecido pelo sistema que cria a notificação
- Formato: string alfanumérica única

### tipo (Importante para comportamento)

O tipo define como a notificação aparece e se comporta:
- 🎨 Ícone e cor
- 🔗 Navegação quando clicada
- 📱 Comportamento no app

```javascript
tipo: "ticket_resposta"  // ✅ Use valores da lista acima
tipo: "custom_type"      // ❌ Pode não funcionar corretamente
```

## 💡 Recomendações

### Para Notificações In-App (Tickets/Discussões):
1. ✅ Usar `in_app_notifications`
2. ✅ Incluir `destinatarioId` com UID do Firebase Auth
3. ✅ Usar `dataCriacao` com serverTimestamp
4. ✅ Usar tipos válidos da lista
5. ✅ Incluir `dados` com informações de contexto

### Para Push Notifications Globais:
1. ✅ Usar `global_push_notifications`
2. ✅ Definir `typeRecipients` ("Todos" ou "Específicos")
3. ✅ Incluir user_states para controle individual

### Para Push Notifications EAD:
1. ✅ Usar `ead_push_notifications`
2. ✅ Definir `destinatarioTipo` (Todos/Curso/Grupo)
3. ✅ Incluir IDs de curso/grupo quando aplicável

---

**📌 Para mais detalhes sobre cada collection, consulte o arquivo [COLLECTIONS_NOTIFICACOES.md](../../medita-bk-web-admin/docs/01-notificacoes/COLLECTIONS_NOTIFICACOES.md) no projeto web admin.**

