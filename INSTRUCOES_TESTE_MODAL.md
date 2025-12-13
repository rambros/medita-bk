# Instruções para Testar o Modal de Atualização de Cadastro

## ⚠️ IMPORTANTE: Hot Restart Necessário

Após as alterações no código, você **DEVE** fazer um **Hot Restart** (não apenas Hot Reload) para que as mudanças tenham efeito.

### Como fazer Hot Restart:
- **VS Code**: Pressione `Ctrl+Shift+F5` (ou `Cmd+Shift+F5` no Mac)
- **Android Studio**: Clique no botão "Hot Restart" (ícone de relâmpago com seta circular)
- **Terminal**: Pressione `R` (maiúsculo) no terminal onde o `flutter run` está executando

---

## 🧪 Passos para Testar

### Teste 1: Inscrição em Novo Curso (Página de Detalhes)

1. Faça **Hot Restart** do aplicativo
2. Navegue até: **Home** → **Aprender com cursos** → **Catálogo de Cursos**
3. Escolha um curso que você **NÃO** está inscrito
4. Clique no botão **"Iniciar Curso"** (botão no rodapé da tela)
5. ✅ O modal "Atualização do cadastro" deve aparecer com os campos:
   - Nome Completo
   - WhatsApp/Celular
   - Cidade
6. Preencha os campos e clique em **"Salvar"**
7. A inscrição no curso deve ser concluída

### Teste 2: Continuar Curso (Página Meus Cursos)

1. Faça **Hot Restart** do aplicativo
2. Navegue até: **Home** → **Aprender com cursos** → **Meus Cursos**
3. Escolha um curso que você **JÁ** está inscrito
4. Clique no botão **"Iniciar Curso"** (no card do curso)
5. ✅ O modal "Atualização do cadastro" deve aparecer
6. Os campos devem vir **pré-preenchidos** com os dados já salvos
7. Confirme ou atualize os dados e clique em **"Salvar"**
8. Você deve ser direcionado para o tópico do curso

---

## 🔍 Verificação de Logs

Se o modal não aparecer, adicione prints temporários para debug:

### No arquivo `curso_detalhes_page.dart` (linha ~62):

```dart
// Busca os dados atuais do usuário
final userRepo = context.read<UserRepository>();
print('🔍 DEBUG: Buscando dados do usuário...'); // ADICIONE ESTA LINHA
final currentUserData = await userRepo.getUserById(authRepo.currentUserUid);
print('🔍 DEBUG: Dados do usuário: $currentUserData'); // ADICIONE ESTA LINHA
```

### No arquivo `meus_cursos_page.dart` (linha ~110):

```dart
// Busca os dados atuais do usuário
final userRepo = context.read<UserRepository>();
print('🔍 DEBUG: Buscando dados do usuário...'); // ADICIONE ESTA LINHA
final currentUserData = await userRepo.getUserById(_usuarioId!);
print('🔍 DEBUG: Dados do usuário: $currentUserData'); // ADICIONE ESTA LINHA
```

Depois, faça **Hot Restart** e observe os logs no console.

---

## ✅ Validações no Modal

O modal valida:

1. **Nome Completo**:
   - Não pode estar vazio
   - Deve conter nome e sobrenome (mínimo 2 palavras)

2. **WhatsApp**:
   - Não pode estar vazio
   - Deve ter 10 ou 11 dígitos (DDD + número)
   - Formatação automática: (XX) XXXXX-XXXX

3. **Cidade**:
   - Não pode estar vazia

---

## 📊 Dados Salvos no Firestore

Após salvar, verifique no Firestore Console:

**Collection**: `users`
**Document**: `{userId}`

Campos atualizados:
- `fullName`: Nome completo do usuário
- `whatsapp`: Número do WhatsApp
- `cidade`: Cidade do usuário

---

## 🐛 Problemas Comuns

### Modal não aparece:
1. ✅ Certifique-se de ter feito **Hot Restart** (não apenas Hot Reload)
2. ✅ Verifique se o usuário está logado
3. ✅ Verifique os logs do console para erros
4. ✅ Limpe o build: `flutter clean && flutter pub get`

### Erro ao salvar:
1. ✅ Verifique a conexão com Firebase
2. ✅ Verifique as permissões do Firestore
3. ✅ Verifique os logs de erro no console

### Campos não validam:
1. ✅ Verifique se todos os campos estão preenchidos
2. ✅ Nome completo precisa ter nome e sobrenome
3. ✅ WhatsApp precisa ter 10-11 dígitos

---

## 📱 Arquivos Modificados

Se você perdeu alguma alteração, aqui estão os arquivos que foram modificados:

1. ✅ `lib/data/models/firebase/user_model.dart` - Adicionados campos `whatsapp` e `cidade`
2. ✅ `lib/data/repositories/user_repository.dart` - Método `updateContactInfo()`
3. ✅ `lib/ui/ead/widgets/update_user_info_dialog.dart` - Widget do modal (NOVO ARQUIVO)
4. ✅ `lib/ui/ead/curso_detalhes_page/curso_detalhes_page.dart` - Integração do modal
5. ✅ `lib/ui/ead/meus_cursos_page/meus_cursos_page.dart` - Integração do modal

---

## 💡 Dica Final

Se ainda não funcionar após o Hot Restart, tente:

```bash
flutter clean
flutter pub get
flutter run
```

Isso força uma reconstrução completa do aplicativo.
