# Guia de Atualização de ViewModels Restantes

## ✅ ViewModels Já Atualizados

1. ✅ `MeditationListViewModel` - Usa `MeditationModel`
2. ✅ `AboutAuthorsViewModel` - Usa `UserModel`

---

## ⏳ ViewModels Pendentes

### 1. EditProfileViewModel

**Arquivo:**
`/lib/ui/config/edit_profile_page/view_model/edit_profile_view_model.dart`

**Erros:**

- Linha 132: `updateUser()` espera `(String userId, UserModel user)` mas está
  recebendo `(DocumentReference, Map<String, dynamic>)`

**Solução:**

```dart
// ANTES (linha ~130-135):
await _userRepository.updateUser(
  currentUserReference!,
  createUsersRecordData(
    fullName: _fullNameTextController.text,
    // ... outros campos
  ),
);

// DEPOIS:
final currentUser = await _userRepository.getUserById(currentUserUid);
if (currentUser != null) {
  final updatedUser = currentUser.copyWith(
    fullName: _fullNameTextController.text,
    phoneNumber: _phoneTextController.text,
    curriculum: _curriculumTextController.text,
    site: _siteTextController.text,
    contact: _contactTextController.text,
    userImageUrl: uploadedFileUrl.isNotEmpty ? uploadedFileUrl : currentUser.userImageUrl,
    userImageFileName: uploadedLocalFile.bytes != null ? uploadedLocalFile.name ?? '' : currentUser.userImageFileName,
  );
  
  await _userRepository.updateUser(currentUserUid, updatedUser);
}
```

**Imports a adicionar:**

```dart
import '/data/models/firebase/user_model.dart';
```

**Imports a remover:**

```dart
import '/backend/backend.dart'; // Se não usar mais nada deste import
```

---

### 2. SignUpViewModel

**Arquivo:** `/lib/ui/authentication/sign_up/view_model/sign_up_view_model.dart`

**Erros:**

- Linha 33-34: `createUser()` espera `UserModel` mas está recebendo
  `Map<String, dynamic>`

**Solução:**

```dart
// ANTES (linha ~30-35):
await _userRepository.updateUser(
  userDocRef,
  createUsersRecordData(
    uid: user.uid,
    email: user.email,
    // ... outros campos
  ),
);

// DEPOIS:
final newUser = UserModel(
  uid: user.uid,
  email: user.email ?? '',
  fullName: _fullNameTextController.text,
  displayName: _fullNameTextController.text,
  phoneNumber: _phoneTextController.text,
  createdTime: DateTime.now(),
  loginType: 'email', // ou o tipo apropriado
);

await _userRepository.createUser(newUser);
```

**Imports a adicionar:**

```dart
import '/data/models/firebase/user_model.dart';
```

---

## 📝 Padrão Geral de Migração

### Para ViewModels que usam UsersRecord:

1. **Atualizar imports:**

```dart
// Remover:
import '/backend/backend.dart';

// Adicionar:
import '/data/models/firebase/user_model.dart';
```

2. **Atualizar declarações de tipo:**

```dart
// ANTES:
UsersRecord? _user;
List<UsersRecord> _users = [];

// DEPOIS:
UserModel? _user;
List<UserModel> _users = [];
```

3. **Atualizar chamadas de repository:**

```dart
// ANTES (usando createUsersRecordData):
await _userRepository.updateUser(
  reference,
  createUsersRecordData(field: value),
);

// DEPOIS (usando UserModel):
final updatedUser = currentUser.copyWith(field: value);
await _userRepository.updateUser(userId, updatedUser);
```

### Para ViewModels que usam MeditationsRecord:

1. **Atualizar imports:**

```dart
// Remover:
import '/backend/backend.dart';

// Adicionar:
import '/data/models/firebase/meditation_model.dart';
```

2. **Atualizar declarações de tipo:**

```dart
// ANTES:
MeditationsRecord? _meditation;
List<MeditationsRecord> _meditations = [];
Stream<List<MeditationsRecord>> _stream;

// DEPOIS:
MeditationModel? _meditation;
List<MeditationModel> _meditations = [];
Stream<List<MeditationModel>> _stream;
```

---

## 🔍 Como Encontrar ViewModels que Precisam Atualização

### Buscar por UsersRecord:

```bash
grep -r "UsersRecord" lib/ui/ --include="*.dart"
```

### Buscar por MeditationsRecord:

```bash
grep -r "MeditationsRecord" lib/ui/ --include="*.dart"
```

### Buscar por createUsersRecordData:

```bash
grep -r "createUsersRecordData" lib/ui/ --include="*.dart"
```

### Buscar por createMeditationsRecordData:

```bash
grep -r "createMeditationsRecordData" lib/ui/ --include="*.dart"
```

---

## ✅ Checklist de Migração

Para cada ViewModel:

- [ ] Atualizar imports
- [ ] Atualizar declarações de tipo
- [ ] Atualizar chamadas de repository
- [ ] Remover uso de `createXXXRecordData()`
- [ ] Usar `copyWith()` para updates
- [ ] Testar compilação
- [ ] Verificar lints

---

## 🚨 Atenção

### Diferenças Importantes:

1. **Reference vs ID:**
   - `UsersRecord` tinha `.reference` (DocumentReference)
   - `UserModel` tem `.uid` (String)

2. **Nullable vs Non-nullable:**
   - `UsersRecord.uid` retornava `''` se null
   - `UserModel.uid` é `required` e nunca null

3. **Listas:**
   - `UsersRecord.favorites` retornava `const []` se null
   - `UserModel.favorites` tem default `const []`

4. **Timestamps:**
   - `UsersRecord` usava `DateTime?` diretamente
   - `UserModel` também usa `DateTime?` mas com conversão explícita de
     `Timestamp`

---

**Última atualização:** 2025-11-25
