import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/helpers/types.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';

class BottomSpace extends StatelessWidget {
  final LikeeProvider likeeProvider;
  final GlobalProvider globalProvider;
  BottomSpace({
    @required this.likeeProvider,
    @required this.globalProvider,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ContainerResponsive(
      decoration: BoxDecoration(
          color: globalProvider.appConfig.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      heightResponsive: true,
      widthResponsive: true,
      width: 900,
      child: (globalProvider.checkingStatus == CheckingStatus.Validate)
          ? Tutorial(
              globalProvider: globalProvider,
            )
          : CardWidget(
              globalProvider: globalProvider,
              likeeProvider: likeeProvider,
            ),
    ));
  }
}
