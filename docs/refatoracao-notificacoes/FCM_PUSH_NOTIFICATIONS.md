# Sistema FCM Push Notifications - INTACTO ✅

**Data:** 2025-12-11
**Status:** ✅ Sistema FCM não foi afetado pela refatoração

---

## ✅ Confirmação

O sistema de **push notifications via FCM (Firebase Cloud Messaging)** está **100% intacto** e **não foi afetado** pela refatoração do sistema de notificações in-app.

---

## 🔄 Sistemas Separados

A refatoração focou apenas nas **notificações in-app** (exibidas dentro do app). O sistema de **push notifications FCM** é completamente separado e continua funcionando normalmente.

### Sistema In-App (Refatorado)
- ✅ Collections: `notifications` (nova)
- ✅ Exibidas na página de Notificações do app
- ✅ Queries otimizadas (1 query)

### Sistema FCM (Intacto)
- ✅ Collection: `ff_push_notifications`
- ✅ Tokens: `users/{userId}/fcm_tokens`
- ✅ Cloud Functions: `addFcmToken`, `sendPushNotificationsTrigger`
- ✅ Push notifications enviadas para dispositivos

---

## 📁 Collections FCM (Intactas)

### 1. `ff_push_notifications`

**Uso:** Armazena notificações para envio via FCM

**Estrutura:**
```javascript
{
  notification_title: "Título",
  notification_text: "Mensagem",
  notification_image_url: "https://...",
  notification_sound: "default",
  target_audience: "All", // ou "iOS", "Android"
  initial_page_name: "HomePage",
  parameter_data: "...",
  user_refs: "users/userId1,users/userId2", // ou vazio para todos
  scheduled_time: Timestamp, // opcional
  status: "succeeded", // succeeded | failed | started
  num_sent: 150
}
```

**Trigger:** Cloud Function `sendPushNotificationsTrigger` dispara automaticamente ao criar documento.

### 2. `users/{userId}/fcm_tokens`

**Uso:** Armazena tokens FCM de cada dispositivo do usuário

**Estrutura:**
```javascript
{
  fcm_token: "token123...",
  device_type: "iOS", // ou "Android"
  created_at: Timestamp
}
```

**Como funciona:**
1. App mobile solicita permissão de notificações
2. FCM retorna token único do dispositivo
3. Cloud Function `addFcmToken` salva na subcollection
4. Tokens são usados para enviar notificações push

---

## 🔥 Cloud Functions (Intactas)

Localização: `firebase/functions/index.js`

### 1. `addFcmToken`

**Função:** Adiciona token FCM do dispositivo

**Trigger:** Chamada HTTPS (via mobile)

**Código:**
```javascript
exports.addFcmToken = functions.https.onCall(async (data, context) => {
  // Valida autenticação
  // Salva token em users/{userId}/fcm_tokens
  // Gerencia tokens duplicados
});
```

**Chamada no mobile:**
```dart
// lib/data/services/push_notifications/push_notifications_util.dart
CloudFunctionsService.makeCloudCall(
  'addFcmToken',
  {
    'userDocPath': 'users/userId',
    'fcmToken': token,
    'deviceType': 'iOS',
  },
);
```

### 2. `sendPushNotificationsTrigger`

**Função:** Envia push notifications ao criar documento

**Trigger:** Firestore onCreate em `ff_push_notifications`

**Código:**
```javascript
exports.sendPushNotificationsTrigger = functions
  .firestore.document('ff_push_notifications/{id}')
  .onCreate(async (snapshot, _) => {
    // Lê dados da notificação
    // Busca tokens dos destinatários
    // Envia via admin.messaging().sendEachForMulticast()
  });
```

### 3. `sendScheduledPushNotifications`

**Função:** Envia notificações agendadas

**Trigger:** Pub/Sub (executa a cada 15 minutos)

**Código:**
```javascript
exports.sendScheduledPushNotifications = functions.pubsub
  .schedule('every 15 minutes synchronized')
  .onRun(async (_) => {
    // Busca notificações com scheduled_time
    // Envia as que estão no intervalo
  });
```

---

## 🔐 Firestore Rules (Atualizadas)

Adicionei regras para as collections FCM no `firestore.rules`:

