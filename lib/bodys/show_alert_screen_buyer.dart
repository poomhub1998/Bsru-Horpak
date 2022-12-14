import 'dart:convert';

import 'package:bsru_horpak/main.dart';
import 'package:bsru_horpak/models/Order_model.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/loading_widget.dart';
import 'package:bsru_horpak/widgets/location_widget.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import 'package:url_launcher/url_launcher.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  String? idBuyer;
  bool? haveData;
  bool load = true;
  List<OrderModel> orderModels = [];
  List<int> ststusInts = [];
  List<ProductModel> productModels = [];
  ProductModel? productModel;
  OrderModel? orderModel;
  double? lat, lng, lat2, lng2, distance;

  CameraPosition? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    finfBuyer();
    finalLocationData();
    // findLatLng();

    // findBuyer();
  }

  Future<LocationData?> finalLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
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
        // print('lat = $lat2 log = $lng2');
      });
    } catch (e) {}
  }

  Future<Null> finfBuyer() async {
    if (orderModels.length != 0) {
      orderModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiGetOrderWhereIdBuyer =
        '${MyConstant.domain}/bsruhorpak/getOrderWhereIdBuyer.php?isAdd=true&idBuyer=$id';
    await Dio().get(apiGetOrderWhereIdBuyer).then(
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
            OrderModel model = OrderModel.fromMap(item);

            int status = 0;
            switch (model.status) {
              case 'UserOrder':
                status = 0;
                break;
              case 'OwnerOrder':
                status = 1;
                break;
              case 'Finish':
                status = 2;
                break;
              default:
            }
            setState(() {
              load = false;
              haveData = true;
              orderModels.add(model);
              ststusInts.add(status);
              // print(model);
            });
          }
        }
      },
    );
  }

  // Future<LocationData?> finalLocationData() async {
  //   Location location = Location();
  //   try {
  //     return await location.getLocation();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('?????????????????????????????????????????????'),
        actions: [
          // LocationView(),
        ],
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? buildContent()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/images/watching-you-cat.gif",
                    // ),
                    Container(
                      child: LoadingView(),
                    ),
                    Center(
                      child: ShowTitle(
                        title: '????????????????????????????????????????????????????????????',
                        textStyle: MyConstant().h1Style(),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget buildContent() => ListView.builder(
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Card(
          child: Column(
            children: [
              buildNameHorpak(index),
              buildDate(index),

              // buildPrice(index),
              buildHead(),
              buildListHorpak(index),

              buildStepIndicator(ststusInts[index]),
              buildbutton(index),

              TextButton(
                onPressed: () async {
                  LocationData? locationData = await finalLocationData();
                  setState(
                    () {
                      lat = locationData!.latitude;
                      lng = locationData.longitude;
                      lat2 = double.parse(orderModels[index].lat);
                      lng2 = double.parse(orderModels[index].lng);
                      print(
                          'lat ==$lat lng == $lng lat2 == $lat2 lng2 == $lng2');

                      // print('distance = $distance');
                      // print('transport ==> $transport');
                      showDialog(
                        context: context,
                        builder: (context) => Container(
                          child: StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: ListTile(
                                leading: ShowImage(path: MyConstant.logo),
                                title: ShowTitle(
                                  title: orderModels[index].nameProduct,
                                  textStyle: MyConstant().h2Style(),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child:
                                    lat2 == null ? ShowProgress() : showMap(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '???????????????????????? ',
                      style: TextStyle(fontSize: 20),
                    ),
                    LocationView(),
                  ],
                ),
              ),

              // showMap(),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 16),
              //   width: 250,
              //   height: 150,
              //   child: GoogleMap(
              //     initialCameraPosition: CameraPosition(
              //       target: LatLng(
              //         double.parse(orderModels[index].lat),
              //         double.parse(orderModels[index].lng),
              //       ),
              //       zoom: 16,
              //     ),
              //     markers: <Marker>[
              //       Marker(
              //           markerId: MarkerId('id'),
              //           position: LatLng(
              //             double.parse(orderModels[index].lat),
              //             double.parse(orderModels[index].lng),
              //           ),
              //           infoWindow: InfoWindow(
              //               title: 'You Here ',
              //               snippet:
              //                   'lat = ${orderModels[index].lat}, lng = ${orderModels[index].lng}')),
              //     ].toSet(),
              //   ),
              // ),

              // buildDivider(),
            ],
          ),
        ),
      );

  Divider buildDivider() {
    return Divider(
      color: Colors.black,
    );
  }

  Row buildbutton(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: ListTile(
                      title: ShowTitle(
                        title:
                            '???????????????????????????????????? ???????????????${orderModels[index].nameProduct} ?',
                        textStyle: MyConstant().h2Style(),
                      ),
                      subtitle: ShowTitle(
                        title: '',
                        textStyle: MyConstant().h3Style(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          String? id = preferences.getString('id');
                          String? idOrder = orderModels[index].idOrder;

                          print(' idOrder ${orderModels[index].idOrder}');

                          String? deleteReserve =
                              '${MyConstant.domain}/bsruhorpak/deleteReservetableWhereIdOrder.php?isAdd=true&idOrder=$idOrder';
                          await Dio().get(deleteReserve).then(
                            (value) {
                              Navigator.pop(context, MyConstant.routBuyer);
                              MyDialog().normalDialog(
                                  context, '????????????????????????????????????', '??????????????????');
                            },
                          );
                          await finfBuyer();
                        },
                        child: Text(
                          '??????????????????',
                          style:
                              TextStyle(color: Color.fromARGB(255, 223, 5, 5)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          '??????????????????',
                          style:
                              TextStyle(color: Color.fromARGB(255, 1, 177, 71)),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.cancel),
              label: Text('????????????????????????????????????')),
        ),
        // RaisedButton.icon(
        //   color: Colors.red,
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        //   onPressed: () async {
        //     showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         title: ListTile(
        //           title: ShowTitle(
        //             title:
        //                 '???????????????????????????????????? ???????????????${orderModels[index].nameProduct} ?',
        //             textStyle: MyConstant().h2Style(),
        //           ),
        //           subtitle: ShowTitle(
        //             title: '',
        //             textStyle: MyConstant().h3Style(),
        //           ),
        //         ),
        //         actions: [
        //           TextButton(
        //             onPressed: () async {
        //               SharedPreferences preferences =
        //                   await SharedPreferences.getInstance();
        //               String? id = preferences.getString('id');
        //               String? idOrder = orderModels[index].idOrder;

        //               print(' idOrder ${orderModels[index].idOrder}');

        //               String? deleteReserve =
        //                   '${MyConstant.domain}/bsruhorpak/deleteReservetableWhereIdOrder.php?isAdd=true&idOrder=$idOrder';
        //               await Dio().get(deleteReserve).then(
        //                 (value) {
        //                   Navigator.pop(context, MyConstant.routBuyer);
        //                   MyDialog()
        //                       .normalDialog(context, '????????????????????????????????????', '??????????????????');
        //                 },
        //               );
        //               await finfBuyer();
        //             },
        //             child: Text(
        //               '??????????????????',
        //               style: TextStyle(color: Color.fromARGB(255, 223, 5, 5)),
        //             ),
        //           ),
        //           TextButton(
        //             onPressed: () => Navigator.pop(context),
        //             child: Text(
        //               '??????????????????',
        //               style: TextStyle(color: Color.fromARGB(255, 1, 177, 71)),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //     // print('????????????????????????');
        //   },
        //   icon: Icon(
        //     Icons.cancel,
        //     color: Colors.white,
        //   ),
        //   label: Text(
        //     '????????????????????????????????????',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
      ],
    );
  }

  Widget buildStepIndicator(int index) => Column(
        children: [
          StepsIndicator(
            lineLength: 110,
            selectedStep: index,
            nbSteps: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('?????????'),
              Text('??????????????????'),
              Text('???????????????????????????'),
            ],
          )
        ],
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: MyConstant.dark),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: '???????????????????????????',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: '????????????/???????????????',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildListHorpak(index) {
    // print('lat2 $lat2 lng2 $lng2');

    // print('lat $lat lng $lng');

    return Container(
      padding: EdgeInsets.only(left: 8),
      // decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: orderModels[index].nameProduct,
              textStyle: MyConstant().h3BlackStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShowTitle(
                title: '${orderModels[index].priceProduct} ?????????',
                textStyle: MyConstant().h3BlackStyle(),
              ),
            ),

            //     Container(
            //   color: Colors.grey,
            //   width: 250,
            //   height: 150,
            //   child: lat == null
            //       ? ShowProgress()
            //       : GoogleMap(
            //           initialCameraPosition: CameraPosition(
            //             target: LatLng(lat!, lng!),
            //             zoom: 16,
            //           ),
            //           onMapCreated: (controller) {},
            //           // markers: setMarker(),
            //         ),
            // ),
          )
        ],
      ),
    );
  }

  Row buildPrice(int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowTitle(
            title: '???????????? : ${orderModels[index].priceProduct}',
            textStyle: MyConstant().h3BlackStyleBold(),
          ),
        ),
      ],
    );
  }

  Row buildDate(int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 10),
          child: ShowTitle(title: ' ??????????????????????????? ${orderModels[index].dateOrder}'),
        ),
      ],
    );
  }

  Row buildNameHorpak(int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              ShowTitle(
                title: '????????????????????????????????????${orderModels[index].nameOwner} ',
                textStyle: MyConstant().h2BlueStyle(),
              ),
              ShowTitle(
                title: ' ${orderModels[index].phoneOwner} ',
                textStyle: MyConstant().h3BlackStyleBold(),
              ),
              IconButton(
                onPressed: () {
                  launch('tel://${orderModels[index].phoneOwner}');
                  // Clipboard.setData(
                  //   ClipboardData(text: orderModels[index].phoneOwner),
                  // );
                  // showToast('?????????????????????????????????????????????????????????????????????');
                },
                icon: Icon(
                  Icons.phone,
                  size: 16,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Center buildNonOrder() => Center(
        child: Text('?????????????????????????????????'),
      );

  void showToast(String? string) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(string!),
        action: SnackBarAction(
            label: '?????????', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Container showMap() {
    if (lat2 != null) {
      LatLng latLng1 = LatLng(lat2!, lng2!);
      position = CameraPosition(target: latLng1, zoom: 17);
    }
    Marker userMarker() {
      return Marker(
        markerId: MarkerId('userMarker'),
        position: LatLng(lat!, lng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
        infoWindow: InfoWindow(title: '???????????????????????????????????????'),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(lat2!, lng2!),
        icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
        infoWindow: InfoWindow(title: '???????????????'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[shopMarker(), userMarker()].toSet();
    }

    return Container(
      height: 250,
      width: 250,
      color: Colors.grey,
      child: lat2 == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: position!,
              mapType: MapType.normal,
              onMapCreated: (context) {},
              markers: mySet(),
            ),
    );
  }
}
