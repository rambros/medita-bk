# 🔍 Qual Collection de Notificações Usar?

## 📋 Resumo Rápido

Existem **DUAS collections** de notificações no sistema:

| Collection | Uso | Sistema | Campo Chave |
|-----------|-----|---------|------------|
| `notificacoes_ead` | ✅ **USAR ESTA** | Novo (EAD/Tickets/Discussões) | `destinatarioId` = UID do usuário |
| `notifications` | ⚠️ Legado | Antigo (Broadcast geral) | `recipientsRef` = array de refs |

## ✅ Para Módulo Admin: Use `notificacoes_ead`

### Estrutura Correta do Documento

```javascript
// Collection: notificacoes_ead
{
  // ⚠️ CAMPOS OBRIGATÓRIOS
  titulo: "Título da notificação",
  conteudo: "Texto descritivo",
  tipo: "ticket_respondido",  // ou outro tipo válido (veja lista abaixo)
  destinatarioId: "abc123xyz",  // ⚠️ UID do usuário (Firebase Auth)
  dataCriacao: Timestamp,
  lido: false,
  
  // 📎 CAMPOS OPCIONAIS (úteis)
  relatedType: "ticket",  // 'ticket', 'discussao', 'resposta'
  relatedId: "ticket_123",
  remetenteId: "admin_uid",
  remetenteNome: "Nome do Admin",
  dados: {
    // Dados extras para navegação
    ticketId: "ticket_123",
    ticketNumero: "001"
  }
}
```

### 🎯 Tipos de Notificação Válidos

**Tickets:**
- `ticket_criado`
- `ticket_respondido` ← Use este quando responder
- `ticket_resolvido`
- `ticket_fechado`

**Discussões:**
- `discussao_criada`
- `discussao_respondida`
- `discussao_resolvida`
- `resposta_curtida`
- `resposta_marcada_solucao`

## 🚫 NÃO Use `notifications` (Sistema Antigo)

A collection `notifications` é do sistema antigo e tem estrutura diferente:

```javascript
// ❌ NÃO USAR - Sistema Antigo
{
  title: "...",
  content: "...",
  dataEnvio: Timestamp,
  type: "Enviada",
  recipientsRef: [
    // Array de DocumentReferences
    /users/abc123,
    /users/xyz456
  ]
}
```

**Problemas do sistema antigo:**
- ❌ Usa `recipientsRef` (array de references)
- ❌ Não tem campo `lido` individual
- ❌ Campos em inglês
- ❌ Não integra com o novo sistema de badges

## 🔄 Como Verificar Qual Você Está Usando

### Opção 1: Debug Info no App

1. Abra o app
2. Vá para Notificações
3. Veja o card amarelo de DEBUG INFO no topo
4. Verifique qual collection tem notificações:
   - ✅ Se `notificacoes_ead` tem notificações → Está correto!
   - ⚠️ Se `notifications` tem mas `notificacoes_ead` está vazio → Admin está usando collection errada

### Opção 2: Firebase Console

1. Abra Firebase Console
2. Vá em Firestore Database
3. Procure as collections:
   - Tem documentos em `notificacoes_ead`? → ✅ Correto
   - Só tem em `notifications`? → ⚠️ Precisa mudar

## 🛠️ Como Migrar do Admin

Se o admin está salvando em `notifications`, precisa mudar para `notificacoes_ead`:

### Antes (❌ Errado):
```javascript
// Admin salvando em 'notifications'
await admin.firestore()
  .collection('notifications')  // ❌ Collection errada
  .add({
    title: "...",
    content: "...",
    // ...
  });
```

### Depois (✅ Correto):
```javascript
// Admin salvando em 'notificacoes_ead'
await admin.firestore()
  .collection('notificacoes_ead')  // ✅ Collection correta
  .add({
    titulo: "Nova resposta no ticket",
    conteudo: "Admin respondeu seu ticket",
    tipo: "ticket_respondido",
    destinatarioId: userId,  // UID do usuário
    relatedType: "ticket",
    relatedId: ticketId,
    remetenteId: adminId,
    remetenteNome: "Admin",
    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    lido: false
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
1. No app, vá em Notificações
2. Copie o "User ID" do debug info
3. Use esse valor exato no `destinatarioId`

### tipo (Importante para ícones e cores)

O tipo define como a notificação aparece:
- 🎨 Cor do ícone
- 📍 Ícone usado
- 🔗 Navegação quando clicada

```javascript
tipo: "ticket_respondido"  // ✅ Use valores da lista acima
tipo: "custom_type"        // ❌ Não vai ter ícone/cor corretos
```

## 🔧 Ferramenta de Diagnóstico

O app agora tem um debug info que mostra:
- Quantas notificações em cada collection
- Última notificação de cada tipo
- User ID para usar no admin
- Se o sistema está funcionando

## 💡 Recomendação Final

**Para o Módulo Admin:**
1. ✅ Sempre usar collection `notificacoes_ead`
2. ✅ Sempre incluir `destinatarioId` com UID correto
3. ✅ Sempre usar timestamp para `dataCriacao`
4. ✅ Sempre atualizar contador em `contadores_comunicacao`
5. ✅ Usar tipos válidos da lista

**Evitar:**
1. ❌ Não usar collection `notifications`
2. ❌ Não usar email em vez de UID
3. ❌ Não esquecer de atualizar contador
4. ❌ Não criar tipos customizados

---

**📌 Se tiver dúvidas, consulte o debug info no app para verificar o que está acontecendo!**

