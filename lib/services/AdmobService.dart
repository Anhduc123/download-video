import 'dart:math';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:likeetube/helpers/types.dart';

class AdmobService {
  final AppConfig appConfig;

  AdmobService({this.appConfig}) {
    FirebaseAdMob.instance
        .initialize(appId: appConfig.admobAppID, analyticsEnabled: true)
        .then((value) => print('Admob Init : $value'));
    bannerAd = BannerAd(
      adUnitId: appConfig.admobBannerId,
      size: AdSize.banner,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }
  final _targetingInfo = MobileAdTargetingInfo(
    testDevices: ['26EBB18819158854', '33009d5b958b2343'],
  );

  InterstitialAd _interstitialAd() {
    InterstitialAd myInterstitial = InterstitialAd(
      adUnitId: appConfig.admobInterstitialAdId,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    return myInterstitial;
  }

  BannerAd bannerAd;

  void showIntertialAd() {
    if (_isPercentage(appConfig.admobPercentage.interstitialAdPercentage)) {
      _interstitialAd()
        ..load()
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
        );
    }
  }

  Future showRewardAd() async {
    if (_isPercentage(appConfig.admobPercentage.rewardAdPercentage)) {
      await RewardedVideoAd.instance.load(
          adUnitId: appConfig.admobRewardId, targetingInfo: _targetingInfo);

      try {
        await RewardedVideoAd.instance.show();
      } catch (e) {
        print(e);
      }
    }
  }

  void showBanner() {
    bannerAd
      ..load()
      ..show(
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  void disposeBanner() async {
    try {
      bannerAd?.dispose();
      bannerAd = null;
    } catch (ex) {
      print("banner dispose error");
    }
    bannerAd = BannerAd(
      adUnitId: appConfig.admobBannerId,
      size: AdSize.banner,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  bool _isPercentage(int percentage) {
    final rn = Random();
    int results = (rn.nextDouble() * 100).toInt();
    if (results <= percentage) {
      return true;
    } else
      return false;
  }
}
