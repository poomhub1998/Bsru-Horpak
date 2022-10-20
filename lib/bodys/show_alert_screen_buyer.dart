import 'dart:convert';

import 'package:bsru_horpak/main.dart';
import 'package:bsru_horpak/models/Order_model.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    finfBuyer();

    // finalLocationData();
    // findBuyer();
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
          title: Text('หน้าสถานะการจอง'),
        ),
        body: load
            ? ShowProgress()
            : haveData!
                ? buildContent()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: ShowImage(
                          path: MyConstant.logo,
                        ),
                      ),
                      Center(
                        child: ShowTitle(
                          title: 'ยังไม่มีข้อมูลการจอง',
                          textStyle: MyConstant().h1Style(),
                        ),
                      ),
                    ],
                  ));
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
        RaisedButton.icon(
          color: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: ListTile(
                  title: ShowTitle(
                    title:
                        'ยกเลิกหารจอง หอพัก${orderModels[index].nameProduct} ?',
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
                          MyDialog()
                              .normalDialog(context, 'ยกเลิกการจอง', 'สำเร็จ');
                        },
                      );
                      await finfBuyer();
                    },
                    child: Text('ยืนยัน'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('ยกเลิก'),
                  ),
                ],
              ),
            );
            // print('กดยกเลิก');
          },
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          label: Text(
            'ยกเลิกการจอง',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
              Text('จอง'),
              Text('ตอบรับ'),
              Text('เสร็จสิ้น'),
            ],
          )
        ],
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: 'ชื่อหอพัก',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: 'ราคา/เดือน',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildListHorpak(int index) {
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
            child: ShowTitle(
              title: '${orderModels[index].priceProduct} บาท',
              textStyle: MyConstant().h3BlackStyle(),
            ),
          ),
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
            title: 'ราคา : ${orderModels[index].priceProduct}',
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
          padding: const EdgeInsets.only(left: 8),
          child: ShowTitle(
              title: ' วันเวลาที่จอง ${orderModels[index].dateOrder}'),
        ),
      ],
    );
  }

  Row buildNameHorpak(int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ShowTitle(
                title: 'เจ้าหอพัก${orderModels[index].nameOwner} ',
                textStyle: MyConstant().h2BlueStyle(),
              ),
              ShowTitle(
                title: ' ${orderModels[index].phoneOwner} ',
                textStyle: MyConstant().h2BlueStyle(),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: orderModels[index].phoneOwner),
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
        ),
      ],
    );
  }

  Center buildNonOrder() => Center(
        child: Text('ไม่มีข้อมูล'),
      );

  // Future<Null> findBuyer() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   idBuyer = preferences.getString('id');
  //   print('idUser = $idBuyer');
  //   // loadValueFromAPI();
  //   // readOrderFromIdUser();

  // }

  // Future<Null> readOrderFromidBuyer() async {
  //   if (idBuyer != null) {
  //     String url =
  //         '${MyConstant.domain}/bsruhorpak/getOrderWhereidBuyer.php?isAdd=true&idBuyer=$idBuyer';
  //     Response response = await Dio().get(url);
  //     print('response $response');
  //     // if (response.toString() != 'null') {
  //     //   setState(() {
  //     //     load = false;
  //     //   });
  //     // }
  //     if (response.toString() == 'null') {
  //       setState(() {
  //         load = false;
  //         haveData = false;
  //       });
  //     } else {
  //       for (var item in jsonDecode(response.data)) {
  //         OrderModel model = OrderModel.fromJson(item);
  //         setState(() {
  //           load = false;
  //           haveData = true;
  //           ordermodels.add(model);
  //         });
  //       }
  //     }
  //   }
  // }

}
