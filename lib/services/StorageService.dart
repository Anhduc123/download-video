import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  static Future<PermissionStatus> requestPermission() async {
    PermissionStatus status = await storagePermissionStatus();
    if (status.isUndetermined || status.isDenied) {
      await Permission.storage.request();
      return await storagePermissionStatus();
    } else if (await Permission.storage.isRestricted ||
        await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
      return await storagePermissionStatus();
    } else {
      return await storagePermissionStatus();
    }
  }

  static Future<PermissionStatus> storagePermissionStatus() async {
    return await Permission.storage.status;
  }

  static Future<String> initStorage() async {
    String externalStoragePath = await ExtStorage.getExternalStorageDirectory();

    String path = '$externalStoragePath/likeeTube';
    String thumbPath = '$path/thumbnails';
    String noMediaFile = '$thumbPath/.nomedia';
    if (!(await Directory(path).exists())) Directory(path).create();
    if (!(await Directory(thumbPath).exists())) Directory(thumbPath).create();
    if (!(await File(noMediaFile).exists()))
      File(noMediaFile).create(recursive: true);

    return path;
  }

  static Future<List<LocalVideo>> readThumbnails(String storageFolder) async {
    List<String> thumbnailsData = [];
    List<String> videosData = [];
    final thumbnailFiles =
        Directory('$storageFolder/thumbnails').listSync().reversed.toList();
    final videoFiles = Directory(storageFolder).listSync().reversed.toList();
    videoFiles.forEach((file) {
      if (file.path.endsWith('.mp4')) {
        videosData.add(file.path);
      }
    });
    thumbnailFiles.forEach((file) {
      if (file.path.endsWith('.jpg')) {
        thumbnailsData.add(file.path);
      }
    });

    return _mapData(videosData, thumbnailsData);
  }

  static Future<List<VideoData>> readvideoStorage(
      {GlobalProvider globalProvider}) async {
    List<VideoData> data = [];
    String storageFolder = await initStorage();
    final videosInfo = await globalProvider.dbService.getSavedVideosInfo();
    final localVideos = await readThumbnails(storageFolder);
    if (videosInfo.length != 0) {
      final syncedVideosINfo = localVideos.map((e) {
        String filePath = e.filePath;
        final find = videosInfo
            .where((element) => filePath.contains(element.postId))
            .toList();
        if (find.length != 0) {
          return find[0];
        }
      }).toList();
      syncedVideosINfo.removeWhere((element) => element == null);

      for (int i = 0; i < syncedVideosINfo.length; i++) {
        //! error here  The getter 'postId' was called on null.
        String postId = syncedVideosINfo[i].postId;
        if (localVideos[i].filePath.contains(postId)) {
          data.add(VideoData(
              localVideo: localVideos[i], videoInfo: syncedVideosINfo[i]));
        }
      }
      return data;
    } else
      return [];
  }

  static List<LocalVideo> _mapData(
      List<String> files, List<String> thumbnails) {
    List<LocalVideo> newData = [];
    thumbnails.forEach((thumbPath) {
      String thumbName =
          thumbPath.split('thumbnails/')[1].replaceAll('.jpg', '');
      files.forEach((filePath) {
        if (filePath.contains(thumbName)) {
          newData.add(LocalVideo(filePath: filePath, thumbnailPath: thumbPath));
        }
      });
    });
    return newData;
  }
}
