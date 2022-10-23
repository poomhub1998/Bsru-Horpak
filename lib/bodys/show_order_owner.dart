import 'dart:convert';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:bsru_horpak/models/Order_model.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowOrderOwner extends StatefulWidget {
  const ShowOrderOwner({Key? key}) : super(key: key);

  @override
  State<ShowOrderOwner> createState() => _ShowOrderOwnerState();
}

class _ShowOrderOwnerState extends State<ShowOrderOwner> {
  bool load = true;
  bool? haveData;

  List<OrderModel> orderModels = [];
  List<int> ststusInts = [];
  UserModel? userModel;
  OrderModel? orderModel;
  int? index = 1;

  @override
  void initState() {
    super.initState();

    findOwnerid(ststusInts);
  }

  Future<Null> findOwnerid(List<int> ststusInts) async {
    if (orderModels.length != 0) {
      orderModels.clear();
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String id = preferences.getString('id')!;
    print(id);

    String apifindOwner =
        '${MyConstant.domain}/bsruhorpak/getOrderWhereIdOwner.php?isAdd=true&idOwner=$id';
    await Dio().get(apifindOwner).then(
      (value) {
        if (value.toString() == 'null') {
          // No Data

          setState(() {
            load = false;
            haveData = false;
          });
        } else {
          // editStatus() async {
          //   String editStatus =
          //       '${MyConstant.domain}/bsruhorpak/editOrderWhereIdOwner.php?isAdd=true&id=$id&status=OwnerOrder';
          //   print('id $id');
          //   if (id != null && id.isNotEmpty) {
          //     Dio().get(editStatus).then((value) => print('เปลี่ยนสำเร็จ '));
          //   }
          // }

          for (var item in jsonDecode(value.data)) {
            OrderModel model = OrderModel.fromMap(item);
            print(model.idProduct);
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
            });
          }
        }

        // print('Date = ${model.dateOrder}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: orderModels.length,
                  itemBuilder: (context, index) => Card(
                    color: index % 2 == 0 ? Colors.white : Colors.grey[120],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShowTitle(
                                  title:
                                      '${index + 1} ชิ่อผู้จอง ${orderModels[index].nameBuyer}',
                                  textStyle: MyConstant().h2BlueStyle()),
                              TextButton(
                                onPressed: () {
                                  launch(
                                      'tel://${orderModels[index].phoneBuyer}');
                                },
                                child: Text(orderModels[index].phoneBuyer),
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     launch(
                              //         'tel://${orderModels[index].phoneOwner}');
                              //     // Clipboard.setData(
                              //     //   ClipboardData(text: orderModels[index].phoneOwner),
                              //     // );
                              //     // showToast('คัดลอกเบอร์โทรศัพท์แล้ว');
                              //   },
                              //   icon: Icon(
                              //     Icons.phone,
                              //     size: 16,
                              //   ),
                              // )
                            ],
                          ),
                          Text(orderModels[index].dateOrder),
                          buildTitle(),
                          buildListHorpak(index),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RaisedButton.icon(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: ListTile(
                                        title: ShowTitle(
                                          title:
                                              'ยกเลิก ${orderModels[index].nameBuyer} ?',
                                          textStyle: MyConstant().h2Style(),
                                        ),
                                        subtitle: ShowTitle(
                                          title: orderModels[index].nameProduct,
                                          textStyle: MyConstant().h3Style(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? id =
                                                preferences.getString('id');
                                            String? idOrder =
                                                orderModels[index].idOrder;
                                            String? status = 'OwnerOrder';
                                            String? idBuyer =
                                                orderModels[index].idBuyer;
                                            print(' idOrder $idOrder');

                                            String? deleteReserve =
                                                '${MyConstant.domain}/bsruhorpak/deleteReservetableWhereIdOrder.php?isAdd=true&idOrder=$idOrder';
                                            await Dio().get(deleteReserve).then(
                                              (value) {
                                                String urlfindTokenBuyer =
                                                    '${MyConstant.domain}/bsruhorpak/getUserWhereid.php?isAdd=true&id=$idBuyer';
                                                Dio()
                                                    .get(urlfindTokenBuyer)
                                                    .then(
                                                  (value) async {
                                                    var resul =
                                                        jsonDecode(value.data);
                                                    // print('value $resul');
                                                    for (var json in resul) {
                                                      // print(json);
                                                      UserModel model =
                                                          UserModel.fromMap(
                                                              json);
                                                      // print('model5555 $model');
                                                      String tokenBuyer =
                                                          model.token;
                                                      print(
                                                          'TokenOwner $tokenBuyer');
                                                      String title =
                                                          'ขออภัยการจองของคุณถูกยกเลิก';
                                                      String body = '';
                                                      String urlSendToken =
                                                          '${MyConstant.domain}/bsruhorpak/apiNotification.php?isAdd=true&token=$tokenBuyer&title=$title&body=$body';
                                                      print(
                                                          'tile $title body $body tokenBuyer $tokenBuyer');
                                                      await Dio()
                                                          .get(urlSendToken)
                                                          .then(
                                                        (value) async {
                                                          Navigator.pushNamed(
                                                              context,
                                                              MyConstant
                                                                  .routOwner);

                                                          MyDialog()
                                                              .normalDialog(
                                                                  context,
                                                                  'ยกเลิก',
                                                                  'สำเร็จ');
                                                        },
                                                      );
                                                    }
                                                  },
                                                );
                                                Navigator.pop(context,
                                                    MyConstant.routOwner);
                                                MyDialog().normalDialog(context,
                                                    'ยกเลิกการจอง', 'สำเร็จ');
                                              },
                                            );
                                            await findOwnerid(ststusInts);
                                          },
                                          child: Text('ยืนยัน'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ยกเลิก'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'ยกเลิก',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              RaisedButton.icon(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: ListTile(
                                        title: ShowTitle(
                                          title:
                                              'ตอบรับ ${orderModels[index].nameBuyer} ?',
                                          textStyle: MyConstant().h2Style(),
                                        ),
                                        subtitle: ShowTitle(
                                          title:
                                              'ชื่อหอพัก ${orderModels[index].nameProduct}',
                                          textStyle: MyConstant().h3Style(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? id =
                                                preferences.getString('id');
                                            String? idOrder =
                                                orderModels[index].idOrder;
                                            String? status = 'OwnerOrder';
                                            String? idBuyer =
                                                orderModels[index].idBuyer;
                                            print(' idOrder $idOrder');

                                            String apiDeleteProductWhereId =
                                                '${MyConstant.domain}/bsruhorpak/editOrderWhereIdOwner.php?isAdd=true&idOrder=$idOrder&status=$status';
                                            await Dio()
                                                .get(apiDeleteProductWhereId)
                                                .then(
                                              (value) {
                                                String urlfindTokenBuyer =
                                                    '${MyConstant.domain}/bsruhorpak/getUserWhereid.php?isAdd=true&id=$idBuyer';
                                                Dio()
                                                    .get(urlfindTokenBuyer)
                                                    .then(
                                                  (value) async {
                                                    var resul =
                                                        jsonDecode(value.data);
                                                    // print('value $resul');
                                                    for (var json in resul) {
                                                      // print(json);
                                                      UserModel model =
                                                          UserModel.fromMap(
                                                              json);
                                                      // print('model5555 $model');
                                                      String tokenBuyer =
                                                          model.token;
                                                      print(
                                                          'TokenOwner $tokenBuyer');
                                                      String title =
                                                          'เจ้าของหอตอบรับแล้ว';
                                                      String body =
                                                          'กดเพื่อดูรายละเอียด';
                                                      String urlSendToken =
                                                          '${MyConstant.domain}/bsruhorpak/apiNotification.php?isAdd=true&token=$tokenBuyer&title=$title&body=$body';
                                                      print(
                                                          'tile $title body $body tokenBuyer $tokenBuyer');
                                                      await Dio()
                                                          .get(urlSendToken)
                                                          .then(
                                                        (value) async {
                                                          Navigator.pushNamed(
                                                              context,
                                                              MyConstant
                                                                  .routOwner);

                                                          MyDialog()
                                                              .normalDialog(
                                                                  context,
                                                                  'ยกเลิก',
                                                                  'สำเร็จ');
                                                        },
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                            await findOwnerid(ststusInts);
                                            print('ทำต้องนี้');
                                          },
                                          child: Text('ตอบรับ'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ยกเลิก'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.add_task,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'ตอบรับ',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton.icon(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                onPressed: () async {
                                  String? status = 'Finish';
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: ListTile(
                                        title: ShowTitle(
                                          title:
                                              'ผู้ใช้ ${orderModels[index].nameBuyer} เข้าอยู่แล้ว',
                                          textStyle: MyConstant().h2Style(),
                                        ),
                                        subtitle: ShowTitle(
                                          title:
                                              'ชื่อหอพัก ${orderModels[index].nameProduct}',
                                          textStyle: MyConstant().h3Style(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? id =
                                                preferences.getString('id');
                                            String? idBuyer =
                                                orderModels[index].idBuyer;
                                            String? nameBuyer =
                                                orderModels[index].nameBuyer;

                                            String? idOwner =
                                                orderModels[index].idOwner;
                                            String? nameOwner =
                                                orderModels[index].nameOwner;
                                            String? phoneOwner =
                                                orderModels[index].phoneOwner;
                                            String? idOrder =
                                                orderModels[index].idOrder;
                                            String? nameProduct =
                                                orderModels[index].nameProduct;
                                            String? priceProduct =
                                                orderModels[index].priceProduct;
                                            String? phoneBuyer =
                                                orderModels[index].phoneBuyer;

                                            String apiDeleteProductWhereId =
                                                '${MyConstant.domain}/bsruhorpak/editOrderWhereIdOwner.php?isAdd=true&idOrder=$idOrder&status=$status';
                                            await Dio()
                                                .get(apiDeleteProductWhereId)
                                                .then(
                                              (value) {
                                                String? indasd =
                                                    '${MyConstant.domain}/bsruhorpak/insertHistory.php?isAdd=true&id=$id&idOwner=$idOwner&nameOwner=$nameOwner&phoneOwner=$phoneOwner&idBuyer=$idBuyer&nameBuyer=$nameBuyer&phoneBuyer=$phoneBuyer&nameProduct=$nameProduct';
                                                Dio()
                                                    .get(indasd)
                                                    .then((value) => null);
                                                String? deleteReserve =
                                                    '${MyConstant.domain}/bsruhorpak/deleteReservetableWhereIdOrder.php?isAdd=true&idOrder=$idOrder';
                                                Dio()
                                                    .get(deleteReserve)
                                                    .then((value) async {});
                                                Navigator.pushNamed(context,
                                                    MyConstant.routOwner);
                                                MyDialog().normalDialog(context,
                                                    'ผู้ใช้เข้าอยู่', 'สำเร็จ');
                                                findOwnerid(ststusInts);
                                              },
                                            );
                                          },
                                          child: Text('เข้าอยู่แล้ว'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ยกเลิก'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.add_home_work,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'ผู้ใช้เข้าอยู่แล้ว',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          buildStepIndicator(ststusInts[index]),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: ' ยังไม่มีการจอง',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'ในขณะนี้', textStyle: MyConstant().h2Style()),
                    ],
                  ),
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
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: orderModels[index].priceProduct,
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStepIndicator(index) => Column(
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

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('ชื่อหอพัก'),
          ),
          Expanded(
            flex: 1,
            child: Text('ราคา'),
          ),
        ],
      ),
    );
  }

  Future<Null> editStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    String? idProduct = preferences.getString('idProduct');
  }
}
