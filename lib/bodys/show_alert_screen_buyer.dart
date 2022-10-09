import 'dart:convert';

import 'package:bsru_horpak/models/Order_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:steps_indicator/steps_indicator.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  String? idBuyer;
  bool? haveData;
  bool load = true;
  List<OrderModel> ordermodels = [];
  List<int> ststusInts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findBuyer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จอง'),
      ),
      body: load
          ? ShowProgress()
          : ordermodels.isEmpty
              ? Column(
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
                )
              : buildContent(),
    );
  }

  Widget buildContent() => ListView.builder(
        itemCount: ordermodels.length,
        itemBuilder: (context, index) => Column(
          children: [
            buildNameHorpak(index),
            buildDate(index),
            // buildPrice(index),
            buildHead(),
            buildListHorpak(index),
            buildStepIndicator(ststusInts[index]),
          ],
        ),
      );

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
              title: 'ราคา',
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
              title: ordermodels[index].nameProduct,
              textStyle: MyConstant().h3BlackStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: ordermodels[index].priceProduct,
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
            title: 'ราคา : ${ordermodels[index].priceProduct}',
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
              title: ' วันเวลาที่จอง ${ordermodels[index].dateOrder}'),
        ),
      ],
    );
  }

  Row buildNameHorpak(int index) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowTitle(
            title: 'เจ้าหอพัก ${ordermodels[index].nameOwner}',
            textStyle: MyConstant().h2BlueStyle(),
          ),
        ),
      ],
    );
  }

  Center buildNonOrder() => Center(child: Text('ไม่มีข้อมูล'));

  Future<Null> findBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
    print('idUser = $idBuyer');
    loadValueFromAPI();
    // readOrderFromIdUser();
  }

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
  Future<Null> loadValueFromAPI() async {
    if (ordermodels.length != 0) {
      ordermodels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiGetOrderWhereIdBuyer =
        '${MyConstant.domain}/bsruhorpak/getOrderWhereidBuyer.php?isAdd=true&idBuyer=$idBuyer';
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
            print('$value');
            int status = 0;
            switch (model.status) {
              case 'UserOrder':
                status = 0;
                break;
              case 'OwnerOrder':
                status = 1;
                break;
              case 'Finish':
                status = 3;
                break;
              default:
            }
            setState(() {
              load = false;
              haveData = true;
              ordermodels.add(model);
              ststusInts.add(status);
            });
          }
        }
      },
    );
  }
}
