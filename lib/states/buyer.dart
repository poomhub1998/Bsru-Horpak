import 'dart:convert';

import 'package:bsru_horpak/bodys/show_alert_screen_buyer.dart';
import 'package:bsru_horpak/bodys/show_homescreen_buyer.dart';
import 'package:bsru_horpak/bodys/show_settings_screen_buyer.dart';
import 'package:bsru_horpak/states/show_reserve.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_signuot.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
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
    SettingScreen(),
    AlertScreen(),
    ShowReserve()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserModel();
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id Logined ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('vulue === $value');
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          print('name login ${userModel!.name}');
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
          notchMargin: 20,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.purple,
                      minWidth: 100,
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
                            'Home',
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
                          minWidth: 100,
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
                                'จอง',
                                style: TextStyle(
                                  color: currentTab == 1
                                      ? Colors.white
                                      : Colors.grey,
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
                              minWidth: 100,
                              onPressed: () {
                                setState(() {
                                  currentScreen =
                                      SettingScreen(); // if user taps on this dashboard tab will be active
                                  currentTab = 2;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.home,
                                    color: currentTab == 2
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  Text(
                                    'Setting',
                                    style: TextStyle(
                                      color: currentTab == 2
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
