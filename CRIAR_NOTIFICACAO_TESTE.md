# 🧪 Teste Manual: Criar Notificação no Firestore Console

## Objetivo
Criar manualmente uma notificação de teste para confirmar que o app mobile consegue ler.

## Passo a Passo

### 1. Pegue seu UID do Firestore

1. Abra **Firebase Console > Firestore Database**
2. Vá em **`users`**
3. Encontre seu usuário (aluno)
4. **Copie o Document ID** (é o seu UID)
   - Ex: `abc123xyz456...`

### 2. Crie a Notificação de Teste

1. Ainda no Firestore, vá na collection **`notifications`**
2. Clique em **"Adicionar documento"**
3. Configure:

**ID do documento:** (deixe vazio, será auto-gerado)

**Campos:** (adicione um por um)

| Campo | Tipo | Valor |
|-------|------|-------|
| `titulo` | string | `TESTE: Nova resposta` |
| `conteudo` | string | `Testando notificação de discussão manual` |
| `tipo` | string | `discussao_respondida` |
| `categoria` | string | `discussao` |
| `status` | string | `enviada` |
| `destinatarios` | array | Clique "Adicionar item" → Cole seu UID |
| `dataCriacao` | timestamp | Clique no relógio → "Set to current time" |
| `dataEnvio` | timestamp | Clique no relógio → "Set to current time" |

**IMPORTANTE: Campo `navegacao` (objeto):**

1. Clique em "Adicionar campo"
2. Nome: `navegacao`
3. Tipo: **map**
4. Clique na setinha para expandir
5. Adicione dentro do map:
   - `tipo` (string): `discussao`
   - `id` (string): `teste123`
   - `dados` (map): deixe vazio ou adicione `cursoId: "curso123"`

### 3. Salvar e Testar

1. Clique em **"Salvar"**
2. **Abra o app mobile**
3. Vá em **Notificações**
4. **RECARREGUE** (pull to refresh)

### 4. Resultado Esperado

✅ **DEVE APARECER**: Notificação "TESTE: Nova resposta"

❌ **SE NÃO APARECER**:
- O problema está no APP MOBILE (query/leitura)
- Compartilhe os logs do console do app

✅ **SE APARECER**:
- O app mobile funciona corretamente
- O problema está no WEB ADMIN (criação)
- Professor pode não ter permissão ou web admin tem erro

---

## Me informe o resultado! 🎯

