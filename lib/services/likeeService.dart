import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:likeetube/helpers/types.dart';

class LikeeService {
  static Future<VideoInfo> getVideoInfo(String url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        RegExp regExp = RegExp(r'(?<=window.data =)(.*)(?=;<)');
        final data = regExp.stringMatch(response.body.toString());
        final jsonData = jsonDecode(data);

        return VideoInfo.fromMap({
          'statusCode': response.statusCode,
          'url': jsonData['video_url'].replaceAll('_4', ''),
          'postId': jsonData['post_id'],
          'thumbnail': jsonData['image2'],
          'username': jsonData['user_name'],
          'likeCount': jsonData['like_count'].toString(),
          'playCount': jsonData['play_count'].toString(),
          'commentCount': jsonData['comment_count'].toString(),
          'shareCount': jsonData['share_count'].toString(),
        });
      } else
        return VideoInfo.fromMap({
          'statusCode': response.statusCode,
          'postId': null,
          'url': null,
          'thumbnail': null,
          'username': null,
          'likeCount': null,
          'playCount': null,
          'commentCount': null,
          'shareCount': null,
        });
    } catch (e) {
      print(e);
      return VideoInfo.fromMap({
        'statusCode': 500,
        'postId': null,
        'url': null,
        'thumbnail': null,
        'username': null,
        'likeCount': null,
        'playCount': null,
        'commentCount': null,
        'shareCount': null,
      });
    }
  }

  static bool isLikeeUrl(String url) {
    if (url.contains('l.likee.com/') || url.contains('lite.likeevideo.com/')) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getClipBoardData() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data == null) {
      return '';
    } else {
      return data.text;
    }
  }

  static void downloadFile(
      {String url,
      String filename,
      String dir,
      StreamController<double> downloadProgress,
      bool downloadingVideo}) async {
    var httpClient = http.Client();
    var request = http.Request(
      'GET',
      Uri.parse(url),
    );
    request.headers['user-agent'] = 'okhttp';
    var response = httpClient.send(request);
    List<List<int>> chunks = List();
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        double progress = downloaded / r.contentLength * 100;
        if (downloadingVideo) {
          downloadProgress.add(progress);
        }

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        double progress = downloaded / r.contentLength * 100;

        if (downloadingVideo) {
          downloadProgress.add(progress);
        }
        httpClient.close();

        File file = new File('$dir/$filename');
        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        return;
      });
    });
  }
}
