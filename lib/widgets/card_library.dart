import 'dart:io';

import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/pages/videoPlayer.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';
import 'package:likeetube/services/ShareService.dart';

class CardLibrary extends StatelessWidget {
  final VideoData videoData;
  final GlobalProvider globalProvider;
  final LikeeProvider likeeProvider;

  CardLibrary(
      {this.videoData,
      @required this.likeeProvider,
      @required this.globalProvider});

  @override
  Widget build(BuildContext context) {
    Flushbar bar;
    return Center(
        child: ContainerResponsive(
            margin: EdgeInsetsResponsive.only(left: 50, right: 50, bottom: 50),
            decoration: BoxDecoration(
                color: globalProvider.appConfig.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            heightResponsive: true,
            widthResponsive: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBoxResponsive(
                  height: 60,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      //Image thumbnail
                      ContainerResponsive(
                        height: 600,
                        width: 400,
                        heightResponsive: true,
                        widthResponsive: true,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: FileImage(
                                File(videoData.localVideo.thumbnailPath)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    child: Center(
                                  child: IconButton(
                                    tooltip: 'Play',
                                    icon: Icon(Icons.play_arrow,
                                        color:
                                            globalProvider.appConfig.textColor),
                                    onPressed: () {
                                      globalProvider.admobService
                                          .disposeBanner();
                                      globalProvider.admobService
                                          .showIntertialAd();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SimpleViewPlayer(
                                                  videoData.localVideo.filePath,
                                                  globalProvider:
                                                      globalProvider,
                                                )),
                                      );
                                    },
                                  ),
                                )))),
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
                              videoData.videoInfo.username,
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
                                'Likes Count :${videoData.videoInfo.likeCount}\nPlays Count : ${videoData.videoInfo.playCount}\nComments Count : ${videoData.videoInfo.commentCount}\nShares Count : ${videoData.videoInfo.shareCount}',
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'GiloryL',
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBoxResponsive(
                              height: 40,
                            ),
                            //Download music
                            ContainerResponsive(
                              width: 350,
                              widthResponsive: true,
                              height: 120,
                              heightResponsive: true,
                              child: FlatButton.icon(
                                label: TextResponsive(
                                  "Delete video",
                                  style: TextStyle(
                                    fontFamily: 'Gilory',
                                    fontSize: 25,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: globalProvider
                                            .appConfig.textColor)),
                                color: Colors.transparent,
                                textColor: globalProvider.appConfig.textColor,
                                padding: EdgeInsets.all(8),
                                onPressed: () {
                                  bar = Flushbar(
                                    titleText: Center(
                                      child: Text(
                                        "Are you sure wanna delete this video ?",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Gilory',
                                        ),
                                      ),
                                    ),
                                    messageText: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: globalProvider
                                                      .appConfig.textColor)),
                                          child: Text('Cancel',
                                              style: TextStyle(
                                                  fontFamily: 'Gilory',
                                                  color: globalProvider
                                                      .appConfig.textColor)),
                                          onPressed: () {
                                            bar..dismiss();
                                          },
                                        ),
                                        FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: globalProvider
                                                      .appConfig.textColor)),
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  color: globalProvider
                                                      .appConfig.textColor,
                                                  fontFamily: 'Gilory')),
                                          onPressed: () async {
                                            bar..dismiss();
                                            likeeProvider
                                                .deleteVideo(videoData);
                                            await globalProvider.dbService
                                                .deleteVideo(
                                                    videoData.videoInfo.postId);
                                          },
                                        ),
                                      ],
                                    ),
                                    flushbarPosition: FlushbarPosition.BOTTOM,
                                    flushbarStyle: FlushbarStyle.FLOATING,
                                    reverseAnimationCurve: Curves.decelerate,
                                    forwardAnimationCurve: Curves.elasticOut,
                                    backgroundColor:
                                        globalProvider.appConfig.mainColor,
                                    margin: EdgeInsets.all(30),
                                    borderRadius: 10,
                                    isDismissible: true,
                                  );
                                  bar..show(context);
                                },
                                icon: ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.delete,
                                      color: globalProvider.appConfig.textColor,
                                      size: 20,
                                    )),
                              ),
                            ),
                            SizedBoxResponsive(
                              height: 30,
                            ),
                            //Download video
                            ContainerResponsive(
                              width: 350,
                              widthResponsive: true,
                              height: 120,
                              heightResponsive: true,
                              child: FlatButton.icon(
                                splashColor: globalProvider.appConfig.textColor
                                    .withOpacity(0.2),
                                label: TextResponsive(
                                  "Share video",
                                  style: TextStyle(
                                    color: globalProvider.appConfig.textColor,
                                    fontFamily: 'Gilory',
                                    fontSize: 25,
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
                                onPressed: () {
                                  ShareService.shareVideo(
                                      videoData.localVideo.filePath,
                                      globalProvider: globalProvider);
                                },
                                icon: ContainerResponsive(
                                    heightResponsive: true,
                                    widthResponsive: true,
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.share,
                                      color: globalProvider.appConfig.textColor,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBoxResponsive(
                  height: 60,
                ),
              ],
            )));
  }
}
