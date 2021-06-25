import 'package:flutter/material.dart';
import 'package:likeetube/helpers/global.dart';
import 'package:likeetube/main.dart';
import 'package:likeetube/providers/GlobalProvider.dart';
import 'package:likeetube/services/DbService.dart';
import 'package:likeetube/services/StorageService.dart';
import 'package:permission_handler/permission_handler.dart';

class InitPage extends StatefulWidget {
  final MainPage mainPage;
  final GlobalProvider globalProvider;
  InitPage({this.mainPage, @required this.globalProvider});

  @override
  _InitPageState createState() => _InitPageState();
}

var permissionFuture;

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: widget.globalProvider.appConfig.backgroundColor,
        child: FutureBuilder<PermissionStatus>(
            future: permissionFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isGranted) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Permission granted",
                          style: TextStyle(
                            fontFamily: 'Gilory',
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: 'Gilory',
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                            tooltip: 'next',
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: widget.globalProvider.appConfig.textColor,
                            ),
                            onPressed: () {
                              widget.globalProvider.dbService = DbService();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          this.widget.mainPage));
                            }),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "The app doesn't have storage permission",
                          style: TextStyle(
                            fontFamily: 'Gilory',
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Please try again !!",
                          style: TextStyle(
                            fontFamily: 'Gilory',
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                            tooltip: 'Refresh',
                            icon: Icon(
                              Icons.refresh,
                              color: widget.globalProvider.appConfig.textColor,
                            ),
                            onPressed: () async {
                              await StorageService.requestPermission();
                              if ((await StorageService
                                      .storagePermissionStatus()) ==
                                  PermissionStatus.granted) {
                                widget.globalProvider.dbService = DbService();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            this.widget.mainPage));
                              } else {
                                await StorageService.requestPermission();
                              }
                            })
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          widget.globalProvider.appConfig.mainColor)),
                );
              }
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    permissionFuture = StorageService.requestPermission();
    Future.delayed(Duration(seconds: 0), () async {
      if ((await StorageService.storagePermissionStatus()) ==
          PermissionStatus.granted) {
        widget.globalProvider.dbService = DbService();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => this.widget.mainPage));
      }
    });
    widget.globalProvider.admobService.showBanner();
  }
}
