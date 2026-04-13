# Sistema de Notificações com Badge Counter

Sistema completo de notificações do módulo EAD com contador de badge no ícone do app (estilo WhatsApp/Messages).

## 📋 Visão Geral

O sistema foi implementado seguindo o padrão **MVVM** (Model-View-ViewModel) conforme especificado no `flutter_standards.md`.

### Componentes Principais

```
lib/
├── data/
│   ├── repositories/
│   │   └── notificacoes_repository.dart        # Repository (fonte de verdade)
│   └── services/
│       ├── badge_service.dart                  # Gerencia badge do app
│       └── notificacao_ead_service.dart        # Service do Firestore (já existia)
├── domain/
│   └── models/
│       └── ead/
│           └── notificacao_ead_model.dart      # Models (já existia)
└── ui/
    └── notificacoes/
        └── notificacoes_page/
            ├── notificacoes_page.dart          # View principal
            ├── view_model/
            │   └── notificacoes_view_model.dart # ViewModel
            └── widgets/
                ├── notificacao_card.dart        # Widget de notificação
                └── notificacoes_empty_state.dart # Estado vazio
```

## 🎯 Funcionalidades

### 1. Badge Counter no Ícone do App
- ✅ Contador vermelho no ícone (iOS e Android)
- ✅ Atualização automática em tempo real
- ✅ Remove badge quando todas notificações são lidas
- ✅ Suporta notificações em foreground e background

### 2. Página de Notificações
- ✅ Lista de todas as notificações
- ✅ Separação entre "Não Lidas" e "Anteriores"
- ✅ Pull-to-refresh
- ✅ Swipe para remover
- ✅ Navegação para conteúdo relacionado (tickets, discussões)
- ✅ Marcar todas como lidas
- ✅ Ícones e cores por tipo de notificação

### 3. Tipos de Notificação Suportados
- 📝 **Tickets**: Criado, Respondido, Resolvido, Fechado
- 💬 **Discussões**: Criada, Respondida, Resolvida
- 👍 **Interações**: Curtida, Marcada como Solução

## 🔧 Configuração

### 1. Dependências Adicionadas

```yaml
dependencies:
  flutter_app_badger: ^1.5.0  # Badge counter
```

### 2. Inicialização

O sistema é inicializado automaticamente no `main.dart`:

```dart
// Initialize badge service for notifications counter
final badgeService = BadgeService();
await badgeService.initialize();
```

### 3. Rota Configurada

Rota adicionada em `lib/routing/nav.dart`:

```dart
FFRoute(
  name: 'notificacoes',
  path: 'notificacoes',
  requireAuth: true,
  builder: (context, params) => const NotificacoesPage(),
),
```

Para navegar:
```dart
context.push('/notificacoes');
```

## 📱 Como Usar

### Acessar Página de Notificações

```dart
// Navegação simples
context.push('/notificacoes');

// Ou usando GoRouter
context.goNamed('notificacoes');
```

### Criar Notificação (do módulo admin)

As notificações são criadas automaticamente pelo módulo administrativo usando o `NotificacaoEadService`:

```dart
await NotificacaoEadService().criarNotificacao(
  titulo: 'Nova resposta no Ticket #123',
  conteudo: 'Admin respondeu ao seu ticket',
  tipo: TipoNotificacaoEad.ticketRespondido,
  destinatarioId: userId,
  relatedType: 'ticket',
  relatedId: ticketId,
  remetenteId: adminId,
  remetenteNome: 'Admin',
);
```

### Badge Automático

O badge é atualizado automaticamente quando:
- 📥 Nova notificação é recebida (push ou firestore)
- ✅ Usuário marca notificação como lida
- 🔄 App é aberto/ativado
- 🔥 Dados mudam no Firestore

## 🔄 Fluxo de Dados

```
Firebase Push → BadgeService.updateFromNotifications()
                      ↓
              NotificacoesRepository
                      ↓
              NotificacaoEadService (Firestore)
                      ↓
              Stream<Contador> → BadgeService
                      ↓
              flutter_app_badger → Badge no ícone
```

## 🎨 UI/UX

