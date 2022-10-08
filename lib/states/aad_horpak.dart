import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'dart:math';
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

class AddHorPak extends StatefulWidget {
  const AddHorPak({Key? key}) : super(key: key);

  @override
  State<AddHorPak> createState() => _AddHorPakState();
}

class _AddHorPakState extends State<AddHorPak> {
  String? typeUser = 'owner';
  final formKey = GlobalKey<FormState>();
  double? lat, lng;
  List<File?> files = [];
  File? file;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  List<String> paths = [];

  @override
  void initState() {
    super.initState();
    checkPermission();
    initiaFile();
  }

  void initiaFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลหอพัก'),
        actions: [
          IconButton(
            onPressed: () => processAddProduct(),
            icon: Icon(Icons.cloud_upload),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildHorPak(constraints),
                    buildPhone(constraints),
                    buildImage(constraints),
                    buildHorPakPrice(constraints),
                    buildHorPakDetail(constraints),
                    buildHorPakAddress(constraints),
                    buildMap(),
                    addHorPakButton(constraints)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );

      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click From index ==>> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.camera),
          title: ShowTitle(
              title: 'Source Image ${index + 1} ?',
              textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(
              title: 'Please Tab on Camera or Gallery',
              textStyle: MyConstant().h3Style()),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container addHorPakButton(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.all(10),
      width: constraints.maxHeight * 0.6,
      child: ElevatedButton(
        onPressed: () {
          processAddProduct();
        },
        child: Text('เพิ่มสินค้า'),
      ),
    );
  }

  Future<Null> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        //

        MyDialog().showProgressDialog(context);
        String apiSaveProduct =
            '${MyConstant.domain}/bsruhorpak/saveProduct.php';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(100000000);
          String nameFile = 'product$i.jpg';
          paths.add('/product/$nameFile');

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data: data).then(
            (value) async {
              print('อัปโหลดได้');
              loop++;
              if (loop >= files.length) {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                String idOwner = preferences.getString('id')!;
                String nameOwner = preferences.getString('name')!;
                String name = nameController.text;
                String price = priceController.text;
                String detail = detailController.text;
                String address = addressController.text;
                String phone = phoneController.text;
                String images = paths.toString();

                print('### idOwner  $idOwner , name = $nameOwner');
                print(
                  'ชื่อหอ = $name price = $price detaill =$detail address = $address phone = $phone',
                );
                print('รูป ==$images');

                String path =
                    '${MyConstant.domain}/bsruhorpak/insertProduct.php?isAdd=true&idOwner=$idOwner&nameOwner=$nameOwner&name=$name&phone=$phone&price=$price&detail=$detail&address=$address&lat=$lat&lng=$lng&images=$images';
                await Dio().get(path).then(
                      (value) => Navigator.pop(context),
                    );
                Navigator.pop(context);
              }
            },
          );
        }
      } else {
        MyDialog()
            .normalDialog(context, 'รูปยังไม่ครบ', 'กรุณาเลือกรูปให้ครบ ครับ');
      }
    }
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
            width: constraints.maxWidth * 0.75,
            height: constraints.maxWidth * 0.75,
            child: file == null
                ? Image.asset(MyConstant.logo)
                : Image.file(file!)),
        Container(
          width: constraints.maxWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.camera)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.camera)
                      : Image.file(
                          files[1]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.camera)
                      : Image.file(
                          files[2]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.camera)
                      : Image.file(
                          files[3]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHorPak(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'เพิ่มชื่อของหอพัก';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyConstant.primary),
          labelText: 'ชื่อหอพัก :',
          prefixIcon: Icon(Icons.home, color: MyConstant.primary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyConstant.primary,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildHorPakPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: priceController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มราคา';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyConstant.primary),
          labelText: 'ราคา :',
          prefixIcon: Icon(Icons.money, color: MyConstant.primary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyConstant.primary,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          margin: EdgeInsets.only(top: 16),
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

  Widget buildHorPakDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มรายละเอียด';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyConstant.primary),
          labelText: 'รายละเอียด :',
          prefixIcon: Icon(Icons.details, color: MyConstant.primary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyConstant.primary,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildHorPakAddress(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: addressController,
        maxLines: 4,
        // controller: userController,
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'กรุณากรอก User';
        //   } else {
        //     return null;
        //   }
        // },
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyConstant.primary),
          labelText: 'ที่อยู่ :',
          prefixIcon: Icon(Icons.details, color: MyConstant.primary),
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
    );
  }

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
      width: 300,
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
}
