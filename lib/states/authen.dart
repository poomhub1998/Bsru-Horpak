import 'dart:convert';

import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key, pathImage}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  //ประกาศตัวแปร
  bool statusRedeye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.deferToChild,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                buildImage(size),
                buildAppName(),
                buildUser(size),
                buildPassword(size),
                buildLogin(size),
                buildCreactAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildCreactAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ยังไม่มีบัญชีผู้ใช้ ?'),
        TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routCreateAccount),
            child: Text('สมัคร'))
      ],
    );
  }

  Row buildLogin(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String user = userController.text;
                String password = passwordController.text;
                print('## user = $user, password = $password');
                checkAuthen(user: user, password: password);
              }
            },
            child: Text('เข้าสู้ระบบ'),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen({String? user, String? password}) async {
    String apiCheckAuthen =
        '${MyConstant.domain}/bsruhorpak/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiCheckAuthen).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'ชื่อผู้ใช้ ผิด !!!', 'ไม่มี $user ในฐานช้อมูล');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            // Success Authen
            String type = model.type;
            print('## Authen Success in Type ==> $type');

            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            preferences.setString('id', model.id);
            preferences.setString('type', type);
            preferences.setString('user', model.user);
            preferences.setString('name', model.name);

            switch (type) {
              case 'owner':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routOwner, (route) => false);
                break;
              case 'buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routBuyer, (route) => false);
                break;

              default:
            }
          } else {
            // Authen False
            MyDialog().normalDialog(
                context, 'รหัสผ่านผิด !!!', 'โปรดใส่รหัสผ่านอีกครั้ง');
          }
        }
      }
    });
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก บัญชีผู้ใช้';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: MyConstant.primary),
              labelText: 'บัญชีผู้ใช้ :',
              prefixIcon: Icon(Icons.account_circle_outlined,
                  color: MyConstant.primary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.primary,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก รหัสผ่าน';
              } else {
                return null;
              }
            },
            obscureText: statusRedeye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedeye = !statusRedeye;
                  });
                },
                icon: statusRedeye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: MyConstant.primary,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyConstant.primary,
                      ),
              ),
              labelStyle: TextStyle(color: MyConstant.primary),
              labelText: 'รหัสผ่าน :',
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: MyConstant.primary,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.primary,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(MyConstant.appName,
            style: TextStyle(
              fontSize: 24,
              color: MyConstant.primary,
            )),
      ],
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          width: size * 0.6,
          child: Image.asset('assets/images/logohorpak.png'),
        ),
      ],
    );
  }
}
