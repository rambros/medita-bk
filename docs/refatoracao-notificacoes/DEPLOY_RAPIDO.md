# Deploy Rápido - Sistema de Notificações

**⏱️ Tempo estimado:** 20 minutos
**📋 Pré-requisito:** Firebase CLI instalado

---

## 🚀 Comandos de Deploy

### 1. Instalar Firebase CLI (se necessário)

```bash
npm install -g firebase-tools
```

### 2. Login no Firebase

```bash
firebase login
```

### 3. Deploy

```bash
# Navegar até o diretório do projeto
cd /Users/rodrigoambros/Documents/Desenv/0.Clientes/Agencia/ProjGW/codigo/medita-bk

# Deploy das rules e índices
firebase deploy --only firestore
```

**Saída esperada:**
```
✔ Deploy complete!

Project Console: https://console.firebase.google.com/project/your-project/overview
```

---

## ⏱️ Aguardar Índices

Os índices podem levar **5-15 minutos** para serem criados.

**Verificar status:**
1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Firestore Database > Indexes
4. Aguarde todos os índices mostrarem **"Enabled"**

**Índices esperados:**
- ✅ `notifications` (destinatarios, dataCriacao)
- ✅ `notifications` (categoria, dataCriacao)
- ✅ `notifications` (destinatarios, categoria, dataCriacao)
- ✅ `notifications` (status, dataCriacao)

---

## 🧪 Teste Rápido

### Criar Notificação de Teste (Console Firebase)

1. Firebase Console > Firestore > Collection `notifications`
2. Clicar em **"Add document"**
3. Preencher:

```json
{
  "titulo": "Teste do Sistema Novo",
  "conteudo": "Se você está vendo isso, o sistema está funcionando!",
  "tipo": "sistema_geral",
  "categoria": "sistema",
  "destinatarios": ["TODOS"],
  "dataCriacao": "2025-12-11T10:00:00Z",
  "dataEnvio": "2025-12-11T10:00:00Z",
  "status": "enviada"
}
```

4. Clicar em **"Save"**

### Verificar no Mobile

1. Abrir app mobile
2. Ir para página de **Notificações**
3. Deve aparecer a notificação de teste
4. Clicar nela → deve marcar como lida
5. Deletar → deve sumir da lista

---

## ✅ Checklist Pós-Deploy

- [ ] Índices criados (status "Enabled")
- [ ] Notificação de teste criada
- [ ] Aparece no mobile
- [ ] Marca como lida funciona
- [ ] Deletar funciona
- [ ] Badge de contador atualiza

---

## ⚠️ Se Algo Der Errado

### Erro: "Missing index"

**Solução:** Aguarde mais tempo (até 15 min) ou use o link fornecido pelo Firebase para criar o índice automaticamente.

### Erro: "Permission denied"

**Solução:** Verifique as regras em `firestore.rules` e faça deploy novamente:
```bash
firebase deploy --only firestore:rules
```

### Notificação não aparece no mobile

**Verificar:**
1. Índices estão "Enabled"?
2. Campo `destinatarios` contém `["TODOS"]` ou o userId?
3. App está autenticado?
4. Console do Flutter mostra logs `🔔 Buscando notificações...`?

---

## 🗑️ Deletar Dados Antigos (Opcional)

**⚠️ APENAS APÓS TUDO TESTADO!**

```bash
# Deletar collections antigas
firebase firestore:delete in_app_notifications --recursive
firebase firestore:delete ead_push_notifications --recursive
firebase firestore:delete global_push_notifications --recursive
```

---

## 📝 Rollback (Se Necessário)

```bash
# Reverter código mobile
git checkout HEAD~3 lib/data/repositories/notificacoes_repository.dart
git checkout HEAD~3 lib/ui/notificacoes/
git checkout HEAD~3 lib/domain/models/

# Reverter Firestore rules
git checkout HEAD~1 firestore.rules firestore.indexes.json
firebase deploy --only firestore
```

---

## 📚 Documentação Completa

- [GUIA_MIGRACAO_NOTIFICACOES.md](GUIA_MIGRACAO_NOTIFICACOES.md) - Guia completo
- [FIRESTORE_DEPLOY.md](FIRESTORE_DEPLOY.md) - Detalhes do deploy
- [MIGRACAO_COMPLETA.md](MIGRACAO_COMPLETA.md) - Resumo executivo

---

**Pronto!** Após o deploy e testes, o sistema estará 100% operacional. 🎉
