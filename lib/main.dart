import 'package:bsru_horpak/bodys/show_history.dart';
import 'package:bsru_horpak/bodys/show_order_owner.dart';
import 'package:bsru_horpak/states/aad_horpak.dart';
import 'package:bsru_horpak/states/authen.dart';
import 'package:bsru_horpak/states/buyer.dart';
import 'package:bsru_horpak/states/confrim_reserve.dart';
import 'package:bsru_horpak/states/create_account.dart';
import 'package:bsru_horpak/states/owner.dart';
import 'package:bsru_horpak/states/show_reserve.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyyer': (BuildContext context) => Buyer(),
  '/showOrderOwner': (BuildContext context) => ShowOrderOwner(),
  '/owner': (BuildContext context) => Owner(),
  '/addHorPak': (BuildContext context) => AddHorPak(),
  '/showReserve': (BuildContext context) => ShowReserve(),
  '/conFrimReseve': (BuildContext context) => ConFrimReseve(),
  '/showHistory': (BuildContext context) => History_Screen(),
};
String? initlalRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  future:
  Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? token = await firebaseMessaging.getToken();
  print('token = $token');

  String? id = preferences.getString('id');

  print('id = $id');
  String editToken =
      '${MyConstant.domain}/bsruhorpak/editTokenWhereId.php?isAdd=true&id=$id&token=$token';
  if (id != null && id.isNotEmpty) {
    await Dio().get(editToken).then((value) => print('token ได้แล้ว'));
  }

  // print('## type ===>> $type');
  if (type?.isEmpty ?? true) {
    initlalRoute = MyConstant.routAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'owner':
        initlalRoute = MyConstant.routOwner;
        runApp(MyApp());

        break;
      case 'buyer':
        initlalRoute = MyConstant.routBuyer;
        runApp(MyApp());

        break;

      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xFF8E24AA, MyConstant.mapMaterinalVolor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlalRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
