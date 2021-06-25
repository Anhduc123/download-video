import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/providers/GlobalProvider.dart';

class TutorialItem extends StatelessWidget {
  final icotext;
  final title;
  final description;
  final GlobalProvider globalProvider;
  const TutorialItem(
      {Key key,
      this.icotext,
      this.title,
      this.description,
      this.globalProvider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: globalProvider.appConfig.mainColor,
          ),
          SizedBoxResponsive(
            height: 10,
          ),
          Text(
            icotext,
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilory',
                color: globalProvider.appConfig.textColor),
          )
        ],
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontFamily: 'Gilory',
            color: globalProvider.appConfig.textColor),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
            fontSize: 15,
            fontFamily: 'Gilory',
            color: globalProvider.appConfig.textColor),
      ),
    );
  }
}
