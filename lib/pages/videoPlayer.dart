import 'package:flutter/material.dart';
import 'package:likeetube/providers/GlobalProvider.dart';

import 'package:video_player/video_player.dart';

class SimpleViewPlayer extends StatefulWidget {
  final String source;
  final GlobalProvider globalProvider;

  SimpleViewPlayer(this.source, {@required this.globalProvider});

  @override
  _SimpleViewPlayerState createState() => _SimpleViewPlayerState();
}

class _SimpleViewPlayerState extends State<SimpleViewPlayer> {
  VideoPlayerController controller;
  VoidCallback listener;
  bool hideBottom = true;

  @override
  void initState() {
    super.initState();

    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
    controller = VideoPlayerController.network(widget.source);
    controller.initialize();
    controller.setLooping(true);
    controller.addListener(listener);
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayView(controller, widget.globalProvider),
    );
  }
}

class PlayView extends StatefulWidget {
  final VideoPlayerController controller;
  final GlobalProvider globalProvider;

  PlayView(this.controller, this.globalProvider);

  @override
  _PlayViewState createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  VideoPlayerController get controller => widget.controller;
  bool hideBottom = true;

  void onClickPlay() {
    if (!controller.value.initialized) {
      return;
    }
    setState(() {
      hideBottom = false;
    });
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) {
          return;
        }
        if (!controller.value.initialized) {
          return;
        }
        if (controller.value.isPlaying && !hideBottom) {
          setState(() {
            hideBottom = true;
          });
        }
      });
      controller.play();
    }
  }

  void onClickExitFullScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value.initialized) {
      final Size size = controller.value.size;
      return WillPopScope(
        onWillPop: () {
          print('Backing up');
          widget.globalProvider.admobService.showBanner();

          return Future.value(true);
        },
        child: GestureDetector(
          child: Container(
              color: widget.globalProvider.appConfig.backgroundColor,
              child: Stack(
                children: <Widget>[
                  Center(
                      child: AspectRatio(
                    aspectRatio: size.width / size.height,
                    child: VideoPlayer(controller),
                  )),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: hideBottom
                          ? Container()
                          : Opacity(
                              opacity: 0.8,
                              child: Container(
                                  height: 50.0,
                                  color: widget
                                      .globalProvider.appConfig.backgroundColor,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          child: controller.value.isPlaying
                                              ? Icon(
                                                  Icons.pause,
                                                  color: widget.globalProvider
                                                      .appConfig.mainColor,
                                                )
                                              : Icon(
                                                  Icons.play_arrow,
                                                  color: widget.globalProvider
                                                      .appConfig.mainColor,
                                                ),
                                        ),
                                        onTap: onClickPlay,
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Center(
                                            child: Text(
                                              "${controller.value.position.toString().split(".")[0]}",
                                              style: TextStyle(
                                                  fontFamily: 'Gilory'),
                                            ),
                                          )),
                                      Expanded(
                                          child: VideoProgressIndicator(
                                        controller,
                                        allowScrubbing: true,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 1.0),
                                        colors: VideoProgressColors(
                                            playedColor: widget.globalProvider
                                                .appConfig.mainColor),
                                      )),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Center(
                                            child: Text(
                                              "${controller.value.duration.toString().split(".")[0]}",
                                              style: TextStyle(
                                                  fontFamily: 'Gilory'),
                                            ),
                                          )),
                                    ],
                                  )),
                            )),
                  Align(
                    alignment: Alignment.center,
                    child: controller.value.isPlaying
                        ? Container()
                        : Icon(
                            Icons.play_circle_filled,
                            color: widget.globalProvider.appConfig.mainColor,
                            size: 48.0,
                          ),
                  )
                ],
              )),
          onTap: onClickPlay,
        ),
      );
    } else if (controller.value.hasError && !controller.value.isPlaying) {
      return Container(
        color: widget.globalProvider.appConfig.backgroundColor,
        child: Center(
          child: RaisedButton(
            onPressed: () {
              controller.initialize();
              controller.setLooping(true);
              controller.play();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text("play error, try again!",
                style: TextStyle(
                  fontFamily: 'Gilory',
                )),
          ),
        ),
      );
    } else {
      return Container(
        color: widget.globalProvider.appConfig.backgroundColor,
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  widget.globalProvider.appConfig.mainColor)),
        ),
      );
    }
  }
}
