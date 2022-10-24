import 'dart:convert';
import 'package:bsru_horpak/states/edit_product.dart';
import 'package:bsru_horpak/states/edit_profile_buyer.dart';
import 'package:bsru_horpak/states/edit_profile_owner.dart';
import 'package:bsru_horpak/widgets/loading_widget.dart';
import 'package:bsru_horpak/widgets/profile_widget.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class SettingScreen extends StatefulWidget {
  final UserModel userModel;
  const SettingScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshUserModel();
    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('## refreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear().then(
                    (value) => Navigator.pushNamedAndRemoveUntil(
                        context, MyConstant.routAuthen, (route) => false),
                  );
            },
          ),
        ],
      ),
      // floatingActionButton: buildhelp(),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfildView(),
                  // ShowImage(path: MyConstant.logo),
                  // ShowTitle(
                  //     title: 'ชื่อผู้ใช้  : ${userModel!.user}',
                  //     textStyle: MyConstant().h1Style()),

                  ShowTitle(
                      title: 'ชื่อ-สกุล  : ${userModel!.name}',
                      textStyle: MyConstant().h1Style()),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ShowTitle(
                  //       title: 'ที่อยู่ : ${userModel!.address}',
                  //       textStyle: MyConstant().h2Style()),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       width: constraints.maxWidth * 0.6,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ShowTitle(
                  //           title: userModel!.address,
                  //           textStyle: MyConstant().h2Style(),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowTitle(
                      title: 'เบอร์โทรศัพท์ : ${userModel!.phone}',
                      textStyle: MyConstant().h1Style(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileBuyer(userModel: userModel!),
                          )).then((value) => refreshUserModel());
                    },
                    child: Text('แก้ไขข้อมูล'),
                  ),

                  // IconButton(
                  //     onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           EditProfileOwner(userModel: userModel!),
                  //     )).then((value) => refreshUserModel());
                  //     },
                  //     icon: Icon(Icons.edit)),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8),
                  //   child: ShowTitle(
                  //       title: 'รูปโปรไฟล์ :',
                  //       textStyle: MyConstant().h2Style()),
                  // ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.symmetric(vertical: 16),
                  //       width: constraints.maxWidth * 0.6,
                  //       child: CachedNetworkImage(
                  //         imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                  //         placeholder: (context, url) => ShowProgress(),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.symmetric(vertical: 16),
                  //       width: constraints.maxWidth * 0.6,
                  //       height: constraints.maxWidth * 0.6,
                  //       child: GoogleMap(
                  //         initialCameraPosition: CameraPosition(
                  //           target: LatLng(
                  //             double.parse(userModel!.lat),
                  //             double.parse(userModel!.lng),
                  //           ),
                  //           zoom: 16,
                  //         ),
                  //         markers: <Marker>[
                  //           Marker(
                  //               markerId: MarkerId('id'),
                  //               position: LatLng(
                  //                 double.parse(userModel!.lat),
                  //                 double.parse(userModel!.lng),
                  //               ),
                  //               infoWindow: InfoWindow(
                  //                   title: 'You Here ',
                  //                   snippet:
                  //                       'lat = ${userModel!.lat}, lng = ${userModel!.lng}')),
                  //         ].toSet(),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
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
              onPressed: () {
                launch('tel://0962874208');
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(
                Icons.phone,
                color: Colors.green,
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
}

Container buildhelp() {
  return Container(
    child: FabCircularMenu(
      fabMargin: EdgeInsets.all(40),
      animationCurve: Curves.linear,
      fabOpenIcon: Icon(Icons.headphones_rounded),
      alignment: Alignment.bottomRight,
      ringColor: Colors.white.withAlpha(0),
      ringDiameter: 300.0,
      ringWidth: 100.0,
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
          // padding: EdgeInsets.all(15.0),
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
                padding:
                EdgeInsets.all(15.0);
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