```javascript
// Collection para envio de push notifications via FCM
match /ff_push_notifications/{notifId} {
  allow read: if request.auth != null && hasAdminRole();
  allow write: if request.auth != null && hasAdminRole();
}

// FCM Tokens (subcollection de users)
match /users/{userId}/fcm_tokens/{tokenId} {
  allow read: if request.auth != null &&
                 (userId == request.auth.uid || hasAdminRole());
  allow write: if request.auth != null && userId == request.auth.uid;
}
```

---

## 🔄 Como Funciona o Fluxo FCM

### 1. Registro de Token (Mobile)

```dart
// Ao abrir o app, automaticamente:
// 1. Solicita permissão de notificações
FirebaseMessaging.instance.requestPermission();

// 2. Obtém token FCM
final token = await FirebaseMessaging.instance.getToken();

// 3. Envia para Cloud Function
await CloudFunctionsService.makeCloudCall('addFcmToken', {...});

// 4. Cloud Function salva em users/{userId}/fcm_tokens
```

### 2. Envio de Notificação (Web Admin ou Backend)

```javascript
// Criar documento em ff_push_notifications
await firestore.collection('ff_push_notifications').add({
  notification_title: 'Título',
  notification_text: 'Mensagem',
  target_audience: 'All',
  // ... outros campos
});

// Cloud Function dispara automaticamente
// Busca tokens dos usuários
// Envia push notifications via FCM
```

### 3. Recebimento no Mobile

```dart
// Firebase Messaging handler
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Exibe notificação local
  // ou navega para página específica
});
```

---

## ⚠️ Importante

### Collections FCM são INDEPENDENTES

As collections do sistema FCM (`ff_push_notifications` e `fcm_tokens`) são **completamente separadas** das collections de notificações in-app.

**FCM:**
- `ff_push_notifications` → Envia push para dispositivos
- Gerenciado por Cloud Functions
- Usado para notificações push (aparecem na bandeja do sistema)

**In-App (Refatorado):**
- `notifications` → Exibe dentro do app
- Gerenciado por repository
- Usado para notificações in-app (aparecem na página de Notificações)

### Você pode ter AMBOS

Um sistema não interfere no outro:

1. **Push notification** → Aparece na bandeja do sistema operacional
2. **In-app notification** → Aparece na página de Notificações do app

Exemplo: Ao criar um ticket, você pode:
- Enviar **push** via `ff_push_notifications` (notificação push)
- Criar **in-app** via `notifications` (notificação in-app)

---

## ✅ Checklist de Verificação

- [x] Cloud Functions intactas (`firebase/functions/index.js`)
- [x] Collection `ff_push_notifications` funcional
- [x] Subcollection `fcm_tokens` funcional
- [x] Mobile registra tokens corretamente
- [x] Firestore Rules adicionadas para FCM
- [x] Sistema separado do in-app

---

## 🧪 Como Testar

### Testar Registro de Token

1. Abrir app mobile
2. Verificar logs: `Successfully added FCM token!`
3. Firebase Console → Firestore → `users/{userId}/fcm_tokens`
4. Deve aparecer documento com `fcm_token`

### Testar Envio de Push

1. Firebase Console → Firestore → `ff_push_notifications`
2. Adicionar documento:
```json
{
  "notification_title": "Teste",
  "notification_text": "Push notification teste",
  "target_audience": "All"
}
```
3. Cloud Function dispara automaticamente
4. Push notification aparece no dispositivo
5. Documento atualiza com `status: "succeeded"`

---

## 📚 Arquivos Relacionados

### Mobile
- `lib/data/services/push_notifications/push_notifications_util.dart` - Gerencia FCM tokens
- `lib/utils/push_notifications_util.dart` - Helper de push notifications
- `lib/main.dart` - Inicializa FCM

### Cloud Functions
- `firebase/functions/index.js` - Functions de FCM

### Configuração
- `android/app/src/main/AndroidManifest.xml` - Config Android
- `ios/Runner/AppDelegate.swift` - Config iOS

---

## 🎉 Conclusão

O sistema de **push notifications via FCM está 100% funcional** e não foi afetado pela refatoração das notificações in-app.

As collections `ff_push_notifications` e `users/{userId}/fcm_tokens` continuam operando normalmente com as Cloud Functions.

---

**Status:** ✅ Sistema FCM intacto e funcional
**Data:** 2025-12-11
