# Sistema de Notificações com Estados por Usuário

## 🎯 Problema Resolvido

Anteriormente, o sistema de notificações tinha os seguintes problemas:

1. **Collection `notifications` (Meditação)**: Não tinha controle de leitura. Todas as notificações sempre apareciam como não lidas.
2. **Collection `notificacoes_ead` (EAD)**: O campo `lido` era global - se um usuário marcava como lida, marcava para todos.
3. **Deleção**: Quando um usuário deletava uma notificação, ela era removida permanentemente do Firestore, afetando outros usuários.

## ✅ Solução Implementada

Foi implementado um sistema de **subcollections `user_states/{userId}`** em ambas as collections de notificações.

### Estrutura Firestore

```
notifications/{notificationId}/
  ├── [campos da notificação]
  └── user_states/
      ├── {userId1}/
      │   ├── lido: true
      │   ├── ocultado: false
      │   ├── dataLeitura: Timestamp
      │   └── dataOcultacao: null
      └── {userId2}/
          ├── lido: false
          ├── ocultado: false
          ├── dataLeitura: null
          └── dataOcultacao: null

notificacoes_ead/{notificacaoId}/
  ├── [campos da notificação]
  └── user_states/
      └── {userId}/
          ├── lido: true/false
          ├── ocultado: true/false
          ├── dataLeitura: Timestamp
          └── dataOcultacao: Timestamp
```

### Modelo UserNotificationState

```dart
class UserNotificationState {
  final String userId;
  final bool lido;
  final bool ocultado;
  final DateTime? dataLeitura;
  final DateTime? dataOcultacao;
}
```

## 📋 Mudanças nos Arquivos

### 1. Novo Modelo
- **`lib/domain/models/user_notification_state.dart`** (NOVO)
  - Modelo para estado de notificação por usuário
  - Métodos: `marcarComoLida()`, `marcarComoOcultada()`

### 2. Service Atualizado
- **`lib/data/services/notificacao_ead_service.dart`**
  - `marcarComoLida()`: Agora cria/atualiza user_state ao invés de campo global
  - `marcarTodasComoLidas()`: Itera notificações e cria user_state para cada uma
  - `ocultarNotificacao()` (NOVO): Marca notificação como ocultada sem deletar
  - `getNotificacoesByUsuario()`: Filtra notificações ocultadas
  - `streamNotificacoesByUsuario()`: Filtra notificações ocultadas em tempo real

### 3. Repository Atualizado
- **`lib/data/repositories/notificacoes_repository.dart`**
  - `getNotificacoesUnificadas()`: Busca user_states para ambas collections
  - `marcarComoLida()`: Suporta ambas collections (EAD + Legacy)
  - `removerNotificacao()`: Oculta ao invés de deletar
  - `_marcarComoLidaLegacy()` (NOVO): Marca como lida em notifications
  - `_ocultarNotificacaoLegacy()` (NOVO): Oculta notificação em notifications

### 4. UnifiedNotification Atualizado
- **`lib/domain/models/unified_notification.dart`**
  - `fromLegacy()`: Aceita parâmetro `lido` para estado do usuário

## 🔄 Fluxo de Operações

### Marcar como Lida

```dart
// Usuário clica em "marcar como lida"
await notificacoesRepository.marcarComoLida(notificacaoId);

// Internamente:
1. Busca user_state atual (ou cria novo)
2. Atualiza para lido: true, dataLeitura: now()
3. Salva em: notificacoes_ead/{id}/user_states/{userId}
4. Decrementa contador do usuário
```

### Deletar Notificação

```dart
// Usuário clica em "deletar"
await notificacoesRepository.removerNotificacao(notificacaoId);

// Internamente:
1. Marca como ocultado: true, dataOcultacao: now()
2. Salva em: notificacoes_ead/{id}/user_states/{userId}
3. Notificação permanece no Firestore para outros usuários
```

### Listar Notificações

