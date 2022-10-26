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

class EditProfileOwner extends StatefulWidget {
  final UserModel userModel;
  const EditProfileOwner({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditProfileOwner> createState() => _EditProfileOwnerState();
}

class _EditProfileOwnerState extends State<EditProfileOwner> {
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

  Container buildhelp() {
    return Container(
      child: FabCircularMenu(
        animationCurve: Curves.linear,
        fabOpenIcon: Icon(Icons.headphones_rounded),
        alignment: Alignment.bottomLeft,
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
              print('โทร');
            },
            elevation: 50.0,
            fillColor: Colors.green,
            child: Icon(
              Icons.phone,
              size: 20.0,
            ),
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

  ElevatedButton buildButtonEditProfile() => ElevatedButton.icon(
      onPressed: () => processEditProfileSeller(),
      icon: Icon(Icons.edit),
      label: Text('แก้ไขข้อมูล'));

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

  Future<Null> processEditProfileSeller() async {
    String user = userController.text;

    String path =
        '${MyConstant.domain}/bsruhorpak/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) {
      print(value);
      // if () {
      //   MyDialog().normalDialog(
      //       context, 'มีชื่อผู้ใช้นี้แล็ว ?', 'กรุณาเปลี่ยนชื่อผู้ใช้');
      // } else {
      if (formKey.currentState!.validate()) {
        String apiEditProfile =
            '${MyConstant.domain}/bsruhorpak/editProfileOwnerWhereId.php?isAdd=true&id=${userModel!.id}&user=${userController.text}&name=${nameController.text}&phone=${phoneController.text}';
        Dio().get(apiEditProfile).then((value) {
          Navigator.pop(context);
        });
      }
    });
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

  ShowTitle buildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }
}
