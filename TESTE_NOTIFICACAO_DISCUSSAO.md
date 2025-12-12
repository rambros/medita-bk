# 🧪 Teste: Notificações de Discussão

## ❌ Problema Reportado
**Notificações de resposta de discussão** criadas pelo professor no web admin **não aparecem no app mobile**.

## ✅ Código Corrigido (Mobile)
O `NotificacaoEadService` no app mobile foi atualizado para usar a collection `notifications` correta.

## 🔍 Verificações Necessárias

### 1. Verificar Role do Professor

**No Firebase Console:**
```
Firestore Database > users > [UID do professor]
```

**Deve ter:**
```json
{
  "email": "professor@email.com",
  "name": "Nome do Professor",
  "role": "admin"  ← VERIFICAR SE EXISTE
}
```

**Se NÃO tiver `role: "admin"`:**
- Adicione manualmente no Firestore Console
- Ou atualize via código/script

---

### 2. Verificar Erros no Console do Web Admin

**Ao responder uma discussão no web admin:**

1. Abra o **DevTools** do navegador (F12)
2. Vá para a aba **Console**
3. Responda uma discussão
4. Procure por erros em vermelho:
   - `FirebaseError: Missing or insufficient permissions`
   - `Erro ao enviar notificação:`
   - `Erro ao criar push notification:`

**Se aparecer erro de permissão:**
- Confirme que o professor tem `role: "admin"` no Firestore

---

### 3. Verificar se Notificação Foi Criada no Firestore

**No Firebase Console:**
```
Firestore Database > notifications
```

**Após professor responder discussão, verificar:**
1. Se aparece um **novo documento** com timestamp recente
2. Se o documento tem:
   ```json
   {
     "titulo": "Nova resposta na sua discussão",
     "conteudo": "Professor respondeu...",
     "tipo": "discussao_respondida",
     "destinatarios": ["[UID do aluno]"],
     "navegacao": {
       "tipo": "discussao",
       "id": "[discussaoId]"
     },
     "status": "enviada",
     "dataCriacao": Timestamp,
     "dataEnvio": Timestamp
   }
   ```

**Se a notificação NÃO aparece:**
- O problema é na **criação** (permissão ou erro no web admin)

**Se a notificação APARECE:**
- O problema é na **leitura** pelo app mobile

---

### 4. Verificar Leitura no App Mobile

**Se a notificação existe no Firestore mas não aparece no app:**

Abra o Firestore Console e verifique:
```
notifications > [doc da notificação] > destinatarios
```

**Deve conter** o UID do aluno que criou a discussão:
```json
"destinatarios": ["abc123..."]  ← UID do aluno
```

**Se estiver errado** (vazio, ou com UID errado):
- O problema é no código do web admin que pega `discussao.autorId`

---

### 5. Testar Manualmente (Criar Notificação via Console)

**Para confirmar que o app mobile consegue ler:**

1. Vá em `Firestore > notifications`
2. Clique em **"Adicionar documento"**
3. Preencha:
   ```
   ID: (deixe auto-gerado)
   
   Campos:
   titulo: "Teste manual"
   conteudo: "Testando notificação de discussão"
   tipo: "discussao_respondida"
   destinatarios: ["[SEU_UID]"]  ← Use seu próprio UID
   status: "enviada"
   dataCriacao: Timestamp (now)
   dataEnvio: Timestamp (now)
   navegacao: {
     tipo: "discussao"
     id: "teste123"
   }
   ```
4. Salve e **abra o app mobile**
5. Vá em **Notificações**

**Resultado esperado:**
- A notificação **deve aparecer** na lista

**Se NÃO aparecer:**
- O problema é na leitura do app mobile (repository/query)

**Se APARECER:**
- O problema é que o web admin não está criando corretamente

---

## 🎯 Próximos Passos

Faça as verificações acima **nesta ordem** e me informe:

1. ✅/❌ Professor tem `role: "admin"`?
2. ✅/❌ Aparece erro no Console do navegador?
3. ✅/❌ Notificação é criada no Firestore?
4. ✅/❌ Campo `destinatarios` está correto?
5. ✅/❌ Notificação manual aparece no app?

Com essas respostas, consigo identificar exatamente onde está o problema! 🔍

