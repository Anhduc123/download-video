import 'dart:io';

import 'package:flutter/material.dart';
import 'package:likeetube/helpers/types.dart';

class LikeeProvider extends ChangeNotifier {
  List<VideoData> _videos;

  // ignore: unnecessary_getters_setters
  List<VideoData> get videos => _videos;

  // ignore: unnecessary_getters_setters
  set videos(List<VideoData> vids) => _videos = vids;

  void deleteVideo(VideoData video) {
    try {
      File(video.localVideo.filePath).delete();
      _videos.remove(video);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