### Cores por Tipo
- 🔵 **Tickets**: Azul (criado), Laranja (respondido), Verde (resolvido), Cinza (fechado)
- 🟣 **Discussões**: Roxo (criada), Teal (respondida), Verde (resolvida)
- 🌸 **Interações**: Rosa (curtida), Âmbar (solução)

### Estados da Interface
- ⏳ **Loading**: Spinner centralizado
- ❌ **Erro**: Mensagem com botão "Tentar novamente"
- 📭 **Vazio**: Ícone grande com mensagem amigável
- 📋 **Lista**: Notificações organizadas com badges

## 🔐 Permissões

### iOS (Info.plist)
Nenhuma permissão adicional necessária para badges.

### Android (AndroidManifest.xml)
```xml
<!-- Badge counter support -->
<uses-permission android:name="com.android.launcher.permission.BADGE"/>
```

## 📊 Firestore Collections

> **📝 Nota:** As collections foram renomeadas em Dezembro/2024:
> - `notificacoes_ead` → `ead_push_notifications` (Push notifications EAD)
> - `notificacoes` → `in_app_notifications` (Notificações in-app)
> - `notifications` → `global_push_notifications` (Push notifications globais)

### `in_app_notifications` (Notificações In-App)
```javascript
{
  titulo: string,
  corpo: string,
  tipo: string,            // 'ticket_resposta', 'discussao_resposta', etc.
  destinatarioId: string,  // UID do usuário
  dados: {
    ticketId: string?,
    ticketNumero: number?,
    mensagemId: string?
  },
  dataCriacao: timestamp,
  lida: boolean
}
```

### `ead_push_notifications` (Push Notifications EAD)
```javascript
{
  titulo: string,
  mensagem: string,
  destinatarioTipo: string,  // 'Todos', 'Curso', 'Grupo'
  cursoId: string?,
  grupoId: string?,
  status: string,
  dataAgendamento: timestamp?,
  dataCriacao: timestamp
}
```

### `global_push_notifications` (Push Notifications Globais)
```javascript
{
  title: string,
  content: string,
  imagemUrl: string?,
  typeRecipients: string,  // 'Todos', 'Específicos'
  recipientsRef: array?,
  status: string,
  dataEnvio: timestamp
}
```

### `contadores_comunicacao`
```javascript
{
  [userId]: {
    ticketsNaoLidos: number,
    discussoesNaoLidas: number,
    totalNaoLidas: number,
    ultimaAtualizacao: timestamp
  }
}
```

## 🧪 Testando

### Testar Badge
```dart
// Atualizar badge manualmente
BadgeService().updateBadge(5);

// Remover badge
BadgeService().removeBadge();

// Atualizar de notificações
BadgeService().updateFromNotifications();
```

### Testar Notificação
1. Criar notificação pelo admin
2. Verificar badge no ícone do app
3. Abrir página de notificações
4. Verificar se notificação aparece
5. Clicar e verificar navegação
6. Marcar como lida
7. Verificar que badge diminui

## 🚀 Próximos Passos (Opcional)

- [ ] Filtros por tipo de notificação
- [ ] Busca em notificações
- [ ] Notificações agrupadas
- [ ] Configurações de notificação
- [ ] Som/vibração customizada
- [ ] Notificações programadas

## 📝 Notas Importantes

1. **Badge suportado apenas em iOS e Android** (não funciona na web)
2. **Atualização automática** via streams do Firestore
3. **Segue padrão MVVM** conforme flutter_standards.md
4. **Repository pattern** para desacoplamento
5. **State management** com Provider/ChangeNotifier

## 🐛 Troubleshooting

### Badge não aparece
- Verificar se o dispositivo suporta: `FlutterAppBadger.isAppBadgeSupported()`
- Verificar permissões no AndroidManifest.xml
- Reiniciar app após instalar

### Notificações não aparecem
- Verificar autenticação do usuário
- Verificar regras do Firestore
- Verificar `destinatarioId` na notificação

### Badge não atualiza automaticamente
- Verificar se BadgeService foi inicializado no main.dart
- Verificar conexão com Firebase
- Verificar logs: `BadgeService: Badge atualizado para X`

---

**Desenvolvido seguindo**: `flutter_standards.md` - Arquitetura MVVM com Clean Architecture

