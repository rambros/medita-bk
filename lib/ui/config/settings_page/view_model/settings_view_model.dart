import 'package:flutter/material.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/core/utils/file_utils.dart';
import '/core/services/index.dart';

class SettingsViewModel extends ChangeNotifier {
  String _appVersion = '';
  String get appVersion => _appVersion;

  void initialize() {
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    _appVersion = await FileUtils.getAppVersion();
    notifyListeners();
  }

  bool get isDarkMode => AppStateStore().darkTheme;
  bool get receiveNotifications => AppStateStore().receiveNotifications;
  bool get receiveEmails => AppStateStore().receiveEmails;

  void toggleDarkMode(BuildContext context, bool value) {
    AppStateStore().darkTheme = value;
    if (value) {
      setDarkModeSetting(context, ThemeMode.dark);
    } else {
      setDarkModeSetting(context, ThemeMode.light);
    }
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    AppStateStore().receiveNotifications = value;
    notifyListeners();
  }

  void toggleEmails(bool value) {
    AppStateStore().receiveEmails = value;
    notifyListeners();
  }

  Future<void> deleteDownloads(BuildContext context) async {
    await globalAudioHandler.customAction('clearCache');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Meditações deletadas',
          style: TextStyle(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        duration: const Duration(milliseconds: 4000),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ),
    );
  }
}
