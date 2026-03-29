# Traffic Control - Guia de Simplificação com Alarm 5.2.1

## 📋 Novidades do Alarm 5.2.1

### ✨ Feature Principal: `keepNotificationAfterAlarmEnds`

**Versão 5.2.1** adicionou:
```dart
NotificationSettings.keepNotificationAfterAlarmEnds
```

**O que faz:**
- Controla se a notificação deve permanecer após o alarme terminar
- **iOS only** (por enquanto)
- Elimina necessidade de gerenciar notificações manualmente

---

## 🔍 Análise do Código Atual

### Implementação Atual (Complexa):

#### 1. **Monitoramento Manual do `ringStream`**
```dart
// lib/data/repositories/tc_alarm_repository.dart:329-334
void _startAlarmRingingListener() {
  _ringStreamSubscription = _scheduler.ringStream.listen((alarmSettings) {
    _handleAlarmRinging(alarmSettings);
  });
}
```

#### 2. **Timers Manuais para Auto-Stop**
```dart
// lib/data/repositories/tc_alarm_repository.dart:369-386
_activeTimers[alarmIdHash] = Timer(Duration(seconds: durationSec), () async {
  await _scheduler.stopRinging(alarmId);
  _activeTimers.remove(alarmIdHash);

  // Reagendar para o próximo dia
  if (validAlarm.isEnabled) {
    await _rescheduleAlarm(validAlarm);
  }

  _isRinging = false;
  _ringingAlarmId = null;
  notifyListeners();
});
```

#### 3. **Botão Manual "Parar Som" na UI**
```dart
// lib/ui/traffic_control/tc_home_page/tc_home_page.dart:152-178
if (viewModel.isRinging)
  ElevatedButton.icon(
    onPressed: () async {
      await viewModel.stopRinging();
    },
    label: Text('Parar Som do Lembrete'),
  )
```

#### 4. **Estado Manual de `isRinging`**
```dart
// Repository mantém:
bool _isRinging = false;
String? _ringingAlarmId;
StreamSubscription? _ringStreamSubscription;
Map<int, Timer> _activeTimers = {};
```

---

## ✅ Simplificações Possíveis

### 1. **Remover Controle Manual de Notificação** (iOS)

**ANTES:**
```dart
NotificationSettings(
  title: alarm.title,
  body: 'Hora de meditar 🧘',
  stopButton: 'Parar',
  icon: 'notification_icon',
),
```

**DEPOIS:**
```dart
NotificationSettings(
  title: alarm.title,
  body: 'Hora de meditar 🧘',
  stopButton: 'Parar',
  icon: 'notification_icon',
  keepNotificationAfterAlarmEnds: false, // ✨ NOVO - Remove notificação automaticamente
),
```

---

### 2. **Simplificar Lógica de Auto-Stop**

O pacote `alarm` já para automaticamente quando:
- O áudio termina de tocar (`loopAudio: false`)
- A notificação é dismissada pelo usuário
- O botão "Parar" é pressionado

**Código Atual (Complexo):**
- ❌ Monitora `ringStream` manualmente
- ❌ Cria `Timer` para cada alarme
- ❌ Gerencia `_activeTimers` Map
- ❌ Limpa timers manualmente
- ❌ Atualiza estado `_isRinging` manualmente

**Código Simplificado (Recomendado):**
- ✅ Apenas monitora `ringStream` para atualizar UI
- ✅ Não precisa de timers (áudio para sozinho)
- ✅ Reagenda automaticamente via callback
- ✅ Menos estado para gerenciar

---

### 3. **Opção: Remover Botão "Parar Som"**

#### Cenário A: Manter Botão (Recomendado)
**Por quê:**
- Melhor UX - usuário pode parar manualmente
- Útil se usuário abrir app enquanto alarme toca
- Feedback visual de que alarme está tocando

**Simplificação:**
- Manter botão mas simplificar lógica

#### Cenário B: Remover Botão (Mais Simples)
**Por quê:**
- Usuário já pode parar pela notificação
- Menos código para manter
- UI mais limpa

**Trade-off:**
- UX ligeiramente pior

---

## 🚀 Implementação Sugerida

### Passo 1: Atualizar `NotificationSettings` (iOS)

