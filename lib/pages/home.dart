import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';

final TextEditingController controller = TextEditingController();

class Homepage extends StatelessWidget {
  final LikeeProvider likeeProvider;
  final GlobalProvider globalProvider;

  Homepage({@required this.likeeProvider, @required this.globalProvider});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBoxResponsive(
          height: 50,
        ),
        Input(
          globalProvider: globalProvider,
          likeeProvider: likeeProvider,
          controller: controller,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBoxResponsive(
                  height: 25,
                ),
                BottomSpace(
                  globalProvider: globalProvider,
                  likeeProvider: likeeProvider,
                ),
                SizedBoxResponsive(
                  height: 50,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
