import 'package:flutter/material.dart';

class VideoInfo {
  String url;
  String postId;
  String thumbnail;
  String username;
  int statusCode;
  String likeCount;
  String playCount;
  String commentCount;
  String shareCount;
  VideoInfo({
    this.url,
    this.postId,
    this.thumbnail,
    this.username,
    this.statusCode,
    this.likeCount,
    this.playCount,
    this.commentCount,
    this.shareCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'postId': postId,
      'thumbnail': thumbnail,
      'username': username,
      'statusCode': statusCode,
      'likeCount': likeCount,
      'playCount': playCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
    };
  }

  factory VideoInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return VideoInfo(
      url: map['url'],
      postId: map['postId'],
      thumbnail: map['thumbnail'],
      username: map['username'],
      statusCode: map['statusCode'],
      likeCount: map['likeCount'],
      playCount: map['playCount'],
      commentCount: map['commentCount'],
      shareCount: map['shareCount'],
    );
  }
}

class LocalVideo {
  String filePath;
  String thumbnailPath;
  LocalVideo({
    this.filePath,
    this.thumbnailPath,
  });
}

class VideoData {
  LocalVideo localVideo;
  VideoInfo videoInfo;
  VideoData({this.localVideo, this.videoInfo});
}

enum CheckingStatus { Done, Checking, Validate }

class AppConfig {
  final String appTitle;
  final String smallDescription;
  final Color mainColor;
  final Color backgroundColor;
  final Color textColor;
  final Color cardColor;
  final String admobAppID;
  final String admobBannerId;
  final String admobRewardId;
  final String admobInterstitialAdId;
  final AdmobPercentage admobPercentage;
  AppConfig(
      {this.appTitle,
      this.smallDescription,
      this.mainColor,
      this.backgroundColor,
      this.cardColor,
      this.textColor,
      this.admobAppID,
      this.admobBannerId,
      this.admobRewardId,
      this.admobInterstitialAdId,
      this.admobPercentage});

  Map<String, dynamic> toMap() {
    return {
      'appTitle': appTitle,
      'smallDescription': smallDescription,
      'mainColor': mainColor,
      'backgroundColor': backgroundColor,
      'cardColor': cardColor,
      'textColor': textColor,
      'admobAppID': admobAppID,
      'admobBannerId': admobBannerId,
      'admobRewardId': admobRewardId,
      'admobInterstitialAdId': admobInterstitialAdId,
      'admobPercentage': admobPercentage?.toMap(),
    };
  }

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppConfig(
        appTitle: map['appTitle'],
        smallDescription: map['smallDescription'],
        mainColor: Color(map['mainColor']),
        backgroundColor: Color(map['backgroundColor']),
        textColor: Color(map['textColor']),
        cardColor: Color(map['cardColor']),
        admobAppID: map['admobAppID'],
        admobBannerId: map['admobBannerId'],
        admobRewardId: map['admobRewardId'],
        admobInterstitialAdId: map['admobInterstitialAdId'],
        admobPercentage: AdmobPercentage.fromMap(map['admobPercentage']));
  }
}

class AdmobPercentage {
  final int rewardAdPercentage;
  final int interstitialAdPercentage;
  AdmobPercentage({
    this.rewardAdPercentage,
    this.interstitialAdPercentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'rewardAdPercentage': rewardAdPercentage,
      'interstitialAdPercentage': interstitialAdPercentage,
    };
  }

  factory AdmobPercentage.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AdmobPercentage(
      rewardAdPercentage: map['rewardAdPercentage'],
      interstitialAdPercentage: map['interstitialAdPercentage'],
    );
  }
}
