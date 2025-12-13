# ✅ Correções: Notificações de Discussão

## 🐛 Problema Original
**Notificações de resposta de discussão** criadas pelo professor no painel web admin **não apareciam** na lista de notificações do app mobile.

---

## 🔧 Correções Aplicadas

### 1. **NotificacaoEadService** (Mobile) - `lib/data/services/notificacao_ead_service.dart`

#### ❌ Problema:
- Salvava na collection **`in_app_notifications`** (antiga/errada)
- Formato de dados incompatível com `NotificacoesRepository`

#### ✅ Correção:
- **Collection alterada** para `notifications` (unificada)
- **Formato atualizado**:
  - `destinatarioId` (string) → `destinatarios` (array)
  - Adicionado `status: 'enviada'`
  - Adicionado `dataEnvio`
  - Estrutura `navegacao` correta
- **Queries atualizadas**:
  - `where('destinatarioId', isEqualTo: ...)` → `where('destinatarios', arrayContains: ...)`
  - Todas as leituras agora consultam `user_states` para estado de leitura

---

### 2. **NotificacoesRepository** (Mobile) - `lib/data/repositories/notificacoes_repository.dart`

#### ✅ Logs de Debug Adicionados:
Para facilitar troubleshooting, foram adicionados logs detalhados:

```dart
// Logs de busca
🔔 Buscando notificações para userId: abc123
📄 Notificação: notif001
  - tipo: discussao_respondida
  - titulo: Nova resposta na sua discussão
  - destinatarios: [abc123]
  - dataCriacao: 2024-01-15 10:30:00

// Logs de processamento
🔍 Processando notif001: lido=false, ocultado=false
✅ Adicionando notificação: Resposta na Discussão

// Logs de resultado
🔔 Total após filtros: 5 notificações
📋 Tipos: Resposta na Discussão, Novo Ticket, Novo Curso, ...
```

Agora é possível **ver exatamente**:
- Se a notificação está sendo encontrada
- Se está sendo filtrada (por ocultado/lido)
- Qual o tipo de cada notificação

---

## 📋 Arquivos Modificados

### Mobile (medita-bk)
1. ✅ `lib/data/services/notificacao_ead_service.dart`
   - Collection: `in_app_notifications` → `notifications`
   - Formato: Array `destinatarios`, `status`, `navegacao`, `dataEnvio`
   - Queries: `arrayContains` ao invés de `isEqualTo`

2. ✅ `lib/data/repositories/notificacoes_repository.dart`
   - Logs de debug adicionados

### Web Admin (medita-bk-web-admin)
- ✅ **Nenhuma alteração necessária** - já estava usando collection e formato corretos

---

## 🧪 Como Testar

### Passo 1: Fazer Professor Responder Discussão

1. Faça login no **web admin** como professor
2. Vá em **EAD > Comunicação > Discussões**
3. Abra uma discussão criada por um aluno
4. **Adicione uma resposta**

### Passo 2: Verificar Logs no App Mobile

1. Conecte o device/emulador ao computador
2. Rode o app em modo debug
3. Abra a **aba de Notificações** no app
4. No console do IDE, procure por:

```
🔔 Buscando notificações para userId: ...
📄 Notificação: ... tipo=discussao_respondida
🔍 Processando ... lido=false, ocultado=false
✅ Adicionando notificação: Resposta na Discussão
🔔 Total após filtros: X notificações
```

### Passo 3: Interpretar Resultado

#### ✅ **Caso 1: Notificação aparece nos logs E na lista**
**SUCESSO!** Problema resolvido.

#### ⚠️ **Caso 2: Notificação aparece nos logs MAS NÃO na lista**
Problema na UI. Verificar:
- `notificacoes_page.dart`
- Filtros/ordenação da lista

#### ❌ **Caso 3: Notificação NÃO aparece nos logs**
Problema na criação pelo web admin. Verificar:
1. Professor tem `role: "admin"` no Firestore?
2. Erro no console do navegador (DevTools F12)?
3. Notificação foi criada no Firestore?

Para diagnóstico detalhado, consulte: **TESTE_NOTIFICACAO_DISCUSSAO.md**

---

## 🔍 Troubleshooting

### Se ainda não funcionar:

#### 1. Verificar Firestore Console
```
Firebase Console > Firestore Database > notifications
```
Após professor responder, deve aparecer documento com:
```json
{
  "tipo": "discussao_respondida",
  "titulo": "Nova resposta na sua discussão",
  "destinatarios": ["aluno_uid"],
  "status": "enviada",
  "navegacao": {
    "tipo": "discussao",
    "id": "discussao123"
  },
  "dataCriacao": Timestamp,
  "dataEnvio": Timestamp
}
```

**Se NÃO aparecer:**
- Problema: Web admin não está criando
- Verificar: Role do professor, erros no console do navegador

**Se APARECER:**
- Problema: App mobile não está lendo
- Verificar: Query, índices do Firestore, logs do app

#### 2. Verificar Role do Professor
```
Firestore > users > [uid_do_professor]
```
Deve ter: `role: "admin"`

Se não tiver, adicionar manualmente.

#### 3. Verificar Índices do Firestore
O arquivo `firestore.indexes.json` já está correto:
```json
{
  "collectionGroup": "notifications",
  "fields": [
    {"fieldPath": "destinatarios", "arrayConfig": "CONTAINS"},
    {"fieldPath": "dataCriacao", "order": "DESCENDING"}
  ]
}
```

Fazer deploy:
```bash
firebase deploy --only firestore:indexes
```

---

## ✅ Checklist de Verificação

- [x] Mobile usa collection `notifications`
- [x] Mobile usa array `destinatarios`  
- [x] Mobile salva campos `status` e `dataEnvio`
- [x] Mobile estrutura `navegacao` correta
- [x] Mobile queries com `arrayContains`
- [x] Web admin usa collection `notifications` (já estava)
- [x] Web admin chama serviço de notificação (já estava)
- [x] Logs de debug adicionados no mobile
- [ ] Testar: Professor responder discussão
- [ ] Verificar: Notificação aparece no app
- [ ] Verificar: Navegação funciona ao clicar

---

## 📝 Notas Finais

### O que foi alterado:
- ✅ **Apenas código MOBILE** (app Flutter)
- ✅ Collection unificada `notifications`
- ✅ Formato de dados padronizado
- ✅ Logs de debug para troubleshooting

### O que NÃO foi alterado:
- ✅ Web admin (já estava correto)
- ✅ Firebase Functions (não lida com discussões)
- ✅ Firestore Rules (já permitem admin criar)
- ✅ Índices do Firestore (já existem)

### Se problema persistir:
1. Execute os testes do arquivo `TESTE_NOTIFICACAO_DISCUSSAO.md`
2. Compartilhe os logs do console
3. Verifique se notificação foi criada no Firestore
4. Confirme role do professor

---

🎯 **Próximo Passo:** Rode o app, peça para o professor responder uma discussão, e verifique os logs! 🚀


