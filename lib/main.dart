import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/pages/initPage.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/providers/LikeeProvider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LikeeProvider()),
              ChangeNotifierProvider(create: (context) => GlobalProvider()),
            ],
            child: MyApp(),
          )));
}

//main
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LikeeProvider, GlobalProvider>(
        builder: (context, likee, global, child) {
      return MaterialApp(
        title: global.appConfig.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: global.appConfig.textColor,
            displayColor: global.appConfig.textColor,
          ),
          primaryColor: global.appConfig.backgroundColor,
          splashColor: global.appConfig.mainColor.withOpacity(0.5),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: InitPage(
          globalProvider: global,
          mainPage: MainPage(
            globalProvider: global,
            likeeProvider: likee,
          ),
        ),
      );
    });
  }
}

class MainPage extends StatefulWidget {
  final GlobalProvider globalProvider;
  final LikeeProvider likeeProvider;
  MainPage({@required this.globalProvider, @required this.likeeProvider});
  @override
  _MainPageState createState() => _MainPageState(
      globalProvider: globalProvider, likeeProvider: likeeProvider);
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  TabController tabController;
  final GlobalProvider globalProvider;
  final LikeeProvider likeeProvider;
  _MainPageState({@required this.globalProvider, @required this.likeeProvider});
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void changePage(int index) {
    setState(() {
      tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1920,
      width: 1080,
    );
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: globalProvider.appConfig.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: tabController.index == 0
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/cover.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBoxResponsive(
                            height: 40,
                          ),
                          TabBar(
                            indicatorColor: globalProvider.appConfig.mainColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: globalProvider.appConfig.textColor,
                            labelStyle:
                                TextStyle(fontSize: 20, fontFamily: 'Gilory'),
                            indicatorWeight: 4,
                            controller: tabController,
                            tabs: [
                              Tab(
                                text: "Home",
                              ),
                              Tab(
                                text: "Library",
                              ),
                            ],
                            onTap: (index) {
                              setState(() {
                                changePage(index);
                              });
                            },
                          ),
                          SizedBoxResponsive(
                            height: 70,
                          ),
                          TextResponsive(
                            globalProvider.appConfig.appTitle,
                            style: TextStyle(
                              fontSize: 120,
                              fontFamily: 'Gilory',
                            ),
                          ),
                          TextResponsive(
                            "Likee video downloader",
                            style: TextStyle(
                              fontSize: 50,
                              fontFamily: 'Gilory',
                            ),
                          ),
                          SizedBoxResponsive(
                            height: 30,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Divider(
                              color: globalProvider.appConfig.textColor,
                              thickness: 4,
                            ),
                          ),
                          SizedBoxResponsive(
                            height: 20,
                          ),
                          ContainerResponsive(
                            width: MediaQuery.of(context).size.width + 200,
                            widthResponsive: true,
                            child: TextResponsive(
                              globalProvider.appConfig.smallDescription,
                              style: TextStyle(
                                fontSize: 50,
                                fontFamily: 'Gilory',
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/cover.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBoxResponsive(
                            height: 50,
                          ),
                          TabBar(
                            indicatorColor: globalProvider.appConfig.mainColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: globalProvider.appConfig.textColor,
                            labelStyle:
                                TextStyle(fontSize: 20, fontFamily: 'Gilory'),
                            indicatorWeight: 4,
                            controller: tabController,
                            tabs: [
                              Tab(
                                text: "Home",
                              ),
                              Tab(
                                text: "Library",
                              ),
                            ],
                            onTap: (index) {
                              setState(() {
                                changePage(index);
                              });
                            },
                          ),
                          SizedBoxResponsive(
                            height: 80,
                          ),
                          TextResponsive(
                            "Explore Your Download!",
                            style: TextStyle(
                              fontSize: 50,
                              fontFamily: 'Gilory',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: tabController.index == 0
              ? MediaQuery.of(context).size.height * 0.36
              : MediaQuery.of(context).size.height * 0.17,
        ),
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Homepage(
              likeeProvider: likeeProvider,
              globalProvider: globalProvider,
            ),
            Librarypage(
              likeeProvider: likeeProvider,
              globalProvider: globalProvider,
            )
          ],
        ),
      ),
    );
  }
}
