import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';
import 'package:likeetube/services/StorageService.dart';

class Librarypage extends StatelessWidget {
  final LikeeProvider likeeProvider;
  final GlobalProvider globalProvider;
  Librarypage({@required this.likeeProvider, @required this.globalProvider});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VideoData>>(
      future: StorageService.readvideoStorage(globalProvider: globalProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length != 0) {
            likeeProvider.videos = snapshot.data;
            return ListView.builder(
              padding: EdgeInsetsResponsive.only(top: 50),
              physics: BouncingScrollPhysics(),
              itemCount: likeeProvider.videos.length,
              itemBuilder: (context, i) {
                return CardLibrary(
                  videoData: likeeProvider.videos[i],
                  likeeProvider: likeeProvider,
                  globalProvider: globalProvider,
                );
              },
            );
          } else
            return Center(
              child: Text(
                'No Videos available !!!',
                style: TextStyle(
                  fontFamily: 'Gilory',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
        } else
          return Center(
            child: Text(
              'No Videos available !!!',
              style: TextStyle(
                fontFamily: 'Gilory',
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
      },
    );
  }
}
