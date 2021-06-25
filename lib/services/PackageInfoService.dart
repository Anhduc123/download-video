import 'package:package_info/package_info.dart';

class PackageInfoService {
  PackageInfoService() {
    PackageInfo.fromPlatform().then((value) {
      _packageName = value.packageName;
      _playStoreUrl =
          'https://play.google.com/store/apps/details?id=$_packageName';
    });
  }

  String _packageName;
  String _playStoreUrl;

  String get packageName => _packageName;
  String get playStoreUrl => _playStoreUrl;
}
