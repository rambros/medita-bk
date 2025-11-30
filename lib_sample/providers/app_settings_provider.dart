import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings_model.dart';
import '../services/firebase_service.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsData, AppSettingsModel?>((ref) {
  return AppSettingsData();
});

class AppSettingsData extends StateNotifier<AppSettingsModel?> {
  AppSettingsData() : super(null);

  Future getData() async {
    state = await FirebaseService().getAppSettingsData();
    debugPrint('Got settings data');
  }
}