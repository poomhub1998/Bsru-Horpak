import 'dart:convert';
import 'dart:developer';

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
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     MaterialButton(
                    //       color: Colors.purple,
                    //       minWidth: 50,
                    //       onPressed: () {
                    //         setState(() {
                    //           currentScreen =
                    //               SettingScreen(); // if user taps on this dashboard tab will be active
                    //           currentTab = 2;
                    //         });
                    //       },
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           Icon(
                    //             Icons.settings,
                    //             color: currentTab == 2
                    //                 ? Colors.white
                    //                 : Colors.grey,
                    //           ),
                    //           Text(
                    //             'ตั้งค่า',
                    //             style: TextStyle(
                    //               color: currentTab == 2
                    //                   ? Colors.white
                    //                   : Colors.grey,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
