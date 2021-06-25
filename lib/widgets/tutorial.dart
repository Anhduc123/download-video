import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/providers/GlobalProvider.dart';

class Tutorial extends StatelessWidget {
  final GlobalProvider globalProvider;
  Tutorial({@required this.globalProvider});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBoxResponsive(
          height: 40,
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: TextResponsive(
            "How to download ?",
            style: TextStyle(fontSize: 60, fontFamily: 'GiloryL'),
          ),
        ),
        SizedBoxResponsive(
          height: 60,
        ),
        TutorialItem(
          icotext: "01",
          title: "Copy link",
          description: "Open likee and open share icon, click on copy link.",
          globalProvider: globalProvider,
        ),
        SizedBoxResponsive(
          height: 50,
        ),
        TutorialItem(
            icotext: "02",
            title: "Paste it above",
            description:
                "Paste copied url in above field, and wait your video load here.",
            globalProvider: globalProvider),
        SizedBoxResponsive(
          height: 50,
        ),
        TutorialItem(
            icotext: "03",
            title: "Download is ready",
            description:
                "Click to download to enjoy your video no watermark for likee.",
            globalProvider: globalProvider),
        SizedBoxResponsive(
          height: 60,
        ),
      ],
    );
  }
}
