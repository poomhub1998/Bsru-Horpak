import 'dart:convert';
import 'package:bsru_horpak/main.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key, pathImage}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  FirebaseMessaging? firebaseMessaging;
  //ประกาศตัวแปร
  bool statusRedeye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findToken();
  }

  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    // print('มา');
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    // print(token);

    // print('id = $id');
    String editToken =
        '${MyConstant.domain}/bsruhorpak/editTokenWhereId.php?isAdd=true&id=$id&token=$token';
    if (id != null && id.isNotEmpty) {
      await Dio().get(editToken).then((value) => print('token ได้แล้ว'));
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          // Cannot be `Alignment.center`
          alignment: Alignment.bottomRight,
          ringColor: Colors.white.withAlpha(25),
          ringDiameter: 350.0,
          ringWidth: 150.0,
          fabSize: 50.0,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),
          // Also can use specific color based on wether
          // the menu is open or not:
          // fabOpenColor: Colors.white
          // fabCloseColor: Colors.white
          // These properties take precedence over fabColor
          fabColor: Colors.purple,
          fabOpenIcon: Icon(
            Icons.headphones,
          ),
          fabCloseIcon: Icon(
            Icons.close,
          ),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {},
          children: <Widget>[
            RawMaterialButton(
                onPressed: () {},
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Text('')),
            RawMaterialButton(
              onPressed: () async {
                const url = "https://m.me/icez007";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                Icons.facebook_rounded,
                color: Colors.blue,
                size: 30,
              ),
            ),
            RawMaterialButton(
              onPressed: () async {
                String email = Uri.encodeComponent("phorinat@hotmail.com");
                String subject = Uri.encodeComponent("ติดต่อ/แจ้งปัญหา");
                String body = Uri.encodeComponent("แจ้งเรื่องได้เลยครับ");
                print(subject); //output: Hello%20Flutter
                Uri mail =
                    Uri.parse("mailto:$email?subject=$subject&body=$body");
                if (await launchUrl(mail)) {
                  //email app opened
                } else {
                  print('กรุณาลองใหม่ภายหลัง');
                }
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                Icons.mail,
                color: Colors.red,
                size: 30,
              ),
            ),
            // RawMaterialButton(
            //   onPressed: () {},
            //   shape: CircleBorder(),
            //   padding: const EdgeInsets.all(24.0),
            //   child: Icon(
            //     Icons.facebook,
            //     color: Colors.blue,
            //     size: 30,
            //   ),
            // )
          ],
        ),
      ),
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

  Row buildCreactAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ยังไม่มีบัญชีผู้ใช้ ?'),
        TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routCreateAccount),
            child: Text('สมัครสมาชิก'))
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
                findToken();
                print('อัปเดท แล้ว');
              }
            },
            child: Text('เข้าสู้ระบบ'),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen({String? user, String? password}) async {
    Firebase.initializeApp();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print('token = $token');
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? id = preferences.getString('id');

    String editToken =
        '${MyConstant.domain}/bsruhorpak/editTokenWhereId.php?isAdd=true&id=$id&token=$token';
    if (id != null && id.isNotEmpty) {
      await Dio().get(editToken).then((value) => print('token ได้แล้ว'));
    }
    String apiCheckAuthen =
        '${MyConstant.domain}/bsruhorpak/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(apiCheckAuthen).then((value) async {
      // print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'ชื่อผู้ใช้ ผิด !!!', 'ไม่มี $user ในฐานช้อมูล');
      } else {
        for (var item in jsonDecode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            // Success Authen
            String type = model.type;
            // print('## Authen Success in Type ==> $type');

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

  void displayMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
