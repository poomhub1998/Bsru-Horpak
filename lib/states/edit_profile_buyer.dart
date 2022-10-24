import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';

import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class EditProfileBuyer extends StatefulWidget {
  final UserModel userModel;
  const EditProfileBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditProfileBuyer> createState() => _EditProfileBuyerState();
}

class _EditProfileBuyerState extends State<EditProfileBuyer> {
  UserModel? userModel;
  TextEditingController userController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fildUser();
    userModel = widget.userModel;
    nameController.text = userModel!.name;
    userController.text = userModel!.user;
    phoneController.text = userModel!.phone;
  }

  Future<Null> fildUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString('user');
    String apiGetUser =
        '${MyConstant.domain}/bsruhorpak/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiGetUser).then((value) {
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);

          print(user);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลส่วนตัว'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildTitle('ข้อมูล'),
                // buildUser(constraints),
                buildName(constraints),
                buildPhone(constraints),
                buildButtonEditProfile()
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: buildhelp(),
    );
  }

  Row buildUser(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.7,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'โปรดใส่ชื้อผู้ใช้';
              } else {}
            },
            controller: userController,
            decoration: InputDecoration(
              labelText: 'บัญชีผู้ใช้',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.7,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'โปรดใส่ชื่อ-สกุล';
              } else {}
            },
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'ชื่อ-สกุล',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.7,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'โปรดใส่เบอร์โทรศัทพ์';
              } else {}
            },
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'เบอร์โทรศัพท์',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> processEditProfileSeller() async {
    if (formKey.currentState!.validate()) {
      String apiEditProfile =
          '${MyConstant.domain}/bsruhorpak/editProfileOwnerWhereId.php?isAdd=true&id=${userModel!.id}&user=${userController.text}&name=${nameController.text}&phone=${phoneController.text}';
      await Dio().get(apiEditProfile).then((value) {
        Navigator.pop(context);
      });
    }
  }

  ShowTitle buildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }

  ElevatedButton buildButtonEditProfile() => ElevatedButton.icon(
      onPressed: () => processEditProfileSeller(),
      icon: Icon(Icons.edit),
      label: Text('แก้ไขข้อมูล'));
}
