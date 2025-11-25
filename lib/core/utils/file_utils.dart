import 'package:package_info_plus/package_info_plus.dart';

/// File system and app metadata utilities
class FileUtils {
  /// Get the current app version
  ///
  /// Returns the version string from package info (e.g., "1.0.0").
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
