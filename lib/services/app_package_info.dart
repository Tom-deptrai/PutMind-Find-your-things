import 'package:package_info_plus/package_info_plus.dart';

/// Runtime app version/build from package metadata (`pubspec.yaml`).
class AppPackageInfo {
  const AppPackageInfo({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  static Future<AppPackageInfo> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppPackageInfo(version: info.version, buildNumber: info.buildNumber);
  }
}
