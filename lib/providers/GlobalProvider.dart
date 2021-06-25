import 'dart:async';

import 'package:likeetube/config/config.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/services/AdmobService.dart';
import 'package:likeetube/services/DbService.dart';
import 'package:likeetube/services/PackageInfoService.dart';
import 'package:video_player/video_player.dart';

import '../helpers/global.dart';

class GlobalProvider extends ChangeNotifier {
  GlobalProvider() {
    _appConfig = AppConfig.fromMap(config);
    _admobService = AdmobService(appConfig: _appConfig);
    _packageInfo = PackageInfoService();
  }
  AdmobService _admobService;
  DbService _dbService;
  AppConfig _appConfig;
  PackageInfoService _packageInfo;
  StreamController<double> _downloadProgress = StreamController.broadcast();
  String _likeeUrl;
  CheckingStatus _checkingStatus = CheckingStatus.Validate;
  VideoInfo _videoInfo;
  VideoPlayerController _videoPlayerController;
  bool _disableDownload = false;
  // ignore: unnecessary_getters_setters
  AppConfig get appConfig => _appConfig;
  PackageInfoService get packageInfo => _packageInfo;
  AdmobService get admobService => _admobService;
  // ignore: unnecessary_getters_setters
  String get likeeUrl => _likeeUrl;
  // ignore: unnecessary_getters_setters
  DbService get dbService => _dbService;
  // ignore: unnecessary_getters_setters
  set likeeUrl(String currentUrl) => _likeeUrl = currentUrl;
  // ignore: unnecessary_getters_setters
  CheckingStatus get checkingStatus => _checkingStatus;
  // ignore: unnecessary_getters_setters
  StreamController<double> get downloadProgress => _downloadProgress;
  // ignore: unnecessary_getters_setters
  VideoPlayerController get videoPlayerController => _videoPlayerController;
  // ignore: unnecessary_getters_setters
  bool get disableDownload => _disableDownload;

  // ignore: unnecessary_getters_setters
  set checkingStatus(CheckingStatus currentStatus) =>
      _checkingStatus = currentStatus;
  // ignore: unnecessary_getters_setters
  VideoInfo get videoInfo => _videoInfo;
  // ignore: unnecessary_getters_setters
  set videoInfo(VideoInfo currentVideoInfo) => _videoInfo = currentVideoInfo;
  // ignore: unnecessary_getters_setters
  set downloadProgress(StreamController<double> progress) =>
      _downloadProgress = progress;
  // ignore: unnecessary_getters_setters
  set videoPlayerController(VideoPlayerController controller) {
    _videoPlayerController = controller;
    // notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  set disableDownload(bool value) {
    _disableDownload = value;
    notifyListeners();
  }

  Future disposeVideoPlayer() async {
    await _videoPlayerController.pause();

    await _videoPlayerController.dispose();
    _videoPlayerController = null;

    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  set dbService(DbService service) => _dbService = service;
  // ignore: unnecessary_getters_setters
  set appConfig(AppConfig config) => _appConfig = config;
}
