import 'dart:convert';

import 'package:bsru_horpak/bodys/show_mange_owner.dart';
import 'package:bsru_horpak/bodys/show_order_owner.dart';
import 'package:bsru_horpak/bodys/show_product_owner.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_signuot.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class Owner extends StatefulWidget {
  const Owner({Key? key}) : super(key: key);

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  UserModel? userModel;
  ProductModel? productModel;
  List<Widget> widgets = [];
  int indexWidget = 0;

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
          widgets.add(ShowProductOwner());
          widgets.add(ShowOrderOwner());
          widgets.add(ShowMangeOwner(
            userModel: userModel!,
          ));
        });
      }
    });
  }

  Future<Null> findProductModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    print('## id Logined ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getProductWhereIdOwner.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('vulue === $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หอพัก'),
      ),
      drawer: widgets.length == 0
          ? SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  ShowSignOut(),
                  Column(
                    children: [
                      buildHead(),
                      menuShowHorPakProduct(),
                      menuShowHorPak(),
                      menuShowHorPakManage(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.length == 0 ? ShowProgress() : widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
        otherAccountsPictures: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.face_outlined,
              size: 30,
              color: Colors.white,
            ),
            tooltip: 'แก้ไข หอพัก',
          )
        ],
        currentAccountPicture: CircleAvatar(
          backgroundImage:
              NetworkImage('${MyConstant.domain}${userModel!.avatar}'),
        ),
        accountName: Text(userModel == null ? 'name' : userModel!.name),
        accountEmail: Text(userModel == null ? 'Type ?' : userModel!.type));
  }

  ListTile menuShowHorPakProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;

          Navigator.pop(context);
        });
      },
      subtitle: Text('แสดงหอพัก'),
      leading: Icon(Icons.file_copy_rounded),
      title: ShowTitle(
        title: 'เพิ่มข้อมูล หอพัก',
        textStyle: MyConstant().h2BackStyle(),
      ),
    );
  }

  ListTile menuShowHorPak() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      subtitle: Text('หอ'),
      leading: Icon(Icons.file_copy_rounded),
      title: ShowTitle(
        title: 'Show Oder',
        textStyle: MyConstant().h2BackStyle(),
      ),
    );
  }

  ListTile menuShowHorPakManage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      subtitle: Text('Horpak'),
      leading: Icon(Icons.file_copy_rounded),
      title: ShowTitle(
        title: 'แก้ไขโปรไฟล์',
        textStyle: MyConstant().h2BackStyle(),
      ),
    );
  }
}
