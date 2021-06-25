import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/services/StorageService.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DbService {
  String _dbFileName = 'data.db';
  DatabaseFactory _dbFactory = databaseFactoryIo;
  DbService() {
    Future.delayed(Duration(milliseconds: 0), () async {
      await initDatabase();
    });
  }

  Database _db;
  StoreRef _savedVideos;
  // ignore: unnecessary_getters_setters
  Database get db => _db;
  // ignore: unnecessary_getters_setters
  StoreRef get savedVideos => _savedVideos;
  // ignore: unnecessary_getters_setters
  set db(Database database) => _db = database;
  // ignore: unnecessary_getters_setters
  set savedVideos(StoreRef videosRef) => _savedVideos = videosRef;

  Future initDatabase() async {
    String appDocDir = (await StorageService.initStorage());
    String dbPath = appDocDir + '/' + _dbFileName;

    _db = (await _dbFactory.openDatabase(dbPath));
    _savedVideos = intMapStoreFactory.store('saved_videos');
  }

  Future saveVideo(VideoInfo info) async {
    // final rsp = await checkVideoExistance(info.postId);
    // if (!rsp) {
    //   _db.transaction((txn) async {
    //     await _savedVideos.add(txn, info.toMap());
    //   });
    // } else {
    //   //edit info if already exist
    // }
    _db.transaction((txn) async {
      await _savedVideos.add(txn, info.toMap());
    });
  }

  Future getLocalVideo(String postId) async {
    var finder = Finder(
      filter: Filter.equals('postId', postId),
    );
    final rsp = (await (_savedVideos.find(this._db, finder: finder))).toList();
    if (rsp.length == 0) {
      return false;
    } else {
      return rsp[0].value;
    }
  }

  Future<List<VideoInfo>> getSavedVideosInfo() async {
    await initDatabase();
    final rsp = _savedVideos.query();
    final data = await rsp.getSnapshots(this._db);

    return List<VideoInfo>.from(data
        .map((item) {
          return VideoInfo.fromMap(item.value);
        })
        .toList()
        .reversed);
  }

  Future<bool> deleteVideo(String postId) async {
    Finder finder = Finder(filter: Filter.equals('postId', postId));
    int rsp = await _savedVideos.delete(this._db, finder: finder);
    if (rsp == 1) {
      return true;
    } else
      return false;
  }

  // Future<bool> checkVideoExistance(String postId) async {
  //   Finder finder = Finder(filter: Filter.equals('postId', postId));
  //   final rsp = await _savedVideos.find(this._db, finder: finder);
  //   if (rsp.length == 0) {
  //     return false;
  //   } else
  //     return true;
  // }
}
