import 'dart:io';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class MyDialog {
  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
          child: CircularProgressIndicator(
            color: MyConstant.dark,
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<Null> alerLocation(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Image.asset('assets/images/logohorpak.png'),
          title: Text('Location ปิดอยู่'),
          subtitle: Text('กรุณาเปิด Location '),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await Geolocator.openLocationSettings();
              exit(0);
            },
            child: Text('ok'),
          )
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Image.asset('assets/images/logohorpak.png'),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: message,
            textStyle: MyConstant().h3Style(),
          ),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ShowTitle(
              title: 'ปิด',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ],
      ),
    );
  }
}