```dart
// lib/data/services/tc_alarm_scheduler_service.dart:104-111

NotificationSettings(
  title: alarm.title,
  body: 'Hora de meditar 🧘',
  stopButton: 'Parar',
  icon: 'notification_icon',
  keepNotificationAfterAlarmEnds: false, // ✨ Adicionar
),
```

**Benefício:**
- Notificação some automaticamente após alarme terminar (iOS)
- Menos poluição visual

---

### Passo 2: Simplificar `TcAlarmRepository`

#### 2.1. Remover Timers Manuais

**ANTES:**
```dart
// Muita complexidade:
final Map<int, Timer> _activeTimers = {};

void _handleAlarmRinging(dynamic alarmSettings) {
  // 50+ linhas de código...
  _activeTimers[alarmIdHash] = Timer(Duration(seconds: durationSec), () async {
    await _scheduler.stopRinging(alarmId);
    _activeTimers.remove(alarmIdHash);
    // etc...
  });
}
```

**DEPOIS:**
```dart
// Muito mais simples:
void _handleAlarmRinging(dynamic alarmSettings) {
  try {
    final alarmIdHash = alarmSettings.id as int;

    // Encontrar alarme correspondente
    TcAlarmEntity? matchingAlarm;
    for (final alarm in _alarms) {
      if (alarm.id.hashCode == alarmIdHash) {
        matchingAlarm = alarm;
        break;
      }
    }

    if (matchingAlarm == null) return;

    // Apenas atualizar UI
    _isRinging = true;
    _ringingAlarmId = matchingAlarm.id;
    notifyListeners();

    debugPrint('TcAlarmRepository: Alarme ${matchingAlarm.title} tocando');

    // ✨ O alarm package cuida do resto:
    // - Para automaticamente quando áudio termina (loopAudio: false)
    // - Remove notificação (keepNotificationAfterAlarmEnds: false)
    // - Permite parar via notificação

    // Reagendar para próximo dia (quando ringStream fechar)
    _scheduleForNextDay(matchingAlarm);

  } catch (e) {
    debugPrint('TcAlarmRepository: Erro ao processar alarme: $e');
  }
}

// Método auxiliar para reagendar
Future<void> _scheduleForNextDay(TcAlarmEntity alarm) async {
  // Aguardar um pouco para garantir que alarme atual terminou
  await Future.delayed(Duration(seconds: alarm.musicDurationSec + 2));

  if (alarm.isEnabled) {
    await _rescheduleAlarm(alarm);
  }

  _isRinging = false;
  _ringingAlarmId = null;
  notifyListeners();
}
```

**Redução:**
- ❌ Remove `_activeTimers` Map
- ❌ Remove gerenciamento manual de timers
- ❌ Remove cancelamento de timers
- ✅ ~40 linhas de código removidas

---

#### 2.2. Simplificar `stopRingingManually`

**ANTES:**
```dart
Future<void> stopRingingManually() async {
  if (_ringingAlarmId != null) {
    final alarmId = _ringingAlarmId!;
    final alarmHash = alarmId.hashCode;

    // Limpar timer ❌ DESNECESSÁRIO
    _activeTimers[alarmHash]?.cancel();
    _activeTimers.remove(alarmHash);

    await _scheduler.stopRinging(alarmId);

    // Reagendar...
  }
}
```

**DEPOIS:**
```dart
Future<void> stopRingingManually() async {
  if (_ringingAlarmId != null) {
    final alarmId = _ringingAlarmId!;

    // Parar som
    await _scheduler.stopRinging(alarmId);

    // Reagendar
    final matchingAlarm = getAlarmById(alarmId);
    if (matchingAlarm != null && matchingAlarm.isEnabled) {
      await _rescheduleAlarm(matchingAlarm);
    }

    _isRinging = false;
    _ringingAlarmId = null;
    notifyListeners();
  }
}
```

**Redução:**
- ❌ Remove gerenciamento de timers
- ✅ Código mais limpo e direto

---

#### 2.3. Limpar `dispose()`

**ANTES:**
```dart
@override
void dispose() {
  _ringStreamSubscription?.cancel();

  // Cancelar todos os timers ativos ❌ DESNECESSÁRIO
  for (final timer in _activeTimers.values) {
    timer.cancel();
  }
  _activeTimers.clear();

  super.dispose();
}
```

