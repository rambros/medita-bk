# Guia de Diagnóstico - Alarmes Tocando em Horários Incorretos

## 🐛 Problema Reportado
Alarmes estão tocando em horários diferentes do configurado, com **pequena diferença (minutos)**.

---

## 🔍 Diagnóstico Implementado

### 1. Logs Detalhados Adicionados

#### A) No Agendamento ([tc_alarm_scheduler_service.dart](../lib/data/services/tc_alarm_scheduler_service.dart))

```dart
print('TcAlarmScheduler: ===== DEBUG AGENDAMENTO =====');
print('TcAlarmScheduler: Alarme config - ${alarm.hour}:${alarm.minute}');
print('TcAlarmScheduler: DateTime.now() = $now');
print('TcAlarmScheduler: scheduledTime calculado = $scheduledTime');
print('TcAlarmScheduler: Diferença em minutos: ${scheduledTime.difference(now).inMinutes}');
print('TcAlarmScheduler: ================================');
```

**O que verificar:**
- ✅ `Alarme config` mostra o horário correto salvo no banco
- ✅ `scheduledTime calculado` mostra quando o alarme vai tocar
- ✅ `Diferença em minutos` deve ser positiva (futuro)

#### B) No Reagendamento ([tc_alarm_repository.dart](../lib/data/repositories/tc_alarm_repository.dart))

```dart
debugPrint('TcAlarmRepository: ===== REAGENDAMENTO =====');
debugPrint('TcAlarmRepository: Alarme: ${alarm.title}');
debugPrint('TcAlarmRepository: Horário configurado: ${alarm.formattedTime}');
debugPrint('TcAlarmRepository: DateTime.now() no momento do reagendamento: ${DateTime.now()}');
debugPrint('TcAlarmRepository: ============================');
```

**O que verificar:**
- ✅ Horário configurado permanece correto após reagendamento
- ✅ Momento do reagendamento está correto (após música terminar)

### 2. Botão de Debug na UI

Um botão 🐛 foi adicionado no AppBar da página Traffic Control.

**Como usar:**
1. Abra a página "Lembretes para Meditar"
2. Toque no ícone 🐛 no canto superior direito
3. Verifique o console/logcat

**O que será impresso:**
```
========================================
DEBUG ALARMES - 2024-01-15 14:30:00.000
========================================

1. ALARMES SALVOS (4):
  - 07:00 | Meditação Matinal
    Configurado: hour=7, minute=0
    Ativo: true
    ID: abc123
    ID.hashCode: 123456789
    Dias: Todos os dias

2. ALARMES AGENDADOS NO SISTEMA:
  - ID: 123456789, Horário: 2024-01-16 07:00:00.000, Título: Meditação Matinal
========================================
```

---

## 🎯 Como Diagnosticar

### Passo 1: Verificar Alarmes Salvos vs Agendados

1. Toque no botão 🐛
2. Compare os horários:
   - **"ALARMES SALVOS"** → O que o usuário configurou
   - **"ALARMES AGENDADOS"** → O que o sistema vai tocar

**Se forem diferentes:**
- ❌ **Bug confirmado** - O agendamento está calculando errado
- 📍 Veja os logs de "DEBUG AGENDAMENTO" para identificar onde o cálculo falha

**Se forem iguais:**
- ✅ O agendamento está correto
- ❓ Problema pode ser no alarm package ou timezone do dispositivo

### Passo 2: Verificar Colisão de Hash IDs

No log, verifique se há **IDs diferentes com mesmo hashCode**:

```
Alarme A:
  ID: "abc-123"
  ID.hashCode: 999888777

Alarme B:
  ID: "xyz-789"
  ID.hashCode: 999888777  ⚠️ COLISÃO!
```

**Se houver colisão:**
- ❌ **Bug confirmado** - Dois alarmes estão usando o mesmo ID interno
- 🔧 **Solução:** Trocar `id.hashCode` por outro método de ID numérico

### Passo 3: Monitorar Logs em Tempo Real

Quando criar/editar um alarme, observe:

1. **Log de agendamento:**
   ```
   Alarme config - 10:0
   scheduledTime calculado = 2024-01-16 10:00:00.000
   ```

2. **Quando o alarme tocar:**
   ```
   TcAlarmRepository: Alarme Meditação Matinal tocando
   ```

3. **Após música terminar:**
   ```
   ===== REAGENDAMENTO =====
   Horário configurado: 10:00
   DateTime.now() no momento do reagendamento: 2024-01-15 10:05:00.000
   ```

---

## 🔧 Possíveis Causas Identificadas

### A) Colisão de Hash IDs (Mais Provável)

**Código atual:**
```dart
id: alarm.id.hashCode,  // String → int
```

**Problema:**
- Dois IDs String diferentes podem gerar mesmo hashCode int
- Quando isso acontece, um alarme "sobrescreve" o outro no alarm package

**Solução:**
```dart
// Opção 1: Usar ID numérico desde o início
id: int.parse(alarm.id),

// Opção 2: Usar hash mais robusto
id: alarm.id.codeUnits.fold(0, (prev, curr) => prev + curr),

// Opção 3: Usar timestamp + índice
id: DateTime.now().millisecondsSinceEpoch + index,
```

### B) Problema de Timezone (Menos Provável)

**Código atual:**
```dart
final now = DateTime.now();  // Usa timezone local
```

**Problema:**
- Se o usuário mudar timezone do dispositivo
- Se houver horário de verão

**Solução:**
```dart
final now = DateTime.now().toLocal();  // Explicitamente local
```

### C) Race Condition no Reagendamento (Improvável)

**Problema:**
- Múltiplos alarmes tocando simultaneamente
- Reagendamentos concorrentes

**Solução:**
- Adicionar lock/mutex nos métodos de reagendamento

---

## 📝 Próximos Passos

1. ✅ **Execute o app** com as alterações
2. ✅ **Toque no botão 🐛** para ver os logs
3. ✅ **Configure um alarme** para daqui a 2 minutos
4. ✅ **Aguarde tocar** e observe os logs
5. 📸 **Tire prints** dos logs e compartilhe

---

## 🔗 Arquivos Modificados

- [lib/data/services/tc_alarm_scheduler_service.dart](../lib/data/services/tc_alarm_scheduler_service.dart) - Logs de agendamento
- [lib/data/repositories/tc_alarm_repository.dart](../lib/data/repositories/tc_alarm_repository.dart) - Logs de reagendamento
- [lib/ui/traffic_control/tc_home_page/tc_home_page.dart](../lib/ui/traffic_control/tc_home_page/tc_home_page.dart) - Botão de debug
- [lib/ui/traffic_control/tc_home_page/view_model/tc_home_view_model.dart](../lib/ui/traffic_control/tc_home_page/view_model/tc_home_view_model.dart) - Método de debug

---

## ⚠️ Importante

Este é um **debug temporário**. Após identificar a causa:
- ❌ Remover o botão 🐛 da UI
- ❌ Remover logs excessivos (manter apenas essenciais)
- ✅ Implementar a correção definitiva
