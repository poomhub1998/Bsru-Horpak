// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:flutter/material.dart';

class MyConstant {
  static String appName = 'BSRU HORPAK';
  static String domain = 'https://dae7-49-49-249-84.ap.ngrok.io';
  //Route
  static String routAuthen = '/authen';
  static String routCreateAccount = '/createAccount';
  static String routBuyer = '/buyyer';
  static String routOwner = '/owner';
  static String routAddHorPak = '/addHorPak';
  static String routshowReserve = '/showReserve';
  static String conFrimReseve = '/conFrimReseve';
  static String routShowOrderOwner = '/showOrderOwner';
  static String routShowHistory = '/showHistory';
  static String routEditProfileOwner = '/editProfileOwner';

  //Image
  static String logo = 'assets/images/logohorpak.png';
  static String camera = 'assets/images/camera.png';
  // color

  static Color primary = Colors.purple;
  static Color dark = Colors.purple;
  static Color light = Colors.purple;
  static Map<int, Color> mapMaterinalVolor = {
    50: Color.fromARGB(144, 235, 7, 220),
    100: Color.fromARGB(198, 66, 3, 87),
    200: Color.fromRGBO(255, 34, 134, 0.3),
    300: Color.fromRGBO(255, 34, 134, 0.4),
    400: Color.fromRGBO(255, 34, 134, 0.5),
    500: Color.fromRGBO(255, 34, 134, 0.6),
    600: Color.fromRGBO(255, 34, 134, 0.7),
    700: Color.fromRGBO(255, 34, 134, 0.8),
    800: Color.fromRGBO(255, 34, 134, 0.9),
    900: Color.fromRGBO(255, 34, 134, 1.0),
  };

  // style

  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.normal);

  //
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );

  TextStyle h1Stylebold() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h1WhiteStyle() => TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h1BackStyle() => TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  //Text h2Style
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h2Stylebold() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2WhiteStyle() => TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h2RedStyle() => TextStyle(
        fontSize: 18,
        color: Colors.red.shade800,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2BlueStyle() => TextStyle(
        fontSize: 18,
        color: Colors.blue.shade800,
        fontWeight: FontWeight.normal,
      );
  TextStyle h2BackStyle() => TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  //Text h3Style
  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3Stylebold() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h3WhiteStyle() => TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3BlackStyleBold() => TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  TextStyle h3BlackStyle() => TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3BuleStyle() => TextStyle(
        fontSize: 14,
        color: Colors.blue.shade800,
        fontWeight: FontWeight.normal,
      );

  TextStyle h4Style() => TextStyle(
        fontSize: 12,
        color: dark,
        fontWeight: FontWeight.normal,
      );
}
