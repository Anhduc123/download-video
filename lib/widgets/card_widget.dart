import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';
import 'package:likeetube/services/StorageService.dart';
import 'package:likeetube/services/likeeService.dart';
import 'package:video_player/video_player.dart';

class CardWidget extends StatelessWidget {
  final LikeeProvider likeeProvider;
  final GlobalProvider globalProvider;

  CardWidget({
    @required this.likeeProvider,
    @required this.globalProvider,
  });

  @override
  Widget build(BuildContext context) {
    Flushbar downloadDialog;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBoxResponsive(
          height: 40,
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: TextResponsive(
            "Ready to download",
            style: TextStyle(fontSize: 60, fontFamily: 'GiloryL'),
          ),
        ),
        SizedBoxResponsive(
          height: 60,
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: FutureBuilder<VideoInfo>(
              future: LikeeService.getVideoInfo(globalProvider.likeeUrl),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (globalProvider.videoPlayerController == null) {
                    globalProvider.videoPlayerController =
                        VideoPlayerController.network(snapshot.data.url);
                    globalProvider.videoPlayerController.setLooping(true);
                  }

                  return Row(
                    children: [
                      //Image thumbnail
                      ContainerResponsive(
                        height: 600,
                        width: 380,
                        heightResponsive: true,
                        widthResponsive: true,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Stack(
                          children: [
                            if (globalProvider.videoPlayerController != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FutureBuilder(
                                    future: globalProvider.videoPlayerController
                                        .initialize(),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                          ConnectionState.done) {
                                        if (globalProvider
                                                .videoPlayerController !=
                                            null) {
                                          return VideoPlayer(globalProvider
                                              .videoPlayerController);
                                        } else
                                          return Container();
                                      } else {
                                        return Center(
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                child: CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    strokeWidth: 3,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            globalProvider
                                                                .appConfig
                                                                .mainColor))));
                                      }
                                    }),
                              ),
                            if (globalProvider.videoPlayerController != null)
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    child: Center(child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                      return IconButton(
                                        icon: Icon(
                                          globalProvider.videoPlayerController
                                                  .value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: globalProvider
                                              .appConfig.mainColor,
                                        ),
                                        onPressed: () async {
                                          if (globalProvider
                                              .videoPlayerController
                                              .value
                                              .isPlaying) {
                                            globalProvider.videoPlayerController
                                                .pause();
                                          } else {
                                            globalProvider.videoPlayerController
                                                .play();
                                          }
                                          setState(() {});
                                        },
                                      );
                                    })),
                                  ))
                          ],
                        ),
                      ),
                      SizedBoxResponsive(
                        width: 30,
                      ),
                      //username and buttons
                      ContainerResponsive(
                        height: 600,
                        width: 400,
                        widthResponsive: true,
                        heightResponsive: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextResponsive(
                              snapshot.data.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Gilory',
                              ),
                            ),
                            SizedBoxResponsive(
                              height: 20,
                            ),
                            Flexible(
                              child: TextResponsive(
                                'Likes Count : ${snapshot.data.likeCount}\nPlays Count : ${snapshot.data.playCount}\nComments Count : ${snapshot.data.commentCount}\nShares Count : ${snapshot.data.shareCount}',
                                maxLines: 9,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'GiloryL',
                                  height: 1.5,
                                ),
                              ),
                            ),

                            SizedBoxResponsive(
                              height: 65,
                            ),
                            //Download video
                            ContainerResponsive(
                              width: 380,
                              widthResponsive: true,
                              height: 120,
                              heightResponsive: true,
                              child: FlatButton.icon(
                                splashColor: globalProvider.appConfig.textColor
                                    .withOpacity(0.2),
                                label: TextResponsive(
                                  "Download video",
                                  style: TextStyle(
                                    color: globalProvider.appConfig.textColor,
                                    fontFamily: 'Gilory',
                                    fontSize: 30,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: globalProvider
                                            .appConfig.mainColor)),
                                color: globalProvider.appConfig.mainColor,
                                textColor: globalProvider.appConfig.mainColor,
                                padding: EdgeInsets.all(8),
                                onPressed: () async {
                                  await globalProvider.admobService
                                      .showRewardAd();
                                  final dir =
                                      await StorageService.initStorage();
                                  LikeeService.downloadFile(
                                      url: snapshot.data.thumbnail,
                                      dir: '$dir/thumbnails',
                                      filename:
                                          '${snapshot.data.username}_${snapshot.data.postId}.jpg',
                                      downloadProgress:
                                          globalProvider.downloadProgress,
                                      downloadingVideo: false);
                                  LikeeService.downloadFile(
                                      url: snapshot.data.url,
                                      dir: dir,
                                      filename:
                                          '${snapshot.data.username}_${snapshot.data.postId}.mp4',
                                      downloadProgress:
                                          globalProvider.downloadProgress,
                                      downloadingVideo: true);
                                  //! Download Function
                                  // globalProvider.dbService
                                  //     .saveVideo(snapshot.data);

                                  downloadDialog = Flushbar(
                                    titleText: Row(
                                      children: [
                                        Text(
                                          "Downloading",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Gilory',
                                              color: globalProvider
                                                  .appConfig.textColor),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        StreamBuilder<double>(
                                            stream: globalProvider
                                                .downloadProgress.stream,
                                            initialData: 0.0,
                                            builder: (context, snap) {
                                              if (snap.data == 100.0) {
                                                downloadDialog..dismiss();
                                                globalProvider.dbService
                                                    .saveVideo(snapshot.data);
                                              }
                                              return Text(
                                                snap.data.toInt().toString() +
                                                    '%',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Gilory',
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                    messageText: StreamBuilder<double>(
                                        stream: globalProvider
                                            .downloadProgress.stream,
                                        initialData: 0.0,
                                        builder: (context, snapshot) {
                                          return LinearProgressIndicator(
                                            value: snapshot.data / 100,
                                            backgroundColor: globalProvider
                                                .appConfig.mainColor
                                                .withOpacity(0.5),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    globalProvider
                                                        .appConfig.mainColor),
                                          );
                                        }),
                                    flushbarPosition: FlushbarPosition.TOP,
                                    flushbarStyle: FlushbarStyle.FLOATING,
                                    reverseAnimationCurve: Curves.decelerate,
                                    forwardAnimationCurve: Curves.elasticOut,
                                    backgroundColor: globalProvider
                                        .appConfig.backgroundColor,
                                    margin: EdgeInsets.all(8),
                                    borderRadius: 10,
                                    isDismissible: true,
                                  );
                                  downloadDialog.show(context);
                                },
                                icon: ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.file_download,
                                      color: globalProvider.appConfig.textColor,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: ContainerResponsive(
                      height: 600,
                      heightResponsive: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      globalProvider.appConfig.mainColor))),
                        ],
                      ),
                    ),
                  );
                }
              }),
        ),
        SizedBoxResponsive(
          height: 60,
        ),
      ],
    );
  }
}
