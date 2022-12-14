import 'dart:io';
import 'dart:math';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
//ตัวแปร
  String? typeUser;
  bool statusRedeye = true;
  String avatar = '';
  File? file;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController identificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkPermission();
    findToken();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // buildCreateNewAccount(),
        ],
        title: Text('สมัครสมาชิก'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // buildImage(size),
                SizedBox(
                  height: 20,
                ),
                // buildTitle('ข้อมูลทั่วไป'),
                buildUser(size),
                // Padding(
                //   padding: const EdgeInsets.only(left: 100, top: 8),
                //   child: Row(
                //     children: [
                //       Text(
                //         '* A-Z ,a-z, 0-9, ',
                //         style: TextStyle(fontSize: 10, color: Colors.red),
                //       ),
                //     ],
                //   ),
                // ),
                buildPassword(size),
                buildconfirmPassword(size),
                buildName(size),
                buildidentification(size),
                // buildAddress(size),
                SizedBox(
                  height: 20,
                ),

                // buildTitle('ข้อมูลพื้นฐาน'),
                // buildAddress(size),
                buildPhone(size),

                SizedBox(
                  height: 20,
                ),

                buildTitle('ชนิดของผู้ใช้.'),
                buildRadioUser(size),
                buildRadioOwner(size),
                // buildTitle('รูปภาพ'),
                // buildSubTitle(),
                // buildAvatar(size),
                // buildMap(),
                buildCreatAccount(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // IconButton buildCreateNewAccount() {
  //   return IconButton(
  //     onPressed: () {
  //       if (formKey.currentState!.validate()) {
  //         if (type == null) {
  //           print('Non Choose Type User');
  //           MyDialog().normalDialog(context, 'ยังไม่ได้เลือก ชนิดของ User',
  //               'กรุณา Tap ที่ ชนิดของ User ที่ต้องการ');
  //         } else {
  //           print('Process Insert to Database');
  //           uploadPictureAndInsertData();
  //         }
  //       }
  //     },
  //     icon: Icon(Icons.cloud_upload),
  //   );
  // }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี้', snippet: 'Lat = $lat, Lng = $lng'),
        ),
      ].toSet();
  Widget buildMap() => Container(
      color: Colors.grey,
      width: double.infinity,
      height: 200,
      child: lat == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat!, lng!),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: setMarker(),
            ));

  Future checkPermission() async {
    bool location;
    LocationPermission locationPermission;

    location = await Geolocator.isLocationServiceEnabled();
    if (location) {
      print('Service Locotion Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alerLocation(context, 'ไม่', 'โปรดเปิด');
        } else {
          // Find LatLng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alerLocation(context, 'ไม่', 'โปรดเปิด');
        } else {
          //Find LatLng
          findLatLng();
        }
      }
    } else {
      print('Service Locotion close');
      MyDialog()
          .alerLocation(context, 'Location ปิดอยู่', 'กรุณาเปิด Location');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng');
    Position? position = await findPosition();
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        print('lat = $lat log = $lng');
      });
    } catch (e) {}
  }

  Future<Null> findToken() async {
    print('มา');
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print(token);
  }

  Future chooseImage(ImageSource source) async {
    try {
      final result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.5,
          child: file == null
              ? Image.asset('assets/images/logohorpak.png')
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
          ),
        ),
      ],
    );
  }

  Text buildSubTitle() => Text('เลือกโปรไฟล์ของคุณ');

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ชื่อ-สกุล';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: MyConstant.primary),
              labelText: 'ชื่อ-สกุล :',
              prefixIcon: Icon(Icons.fingerprint, color: MyConstant.primary),
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

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ที่อยู่';
              } else {}
            },
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "ที่อยู่ :",
              hintStyle: TextStyle(color: MyConstant.primary),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(Icons.home, color: MyConstant.primary),
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

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก เบอร์โทรศัพท์';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: MyConstant.primary),
              labelText: 'เบอร์โทรศัพท์ :',
              prefixIcon: Icon(Icons.phone, color: MyConstant.primary),
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
                return 'กรุณากรอก ชื่อบัญชีผู้ใช้';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: MyConstant.primary),
              labelText: 'ชื่อบัญชีผู้ใช้ :',
              prefixIcon: Icon(Icons.perm_identity, color: MyConstant.primary),
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

  Row buildidentification(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: identificationController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก เลขบัตรประชาชน';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: MyConstant.primary),
              labelText: 'เลขบัตรประชาชน :',
              prefixIcon: Icon(Icons.perm_identity, color: MyConstant.primary),
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก รหัสผ่าน';
              }
              if (value.length <= 5) {
                return 'กรุณากรอกรหัสผ่าน6คัวขึ้นไป';
              } else {}
            },
            controller: passwordController,
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
              prefixIcon: Icon(Icons.lock, color: MyConstant.primary),
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

  Row buildconfirmPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก รหัสผ่าน';
              }
              if (passwordController.text != confirmpasswordController.text) {
                return 'รหัสผ่านไม่ตรงกัน';
              } else {}
            },
            controller: confirmpasswordController,
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
              labelText: 'รหัสผ่านอีกครั้ง :',
              prefixIcon: Icon(Icons.lock, color: MyConstant.primary),
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

  Row buildRadioUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            title: Text(
              'ผู้เช่า',
              style: TextStyle(color: MyConstant.primary),
            ),
            value: 'buyer',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildRadioOwner(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            title: Text(
              'เจ้าของหอพัก',
              style: TextStyle(color: MyConstant.primary),
            ),
            value: 'owner',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Row buildCreatAccount(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.75,
          height: size * 0.10,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (typeUser == null) {
                  print('ยังไม่ได้เลือก ชนิดของผู้ใช้');
                  MyDialog().normalDialog(
                      context,
                      'ยังไม่ได้เลือก ชนิดของผู่ใช้',
                      'กรุณาเลือก ที่ ชนิดของผู้ใช้ ที่ต้องการ');
                } else {
                  findToken();
                  uploadPictureAndInsertData();
                }
              }
            },
            child: Text('สร้างบัญชี'),
          ),
        ),
      ],
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;

    String identification = identificationController.text;

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print('token');

    print(
        '## name = $name, address = $address, phone = $phone, user = $user, password = $password, token = $token');
    String path =
        '${MyConstant.domain}/bsruhorpak/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) async {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        String path =
            '${MyConstant.domain}/bsruhorpak/getUserWhereidentification.php?isAdd=true&identification=$identification';
        await Dio().get(path).then((value) async {
          if (value.toString() == 'null') {
            if (file == null) {
              // No Avatar
              processInsertMySQL(
                  name: name,
                  address: address,
                  phone: phone,
                  user: user,
                  password: password,
                  identification: identification,
                  token: token);
            } else {
              // Have Avatar
              print('### process Upload Avatar');
              String apiSaveAvatar =
                  '${MyConstant.domain}/bsruhorpak/saveAvatar.php';
              int i = Random().nextInt(100000);
              String nameAvatar = 'avatar$i.jpg';
              Map<String, dynamic> map = Map();
              map['file'] = await MultipartFile.fromFile(file!.path,
                  filename: nameAvatar);
              FormData data = FormData.fromMap(map);
              await Dio().post(apiSaveAvatar, data: data).then((value) {
                avatar = '/bsruhorpak/avatar/$nameAvatar';
                processInsertMySQL(
                  name: name,
                  address: address,
                  phone: phone,
                  user: user,
                  password: password,
                );
              });
            }
          } else {
            MyDialog().normalDialog(
                context, 'มีเลขบัตรประชาชนนี้แล้ว ?', 'กรุณาเปลี่ยนเลข');
          }
        });
      } else {
        MyDialog().normalDialog(
            context, 'มีชื่อผู้ใช้นี้แล็ว ', 'กรุณาเปลี่ยนชื่อผู้ใช้');
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? identification,

      // String? address,
      String? phone,
      String? type,
      String? user,
      String? address,
      String? password,
      String? token}) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/bsruhorpak/insertUser.php?isAdd=true&user=$user&password=$password&name=$name&identification=$identification&address=$address&phone=$phone&type=$typeUser&avatar=$avatar&lat=$lat&lng=$lng&token=$token';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'สร้างบัญชีผู้ใช้ไม่ได้ !!!', 'กรุณาลองใหม่ภายหลัง');
      }
    });
  }

  Text buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, color: Colors.purple),
    );
  }
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