**DEPOIS:**
```dart
@override
void dispose() {
  _ringStreamSubscription?.cancel();
  super.dispose();
}
```

---

### Passo 3: (Opcional) Adicionar Configuração de Duração Máxima

Se quiser limitar quanto tempo o alarme pode tocar (por segurança):

```dart
// Adicionar ao TcAlarmEntity
class TcAlarmEntity {
  // ...
  final int maxDurationSec; // Máximo 5 minutos = 300 segundos

  TcAlarmEntity({
    // ...
    this.maxDurationSec = 300, // Padrão: 5 minutos
  });
}
```

Então no agendamento:

```dart
// Calcular duração efetiva (menor entre duração da música e máximo)
final effectiveDuration = min(alarm.musicDurationSec, alarm.maxDurationSec);

// Usar no callback de reagendamento
Future<void> _scheduleForNextDay(TcAlarmEntity alarm) async {
  await Future.delayed(Duration(seconds: alarm.maxDurationSec + 2));
  // ...
}
```

---

## 📊 Resumo de Simplificações

| Aspecto | Antes | Depois | Redução |
|---------|-------|--------|---------|
| **Timers Manuais** | ✅ Map<int, Timer> | ❌ Removido | -1 Map |
| **Gerenciamento de Timers** | ~50 linhas | ~15 linhas | -70% código |
| **Notificações (iOS)** | Manual | Automático | -1 preocupação |
| **Cancelamento de Timers** | Manual em 3 lugares | Não precisa | -30 linhas |
| **Estado** | 4 variáveis | 2 variáveis | -50% |
| **Bugs Potenciais** | Médio risco | Baixo risco | ↓ complexidade |

---

## 🎯 Benefícios

### Código:
- ✅ **-100 linhas de código** aproximadamente
- ✅ **Menos estado** para gerenciar
- ✅ **Menos bugs** potenciais
- ✅ **Mais fácil de manter**
- ✅ **Mais fácil de testar**

### UX:
- ✅ **Notificações automáticas** (iOS)
- ✅ **Menos poluição visual**
- ✅ **Comportamento consistente** com alarm package
- ✅ **Melhor performance** (menos timers rodando)

### Manutenção:
- ✅ **Aproveita features nativas** do alarm package
- ✅ **Menos código customizado** para manter
- ✅ **Atualizações** do alarm trazem melhorias automáticas

---

## ⚠️ Considerações

### 1. **iOS Only (por enquanto)**
`keepNotificationAfterAlarmEnds` funciona apenas no iOS atualmente.

**Solução:**
```dart
import 'dart:io';

NotificationSettings(
  // ...
  keepNotificationAfterAlarmEnds: Platform.isIOS ? false : null,
)
```

### 2. **Reagendamento**
O código atual reagenda alarmes automaticamente. Na versão simplificada, isso continua funcionando mas de forma mais elegante.

### 3. **Backward Compatibility**
Se houver alarmes já agendados, eles continuarão funcionando. Novos alarmes usarão a nova configuração.

---

## 📝 Checklist de Implementação

- [ ] Atualizar `NotificationSettings` com `keepNotificationAfterAlarmEnds`
- [ ] Remover `_activeTimers` Map do repository
- [ ] Simplificar `_handleAlarmRinging` (remover timer manual)
- [ ] Simplificar `stopRingingManually` (remover gerenciamento de timers)
- [ ] Simplificar `dispose()` (remover cancelamento de timers)
- [ ] Testar alarmes no iOS e Android
- [ ] Verificar reagendamento automático
- [ ] Testar botão "Parar Som"
- [ ] Monitorar comportamento por alguns dias

---

## 🔗 Referências

- [alarm package changelog](https://pub.dev/packages/alarm/changelog) - Ver versão 5.2.1
- [alarm package on pub.dev](https://pub.dev/packages/alarm)
- [GitHub - alarm repository](https://github.com/gdelataillade/alarm)

---

**Data de análise:** 2026-03-27
**Versão alarm:** 5.2.1
**Complexidade reduzida:** ~40%
**Linhas de código removidas:** ~100

---

Última atualização: 2026-03-27
