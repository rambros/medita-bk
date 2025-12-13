# 🔍 Verificar Notificação no Firestore Console

## Passo a Passo

1. Abra o **Firebase Console**: https://console.firebase.google.com
2. Selecione o projeto **meditabk2020**
3. Clique em **Firestore Database** (menu lateral)
4. Clique na collection **`notifications`**
5. Ordene por **dataCriacao** (mais recente primeiro)

## O que procurar

Deve haver um documento com:
- **Timestamp recente** (hoje, há poucos minutos)
- **tipo**: `discussao_respondida` ← DEVE SER EXATAMENTE ISSO
- **titulo**: "Nova resposta na sua discussão"
- **destinatarios**: [array com UID do aluno]

## Copie e cole aqui:

```json
{
  // Cole TODOS os campos do documento mais recente aqui
}
```

## Se NÃO houver documento recente:
- O problema está no **WEB ADMIN** (não está criando)
- Possíveis causas:
  1. Professor não tem role "admin"
  2. Erro silencioso no web admin
  3. Web admin não foi atualizado/re-deployed

## Se houver documento recente:
- O problema está no **APP MOBILE** (não está lendo)
- Precisamos ver os logs do console do app



