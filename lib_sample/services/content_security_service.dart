import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/app_settings_model.dart';
import 'package:lms_app/providers/app_settings_provider.dart';
import 'package:lms_app/utils/toasts.dart';
import 'package:screen_protector/screen_protector.dart';


class ContentSecurityService {
  initContentSecurity(WidgetRef ref) {
    final settings = ref.read(appSettingsProvider);
    final bool contentSecurity = settings?.contentSecurity ?? false;
    if (contentSecurity && settings?.license == LicenseType.extended) {
      _preventScreenshotOn();
      _checkScreenRecording();
    }
  }

  disposeContentSecurity() {
    _preventScreenshotOff();
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();
    if (isRecording) {
      openToast('Screen recording......');
    }
  }

  void _preventScreenshotOn() async => await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async => await ScreenProtector.preventScreenshotOff();
}
