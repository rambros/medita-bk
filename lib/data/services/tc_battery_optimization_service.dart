import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BatteryIssueType {
  none,
  standardOptimization,
  samsungFreecess,
}

class TcBatteryOptimizationService {
  static const _channel = MethodChannel('app.brahmakumaris.meditabk/battery');
  static const _prefKeyDismissed = 'tc_battery_opt_permanently_dismissed';

  Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _channel.invokeMethod<bool>(
            'isIgnoringBatteryOptimizations',
          ) ??
          false;
    } catch (_) {
      return true;
    }
  }

  Future<String> getManufacturer() async {
    if (!Platform.isAndroid) return '';
    try {
      final result =
          await _channel.invokeMethod<String>('getManufacturer') ?? '';
      return result.toLowerCase();
    } catch (_) {
      return '';
    }
  }

  Future<BatteryIssueType> detectIssue() async {
    if (!Platform.isAndroid) return BatteryIssueType.none;

    final manufacturer = await getManufacturer();
    final isSamsung = manufacturer.contains('samsung');

    if (isSamsung) {
      // Samsung Freecess congela processos independente da isenção padrão.
      // Sempre mostra o dialog em Samsung para garantir que o usuário configure
      // "Apps nunca suspensos".
      return BatteryIssueType.samsungFreecess;
    }

    // Para outros fabricantes, verifica a isenção padrão do Android.
    final isIgnoring = await isIgnoringBatteryOptimizations();
    if (!isIgnoring) {
      return BatteryIssueType.standardOptimization;
    }

    // Se manufacturer veio vazio (MethodChannel falhou) e não está isento,
    // mostra dialog genérico por precaução.
    if (manufacturer.isEmpty) {
      final isIgnoringFallback = await isIgnoringBatteryOptimizations();
      if (!isIgnoringFallback) return BatteryIssueType.standardOptimization;
    }

    return BatteryIssueType.none;
  }

  Future<bool> shouldShowDialog() async {
    if (!Platform.isAndroid) return false;

    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool(_prefKeyDismissed) ?? false;
    if (dismissed) return false;

    final issue = await detectIssue();
    return issue != BatteryIssueType.none;
  }

  Future<void> requestIgnore() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('requestIgnoreBatteryOptimizations');
  }

  Future<void> openAppBatterySettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('openAppBatterySettings');
  }

  Future<void> dismissPermanently() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyDismissed, true);
  }
}
