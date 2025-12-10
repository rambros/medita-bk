# Como Criar Notificação de Teste

## 🧪 Opção 1: Via Firebase Console (Mais Fácil)

### Passo 1: Obter seu User ID

1. Abra o app
2. Vá para **Notificações**
3. Copie o **User ID** mostrado no card de debug no topo da página

### Passo 2: Criar Notificação no Firestore

1. Abra [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto: **meditabk2020**
3. Vá em **Firestore Database**
4. Clique em **Start collection** (ou selecione a collection existente)
5. Collection ID: `notificacoes_ead`
6. Clique em **Add document**
7. Deixe o **Document ID** em branco (auto-gerado)

### Passo 3: Adicionar Campos

Adicione estes campos **exatamente** como mostrado:

| Campo | Tipo | Valor |
|-------|------|-------|
| `titulo` | string | Teste de Notificação |
| `conteudo` | string | Esta é uma notificação de teste enviada manualmente |
| `tipo` | string | ticket_criado |
| `destinatarioId` | string | **[COLE SEU USER ID AQUI]** |
| `dataCriacao` | timestamp | [Clique no relógio e selecione "Now"] |
| `lido` | boolean | false |
| `relatedType` | string | ticket |
| `relatedId` | string | test123 |

### Passo 4: Salvar

1. Clique em **Save**
2. Volte para o app
3. Puxe para baixo (pull to refresh) na página de notificações
4. A notificação deve aparecer!

## 🔥 Opção 2: Via Cloud Functions (Terminal)

Se você tem acesso ao projeto Firebase Admin:

```javascript
// No Firebase Functions ou script admin
const admin = require('firebase-admin');

// Substitua com o UID real do usuário
const userId = 'SEU_USER_ID_AQUI';

await admin.firestore()
  .collection('notificacoes_ead')
  .add({
    titulo: 'Notificação de Teste',
    conteudo: 'Esta é uma notificação criada via script',
    tipo: 'ticket_criado',
    destinatarioId: userId,
    relatedType: 'ticket',
    relatedId: 'test456',
    remetenteId: 'admin',
    remetenteNome: 'Sistema',
    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    lido: false,
    dados: {
      teste: true
    }
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

console.log('Notificação criada com sucesso!');
```

## 📱 Opção 3: Via Postman/REST API

Se você tem a API Key do Firebase:

```bash
curl -X POST \
  'https://firestore.googleapis.com/v1/projects/meditabk2020/databases/(default)/documents/notificacoes_ead' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "fields": {
      "titulo": {"stringValue": "Teste via API"},
      "conteudo": {"stringValue": "Notificação criada via REST API"},
      "tipo": {"stringValue": "ticket_criado"},
      "destinatarioId": {"stringValue": "SEU_USER_ID"},
      "dataCriacao": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"},
      "lido": {"booleanValue": false}
    }
  }'
```

## ✅ Verificar se Funcionou

1. **No App:**
   - Abra a página de notificações
   - Puxe para baixo (refresh)
   - Deve aparecer a notificação
   - Badge vermelho deve aparecer no ícone

2. **No Debug Info:**
   - Total de notificações deve aumentar
   - Contador não lidas deve aumentar
   - Última notificação deve mostrar seus dados

3. **No Badge do App:**
   - Ícone no topo da tela inicial deve mostrar badge vermelho
   - Número deve corresponder às não lidas

## 🔍 Se Não Aparecer

1. **Verificar User ID está correto** (copie exatamente do debug info)
2. **Verificar Collection está como** `notificacoes_ead` (não `notificacoes`)
3. **Verificar campo** `destinatarioId` **está escrito corretamente**
4. **Criar índice composto** no Firestore (se solicitado)
5. **Verificar regras** do Firestore permitem leitura

## 📊 Tipos de Notificação Válidos

Use um destes valores para o campo `tipo`:

**Tickets:**
- `ticket_criado`
- `ticket_respondido`
- `ticket_resolvido`
- `ticket_fechado`

**Discussões:**
- `discussao_criada`
- `discussao_respondida`
- `discussao_resolvida`
- `resposta_curtida`
- `resposta_marcada_solucao`

## 🎨 Exemplo Completo (JSON)

```json
{
  "titulo": "🎉 Teste de Notificação",
  "conteudo": "Se você está vendo isso, o sistema funciona!",
  "tipo": "ticket_respondido",
  "destinatarioId": "abc123xyz456",
  "relatedType": "ticket",
  "relatedId": "ticket_001",
  "remetenteId": "admin_123",
  "remetenteNome": "Admin Teste",
  "dataCriacao": "2024-01-15T10:30:00Z",
  "lido": false,
  "dados": {
    "ticketId": "ticket_001",
    "ticketNumero": "001"
  }
}
```

---

**Dica**: Após testar, você pode deletar as notificações de teste diretamente no Firebase Console.

