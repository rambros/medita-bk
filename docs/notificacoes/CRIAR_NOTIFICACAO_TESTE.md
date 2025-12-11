# Como Criar Notificação de Teste

> **📝 Nota:** As collections foram renomeadas em Dezembro/2024:
> - `notificacoes` → `in_app_notifications` (Notificações in-app para tickets/discussões)
> - `notificacoes_ead` → `ead_push_notifications` (Push notifications EAD)
> - `notifications` → `global_push_notifications` (Push notifications globais)

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
5. Collection ID: `in_app_notifications` (para notificações in-app de tickets/discussões)
6. Clique em **Add document**
7. Deixe o **Document ID** em branco (auto-gerado)

### Passo 3: Adicionar Campos

Adicione estes campos **exatamente** como mostrado:

| Campo | Tipo | Valor |
|-------|------|-------|
| `titulo` | string | Teste de Notificação |
| `corpo` | string | Esta é uma notificação de teste enviada manualmente |
| `tipo` | string | ticket_resposta |
| `destinatarioId` | string | **[COLE SEU USER ID AQUI]** |
| `dataCriacao` | timestamp | [Clique no relógio e selecione "Now"] |
| `lida` | boolean | false |
| `dados` | map | (Adicione subcampos abaixo) |
| `dados.ticketId` | string | test123 |
| `dados.ticketNumero` | number | 123 |

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
  .collection('in_app_notifications')
  .add({
    titulo: 'Notificação de Teste',
    corpo: 'Esta é uma notificação criada via script',
    tipo: 'ticket_resposta',
    destinatarioId: userId,
    dados: {
      ticketId: 'test456',
      ticketNumero: 456,
      mensagemId: 'msg_123'
    },
    dataCriacao: admin.firestore.FieldValue.serverTimestamp(),
    lida: false
  });

console.log('Notificação criada com sucesso!');
```

## 📱 Opção 3: Via Postman/REST API

Se você tem a API Key do Firebase:

```bash
curl -X POST \
  'https://firestore.googleapis.com/v1/projects/meditabk2020/databases/(default)/documents/in_app_notifications' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "fields": {
      "titulo": {"stringValue": "Teste via API"},
      "corpo": {"stringValue": "Notificação criada via REST API"},
      "tipo": {"stringValue": "ticket_resposta"},
      "destinatarioId": {"stringValue": "SEU_USER_ID"},
      "dataCriacao": {"timestampValue": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"},
      "lida": {"booleanValue": false},
      "dados": {
        "mapValue": {
          "fields": {
            "ticketId": {"stringValue": "test789"},
            "ticketNumero": {"integerValue": "789"}
          }
        }
      }
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
2. **Verificar Collection está como** `in_app_notifications` (nova collection renomeada)
3. **Verificar campo** `destinatarioId` **está escrito corretamente**
4. **Criar índice composto** no Firestore (se solicitado)
5. **Verificar regras** do Firestore permitem leitura
6. **Verificar campo** `corpo` ao invés de `conteudo`

## 📊 Tipos de Notificação Válidos

Use um destes valores para o campo `tipo`:

**Tickets:**
- `ticket_resposta` - Nova resposta em um ticket
- `ticket_resolvido` - Ticket marcado como resolvido
- `ticket_reaberto` - Ticket reaberto

**Discussões (EAD):**
- `discussao_resposta` - Nova resposta em discussão
- `discussao_melhor_resposta` - Resposta marcada como melhor
- `discussao_solucao` - Resposta marcada como solução
- `discussao_like` - Alguém curtiu uma resposta

## 🎨 Exemplo Completo (JSON)

```json
{
  "titulo": "🎉 Teste de Notificação",
  "corpo": "Se você está vendo isso, o sistema funciona!",
  "tipo": "ticket_resposta",
  "destinatarioId": "abc123xyz456",
  "dataCriacao": "2024-01-15T10:30:00Z",
  "lida": false,
  "dados": {
    "ticketId": "ticket_001",
    "ticketNumero": 1,
    "mensagemId": "msg_123"
  }
}
```

---

**Dica**: Após testar, você pode deletar as notificações de teste diretamente no Firebase Console.