```dart
// App lista notificações
final notificacoes = await notificacoesRepository.getNotificacoesUnificadas();

// Internamente:
1. Busca notificações de ambas collections
2. Para cada uma, busca user_state do usuário
3. Filtra notificações com ocultado: true
4. Retorna com campo lido baseado no user_state
```

## 🎨 Vantagens do Sistema

### ✅ Isolamento por Usuário
- Cada usuário tem seu próprio estado de leitura/ocultação
- Ações de um usuário não afetam outros

### ✅ Notificações Globais Suportadas
- Uma notificação pode ser enviada para múltiplos usuários
- Cada um tem controle independente sobre ela

### ✅ Histórico Mantido
- Notificações não são deletadas, apenas ocultadas
- Possível implementar "desfazer" ou "mostrar ocultas"
- Auditoria de quando cada usuário leu/ocultou

### ✅ Compatibilidade com Web Admin
- Web admin cria notificações normalmente
- Sistema mobile adiciona user_states conforme necessário
- Não requer mudanças no web admin

## 📊 Collections Suportadas

### 1. `notificacoes_ead` (EAD - Tickets/Discussões)
- Criadas pelo app mobile quando há:
  - Nova resposta em ticket
  - Nova resposta em discussão
  - Ticket resolvido
  - Discussão marcada como resolvida

### 2. `notifications` (Meditações - Push Notifications)
- Criadas pelo web admin
- Enviadas via Firebase Cloud Messaging
- Agora suportam estado de leitura por usuário

## 🔮 Funcionalidades Futuras Possíveis

1. **Desfazer Ocultação**: Permitir usuário "restaurar" notificações ocultadas
2. **Estatísticas**: Taxa de leitura, tempo médio até leitura
3. **Limpeza Automática**: Remover user_states muito antigos
4. **Notificações Lidas em Outro Dispositivo**: Sincronização via user_states

## 🚀 Como Usar

### Para Desenvolvedores

```dart
// Marcar como lida
final repository = Provider.of<NotificacoesRepository>(context, listen: false);
await repository.marcarComoLida(notificacao.id);

// Ocultar/Deletar
await repository.removerNotificacao(notificacao.id);

// Listar (já filtra ocultadas)
final notificacoes = await repository.getNotificacoesUnificadas();
```

### Para Usuários Finais

1. **Ver Notificações**: App mostra apenas notificações não ocultadas
2. **Marcar como Lida**: Notificação some do contador de "não lidas"
3. **Deletar**: Notificação some da lista (mas permanece para outros)
4. **Reabrir App**: Notificações já lidas permanecem como lidas

## ⚠️ Notas Importantes

### Migração de Dados Antiga
- Notificações criadas ANTES desta implementação não têm user_states
- Sistema trata ausência de user_state como "não lida, não ocultada"
- User_states são criados sob demanda quando usuário interage

### Performance
- Cada listagem busca user_states: `N notificações × 1 busca = N leituras`
- Considerar cache local se houver problemas de performance
- Índices do Firestore podem melhorar queries

### Firestore Rules
Necessário adicionar regras para permitir read/write em user_states:

```javascript
match /notifications/{notificationId}/user_states/{userId} {
  allow read, write: if request.auth.uid == userId;
}

match /notificacoes_ead/{notificacaoId}/user_states/{userId} {
  allow read, write: if request.auth.uid == userId;
}
```

## 📝 Checklist de Implementação

- [x] Criar modelo `UserNotificationState`
- [x] Atualizar `NotificacaoEadService` com user_states
- [x] Atualizar `NotificacoesRepository` para ambas collections
- [x] Modificar `UnifiedNotification.fromLegacy()` para aceitar lido
- [x] Implementar `marcarComoLida()` para ambas collections
- [x] Implementar `ocultarNotificacao()` ao invés de deletar
- [x] Filtrar notificações ocultadas nas queries
- [ ] Adicionar Firestore Security Rules
- [ ] Testar com dados reais
- [ ] Monitorar performance
