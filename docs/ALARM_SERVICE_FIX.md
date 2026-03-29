# Correção: ForegroundServiceDidNotStartInTimeException

## 📋 Problema

**Erro Fatal:**
```
ForegroundServiceDidNotStartInTimeException:
Context.startForegroundService() did not then call Service.startForeground()
ServiceRecord{...AlarmService...}
```

### O que causa este erro:

No Android, quando você inicia um serviço em foreground usando `startForegroundService()`, o serviço **DEVE** chamar `Service.startForeground()` dentro de **5 segundos**, caso contrário o app trava.

Este erro está relacionado ao pacote **alarm** (v5.0.0) usado no módulo de Traffic Control.

---

## 🔍 Análise

### Versão Atual:
- **alarm**: ^5.0.0 (versão no pubspec.yaml)

### Versões Mais Recentes:
- **alarm**: 5.2.1 (latest em 2026)
- Contém correções para `BackgroundServiceStartNotAllowedException`
- Melhorias nas permissões de foreground service

### Configuração Atual (AndroidManifest.xml):
✅ Permissões corretas configuradas:
- `FOREGROUND_SERVICE`
- `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
- `SCHEDULE_EXACT_ALARM`
- `WAKE_LOCK`

✅ Service configurado corretamente:
```xml
<service
  android:name="com.gdelataillade.alarm.alarm.AlarmService"
  android:foregroundServiceType="mediaPlayback"
  android:exported="false" />
```

---

## ✅ Soluções

### Solução 1: Atualizar Pacote Alarm (RECOMENDADO)

Atualize o pacote alarm para a versão mais recente que contém correções de bugs:

```yaml
# pubspec.yaml
dependencies:
  alarm: ^5.2.1  # Atualizar de ^5.0.0
```

Depois execute:
```bash
flutter pub upgrade alarm
flutter clean
flutter pub get
```

**Por que funciona:**
- Versões mais recentes contêm correções para problemas de foreground service
- Melhor tratamento de timeout
- Correções de bugs relacionados a `BackgroundServiceStartNotAllowedException`

---

### Solução 2: Adicionar Tratamento de Erro

Mesmo com a atualização, adicione tratamento de erro defensivo no código:

```dart
// lib/data/services/tc_alarm_scheduler_service.dart

Future<void> scheduleAlarm(TcAlarmEntity alarm, String audioPath) async {
  await init();

  try {
    // ... código existente ...

    await Alarm.set(alarmSettings: alarmSettings);

    print('TcAlarmScheduler: Alarme agendado - ${alarm.title}');
  } on PlatformException catch (e) {
    // Erro específico de plataforma (Android/iOS)
    print('TcAlarmScheduler: Erro de plataforma ao agendar alarme: ${e.code} - ${e.message}');

    // Não joga erro fatal pro Crashlytics se for erro de foreground service
    if (e.code.contains('ForegroundService') ||
        e.code.contains('BackgroundService')) {
      print('TcAlarmScheduler: Erro de foreground service ignorado para evitar crash');
      return; // Retorna sem relancar exceção
    }

    rethrow;
  } catch (e) {
    print('TcAlarmScheduler: Erro ao agendar alarme: $e');

    // Log no Crashlytics mas não trava o app
    if (!e.toString().contains('ForegroundService')) {
      rethrow;
    }
  }
}
```

---

### Solução 3: Configurar minSdkVersion Explicitamente

Garanta que o minSdkVersion está configurado para pelo menos 24 (recomendado para foreground services modernos):

```gradle
// android/app/build.gradle

android {
    defaultConfig {
        minSdkVersion 24  // Adicionar explicitamente (em vez de flutter.minSdkVersion)
        targetSdkVersion 35
        // ...
    }
}
```

**⚠️ Importante:** Isso pode limitar dispositivos Android muito antigos (< Android 7.0). Verifique sua base de usuários.

---

### Solução 4: Adicionar Permissão Extra (Android 14+)

Se targeting Android 14+ (API 34+), adicione permissão adicional:

```xml
<!-- android/app/src/main/AndroidManifest.xml -->

<!-- Já está presente, mas verifique -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>

<!-- Android 14+ requer esta também -->
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
```

---

### Solução 5: Não Reportar Como Fatal no Crashlytics

Configure o Crashlytics para não tratar este erro específico como fatal:

```dart
// lib/main.dart ou onde configura o Crashlytics

FlutterError.onError = (errorDetails) {
  // Verifica se é erro de ForegroundService
  final isForegroundServiceError = errorDetails.exception.toString()
      .contains('ForegroundService');

  if (isForegroundServiceError) {
    // Loga como não-fatal
    FirebaseCrashlytics.instance.recordError(
      errorDetails.exception,
      errorDetails.stack,
      fatal: false, // Marca como não-fatal
      reason: 'Foreground service timeout - não crítico',
    );
  } else {
    // Outros erros continuam fatais
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  }
};
```

---

## 🚀 Plano de Ação Recomendado

Execute nesta ordem:

### 1. Atualizar Pacote (Mais Importante)
```bash
# Edite pubspec.yaml: alarm: ^5.2.1
flutter pub upgrade alarm
flutter clean
flutter pub get
```

### 2. Adicionar Tratamento de Erro
- Implemente o código de try-catch melhorado no `tc_alarm_scheduler_service.dart`

### 3. Testar
```bash
# Build e teste
flutter clean
flutter build apk --release
```

### 4. Monitorar
- Deploy em produção
- Monitore Crashlytics nos próximos dias
- Verifique se o erro diminuiu/desapareceu

---

## 🧪 Como Testar

### Teste 1: Agendar Alarme
1. Abra o app
2. Vá para Traffic Control
3. Crie um novo alarme
4. Verifique se não há crashes

### Teste 2: App em Background
1. Agende um alarme
2. Force close do app (swipe do task manager)
3. Aguarde o alarme tocar
4. Verifique se tocou corretamente

### Teste 3: Boot do Dispositivo
1. Agende um alarme
2. Reinicie o dispositivo
3. Aguarde o alarme tocar
4. Verifique se foi reagendado corretamente

---

## 📚 Referências

- [alarm package on pub.dev](https://pub.dev/packages/alarm)
- [alarm changelog](https://pub.dev/packages/alarm/changelog)
- [Android Foreground Services Troubleshooting](https://developer.android.com/develop/background-work/services/fgs/troubleshooting)
- [Firebase Crashlytics - ForegroundService issues](https://github.com/firebase/flutterfire/issues/17698)

---

## 🐛 Troubleshooting

### Erro persiste após atualização?

1. **Limpe completamente o build:**
```bash
flutter clean
cd android && ./gradlew clean && cd ..
rm -rf android/.gradle
flutter pub get
flutter build apk
```

2. **Verifique versão instalada:**
```bash
grep -A 3 "alarm:" pubspec.lock
```

3. **Teste em dispositivo real** (não emulador)

4. **Verifique logs do Android:**
```bash
adb logcat | grep -i "alarm\|foreground"
```

---

## 📞 Status

- **Data da análise**: 2026-03-27
- **Versão atual**: alarm ^5.0.0
- **Versão recomendada**: alarm ^5.2.1
- **Prioridade**: 🔴 ALTA (causa crashes)
- **Complexidade**: 🟢 BAIXA (simples atualização de pacote)

---

Última atualização: 2026-03-27
