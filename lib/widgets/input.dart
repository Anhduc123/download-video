import 'package:flutter/services.dart';
import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';
import 'package:likeetube/services/likeeService.dart';

class Input extends StatelessWidget {
  final LikeeProvider likeeProvider;
  final GlobalProvider globalProvider;
  final TextEditingController controller;

  Input(
      {@required this.likeeProvider,
      @required this.globalProvider,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ContainerResponsive(
        heightResponsive: true,
        widthResponsive: true,
        width: 900,
        height: 160,
        child: TextField(
          textInputAction: TextInputAction.none,
          controller: this.controller,
          keyboardType: TextInputType.url,
          maxLines: 1,
          cursorColor: globalProvider.appConfig.mainColor,
          style: TextStyle(
              color: Color(0xff0F111A),
              fontFamily: 'Gilory',
              fontSize: ScreenUtil().setSp(50, allowFontScalingSelf: true)),
          decoration: InputDecoration(
            //paste button
            suffixIcon: IconButton(
              tooltip: 'Paste',
              icon: Icon(
                (globalProvider.checkingStatus == CheckingStatus.Validate)
                    ? Icons.content_copy
                    : Icons.clear,
                color:
                    (globalProvider.checkingStatus == CheckingStatus.Validate)
                        ? globalProvider.appConfig.mainColor
                        : Color(0xffd11a2a),
              ),
              onPressed: () async {
                globalProvider.admobService.showIntertialAd();
                if (globalProvider.checkingStatus == CheckingStatus.Validate) {
                  final clipBoardData = await LikeeService.getClipBoardData();
                  controller.text = clipBoardData;
                  if (LikeeService.isLikeeUrl(clipBoardData)) {
                    globalProvider.likeeUrl = controller.text;
                    globalProvider.checkingStatus = CheckingStatus.Checking;
                    VideoInfo videoInfo =
                        await LikeeService.getVideoInfo(clipBoardData);
                    if (videoInfo.statusCode == 200) {
                      globalProvider.videoInfo = videoInfo;
                      globalProvider.checkingStatus = CheckingStatus.Done;
                    }
                  } else {
                    Flushbar(
                      titleText: Text(
                        "Invalid Url !!!",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilory',
                            color: Colors.white),
                      ),
                      messageText: Text(
                        "Not valid Likee Url",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Gilory',
                            color: Color(0xff04DA900)),
                      ),
                      duration: Duration(seconds: 2),
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      reverseAnimationCurve: Curves.decelerate,
                      forwardAnimationCurve: Curves.elasticOut,
                      backgroundColor: globalProvider.appConfig.backgroundColor,
                      margin: EdgeInsets.all(8),
                      borderRadius: 10,
                      isDismissible: true,
                    )..show(context);
                    controller.clear();
                  }
                } else {
                  controller.clear();
                  globalProvider.checkingStatus = CheckingStatus.Validate;
                  Future.delayed(Duration(milliseconds: 700),
                      () async => await globalProvider.disposeVideoPlayer());
                }
              },
            ),

            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.transparent)),
            filled: true,
            contentPadding: EdgeInsets.all(15),
            hintText: "Paste link here",
            fillColor: Color(0xffE5E5E5),
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
