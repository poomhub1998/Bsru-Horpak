import 'dart:convert';
import 'dart:developer';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:bsru_horpak/bodys/show_alert_screen_buyer.dart';
import 'package:bsru_horpak/bodys/show_homescreen_buyer.dart';
import 'package:bsru_horpak/bodys/show_settings_screen_buyer.dart';
import 'package:bsru_horpak/states/show_reserve.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_signuot.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';

class Buyer extends StatefulWidget {
  const Buyer({
    Key? key,
  }) : super(key: key);

  @override
  State<Buyer> createState() => _BuyerState();
}

final PageStorageBucket bucket = PageStorageBucket();
Widget currentScreen = HomeScreen(
    // userModel: userModel!,
    );

class _BuyerState extends State<Buyer> {
  int currentTab = 0;
  List<Widget> widgets = [];
  UserModel? userModel;
  final List<Widget> screens = [
    HomeScreen(),
    // SettingScreen(),
    AlertScreen(),
    ShowReserve()
  ];

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("onMessage:");
        log("onMessage: $message");
        final snackBar =
            SnackBar(content: Text(message.notification?.title ?? ""));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    // TODO: implement initState
    super.initState();

    // initFirebaseMessaging();
    findUserModel();
    findToken();
  }

  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    print('มา');
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print(token);

    print('id = $id');
    String editToken =
        '${MyConstant.domain}/bsruhorpak/editTokenWhereId.php?isAdd=true&id=$id&token=$token';
    if (id != null && id.isNotEmpty) {
      await Dio().get(editToken).then((value) => print('token ได้แล้ว'));
    }
  }

  // Future<Null> initFirebaseMessaging() async {
  //   firebaseMessaging?.getToken().then((String? token) {
  //     assert(token != null);
  //   });
  // }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    FirebaseMessaging? firebaseMessaging;
    firebaseMessaging?.getToken().then((String? token) {
      assert(token != null);
      print('object');
    });
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      // print('vulue === $value');
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          // print('name login ${userModel!.name}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      // floatingActionButton: FlatButton(

      //   child: (Image.asset('assets/logohorpak.png',height: 50,)),
      //   onPressed: () {},
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SingleChildScrollView(
        child: BottomAppBar(
          color: Colors.purple,
          shape: CircularNotchedRectangle(),
          // notchMargin: 20,
          child: Container(
            // height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.purple,
                      minWidth: 50,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              HomeScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            color: currentTab == 0 ? Colors.white : Colors.grey,
                          ),
                          Text(
                            'หน้าแรก',
                            style: TextStyle(
                              color:
                                  currentTab == 0 ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.purple,
                          minWidth: 50,
                          onPressed: () {
                            setState(() {
                              currentScreen =
                                  ShowReserve(); // if user taps on this dashboard tab will be active
                              currentTab = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.reset_tv_rounded,
                                color: currentTab == 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              Text(
                                'คุณสนใจ',
                                style: TextStyle(
                                  color: currentTab == 1
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.purple,
                          minWidth: 50,
                          onPressed: () {
                            setState(() {
                              currentScreen =
                                  AlertScreen(); // if user taps on this dashboard tab will be active
                              currentTab = 3;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.align_vertical_bottom,
                                color: currentTab == 3
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              Text(
                                'สถานะการจอง',
                                style: TextStyle(
                                  color: currentTab == 3
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          color: Colors.purple,
                          minWidth: 50,
                          onPressed: () {
                            setState(() {
                              currentScreen = SettingScreen(
                                userModel: userModel!,
                              ); // if user taps on this dashboard tab will be active
                              currentTab = 4;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.settings,
                                color: currentTab == 4
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              Text(
                                'ตั้งค่า',
                                style: TextStyle(
                                  color: currentTab == 4
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: buildhelp(),
    );
  }

  Container buildhelp() {
    return Container(
      child: FabCircularMenu(
        animationCurve: Curves.linear,
        fabOpenIcon: Icon(Icons.headphones_rounded),
        alignment: Alignment.bottomRight,
        ringColor: Colors.white.withAlpha(25),
        ringDiameter: 300.0,
        ringWidth: 150.0,
        fabSize: 60.0,
        fabElevation: 10.0,
        fabIconBorder: CircleBorder(),
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              launch('tel://0962874208');
              // print('โทร');
            },
            elevation: 10.0,
            fillColor: Colors.green,
            child: Icon(
              Icons.phone,
              size: 20.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          RawMaterialButton(
            onPressed: () async {
              String email = Uri.encodeComponent("phorinat@hotmail.com");
              String subject = Uri.encodeComponent("ติดต่อ/แจ้งปัญหา");
              String body = Uri.encodeComponent("แจ้งเรื่องได้เลยครับ");
              print(subject); //output: Hello%20Flutter
              Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
              if (await launchUrl(mail)) {
                //email app opened
              } else {
                print('กรุณาลองใหม่ภายหลัง');
              }
            },
            elevation: 10.0,
            fillColor: Colors.orange,
            child: Icon(
              Icons.email,
              size: 20.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: IconButton(
                icon: Icon(
                  Icons.facebook,
                  size: 20.0,
                ),
                onPressed: () {
                  print('เฟส');
                }),
          ),
          // IconButton(
          //     icon: Icon(
          //       Icons.star,
          //       color: Colors.brown,
          //       size: 40,
          //     ),
          //     onPressed: () {
          //       // R
          //     }),
        ],
      ),
    );
  }
}
