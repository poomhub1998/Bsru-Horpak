import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/sqlite_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/utility/sqlite_heiper.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_signuot.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //ตัวแปร
  String? currentIdOwner;
  UserModel? userModel;
  ProductModel? productModel;
  double? lat1, lng1, lat2, lng2, distance;
  String? distanceString;
  int? transport;
  CameraPosition? position;
  bool load = true;
  bool? haveData;
  final formKey = GlobalKey<FormState>();

  List<UserModel> userModels = [];
  List<ProductModel> productModels = [];
  List<List<String>> lisImages = [];
  int indexImage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadValueFromAPI();
    // readreserve();

    finalLocationData();
    findUserModel();
  }

  // Future<Null> readreserve() async {
  //   await SQLiteHelper().readSQLite().then((value) {
  //     if (value.length != 0) {
  //       List<SQLiteHelper> models = [];
  //       for (var model in value) {
  //         models.add(model);
  //       }
  //       currentIdOwner = model[0];
  //     }
  //   });
  // }

  Future<Null> loadValueFromAPI() async {
    if (productModels.length != 0) {
      productModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiGetProductWhereIdProduct =
        '${MyConstant.domain}/bsruhorpak/getProductWhereTypeOwner.php';
    await Dio().get(apiGetProductWhereIdProduct).then(
      (value) {
        if (value.toString() == 'null') {
          // No Data

          setState(() {
            load = false;
            haveData = false;
          });
        } else {
          // Have Data
          for (var item in jsonDecode(value.data)) {
            ProductModel model = ProductModel.fromMap(item);
            String string = model.images;
            string = string.substring(1, string.length - 1);
            List<String> strings = string.split(',');
            int i = 0;
            for (var item in strings) {
              strings[i] = item.trim();
              i++;
            }
            lisImages.add(strings);

            setState(() {
              load = false;
              haveData = true;
              productModels.add(model);
            });
          }
        }
      },
    );
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    // print('## id Logined ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      print('vulue === $value');
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          // print('name login ${userModel!.name}');
        });
      }
    });
  }

  Future<LocationData?> finalLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  int calculateTransport(double distance) {
    int transport;
    if (distance < 1.0) {
      transport = 5;
      return transport;
    } else {
      transport = 5 + (distance - 1).round() * 1;
      return transport;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
        title: Text('หอพักทั้งหมด'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(
                    FocusNode(),
                  ),
                  child: Form(
                    key: formKey,
                    child: Stack(
                      children: [
                        buildSearch(size),
                        Padding(
                          padding: const EdgeInsets.only(top: 75),
                          child: LayoutBuilder(
                            builder: (context, constraints) =>
                                buildListView(constraints),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'ไม่มีข้อมูลหอพักในขณะนี้',
                          textStyle: MyConstant().h1Style()),
                    ],
                  ),
                ),
    );
  }

  Row buildSearch(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          width: size * 0.90,
          height: size * 0.5,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 0),
            child: TextFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: MyConstant.primary),
                labelText: 'ค้นหา :',
                prefixIcon: Icon(Icons.search, color: MyConstant.primary),
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
        ),
      ],
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/bsruhorpak${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => SingleChildScrollView(
        child: GestureDetector(
          onTap: () async {
            print('คลิก ${productModels[index].id}');

            LocationData? locationData = await finalLocationData();
            setState(
              () {
                lat1 = locationData!.latitude;
                lng1 = locationData.longitude;
                lat2 = double.parse(productModels[index].lat);
                lng2 = double.parse(productModels[index].lng);
                print('lat1 = $lat1, lng1 = $lng1, lat2 = $lat2, lng2 = $lng2');
                distance = calculateDistance(lat1!, lng1!, lat2!, lng2!);
                print('sssss$distance');
                var myFormat = NumberFormat('##.0#', 'en_US');
                distanceString = myFormat.format(distance);

                transport = calculateTransport(distance!);

                print('distance = $distance');
                print('transport ==> $transport');
              },
            );

            showAlerlDialog(
              productModels[index],
              lisImages[index],
            );
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  width: constraints.maxWidth * 0.5 - 4,
                  height: constraints.maxWidth * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.4,
                        height: constraints.maxWidth * 0.4,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: createUrl(productModels[index].images),
                          placeholder: (context, url) => ShowProgress(),
                          errorWidget: (context, url, error) =>
                              ShowImage(path: MyConstant.logo),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5 - 4,
                  height: constraints.maxWidth * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShowTitle(
                              title: 'ชื่อหอพัก: ${productModels[index].name}',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                      ShowTitle(
                          title: 'ราคา: ${productModels[index].price} บาท',
                          textStyle: MyConstant().h3Style()),
                      ShowTitle(
                          title: 'รายละเอียด:',
                          textStyle: MyConstant().h3Style()),
                      ShowTitle(
                          title: cutWrod('  ${productModels[index].detail}'),
                          textStyle: MyConstant().h3Style()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> showAlerlDialog(
      ProductModel productModels, List<String> images) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: ListTile(
                  leading: ShowImage(path: MyConstant.logo),
                  title: ShowTitle(
                    title: productModels.name,
                    textStyle: MyConstant().h2Style(),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            '${MyConstant.domain}/bsruhorpak${images[indexImage]}',
                        placeholder: (context, url) => ShowProgress(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  indexImage = 0;
                                  print('### indexImage = $indexImage');
                                });
                              },
                              icon: Icon(Icons.filter_1),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  indexImage = 1;
                                  print('### indexImage = $indexImage');
                                });
                              },
                              icon: Icon(Icons.filter_2),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  indexImage = 2;
                                  print('### indexImage = $indexImage');
                                });
                              },
                              icon: Icon(Icons.filter_3),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  indexImage = 3;
                                  print('### indexImage = $indexImage');
                                });
                              },
                              icon: Icon(Icons.filter_4),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ShowTitle(
                              title: 'ราคา :',
                              textStyle: MyConstant().h3Style()),
                          ShowTitle(
                              title: ' ${productModels.price} บาท/เดือน',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                      Row(
                        children: [
                          ShowTitle(
                              title: 'ที่อยู่ :',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Container(
                                width: 200,
                                child: ShowTitle(
                                    title: productModels.address,
                                    textStyle: MyConstant().h3Style())),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ShowTitle(
                                title: 'รายละเอียด :',
                                textStyle: MyConstant().h3Style()),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                                width: 200,
                                child: ShowTitle(
                                    title: productModels.detail,
                                    textStyle: MyConstant().h3Style())),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ShowTitle(
                              title: 'เบอร์โทรศัพท์ :',
                              textStyle: MyConstant().h3Style()),
                          ShowTitle(
                              title: ' ${productModels.phone} ',
                              textStyle: MyConstant().h3Style()),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: productModels.phone),
                              );
                              // MyDialog().normalDialog(context, 'คักลอก',
                              //     'คักลอกเบอร์โทรศัพท์สำเร็จ');
                            },
                            icon: Icon(
                              Icons.copy,
                              size: 16,
                              color: MyConstant.primary,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          ShowTitle(
                              title: distance == null
                                  ? ''
                                  : 'ระยะทาง : $distanceString กิโลเมตร',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                      showMap()

                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.android),
                      // ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          String idOwner = productModels.idOwner;
                          String idProduct = productModels.id;
                          String name = productModels.name;
                          String phone = productModels.phone;
                          String price = productModels.price;
                          SQLiteModel sqLiteModel = SQLiteModel(
                              idOwner: idOwner,
                              idProduct: idProduct,
                              name: name,
                              phone: phone,
                              price: price);
                          print(
                              '### idOwner == $idOwner, idProduct ==$idProduct, name ==$name, phone ==$phone , price==$price');

                          await SQLiteHelper()
                              .insertValueToSQLite(sqLiteModel)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'จองหอพัก',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1!, lng1!);
      position = CameraPosition(target: latLng1, zoom: 11);
    }
    Marker userMarker() {
      return Marker(
        markerId: MarkerId('userMarker'),
        position: LatLng(lat1!, lng1!),
        icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
        infoWindow: InfoWindow(title: 'คุณอยู่ที่นี้'),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(lat2!, lng2!),
        icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
        infoWindow: InfoWindow(title: 'หอพัก'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[userMarker(), shopMarker()].toSet();
    }

    return Container(
      height: 250,
      // color: Colors.grey,
      child: lat1 == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: position!,
              mapType: MapType.normal,
              onMapCreated: (context) {},
              markers: mySet(),
            ),
    );
  }

  String cutWrod(String string) {
    String result = string;
    if (result.length >= 100) {
      result = result.substring(0, 150);
      result = '$result....';
    }
    return result;
  }
}
