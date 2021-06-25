import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:share_extend/share_extend.dart';

class ShareService {
  static void shareVideo(String videoPath,
      {@required GlobalProvider globalProvider}) {
    try {
      ShareExtend.share(videoPath, 'video',
          sharePanelTitle: 'Sharing From ${globalProvider.appConfig.appTitle}',
          extraText:
              'Video downloaded from ${globalProvider.packageInfo.playStoreUrl}');
    } catch (e) {
      print(e);
    }
  }
}
