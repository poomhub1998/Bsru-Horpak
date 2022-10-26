import 'dart:convert';

import 'package:bsru_horpak/models/History_model.dart';
import 'package:bsru_horpak/models/Order_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/history_widget.dart';
import 'package:bsru_horpak/widgets/loading_widget.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class History_Screen extends StatefulWidget {
  const History_Screen({Key? key}) : super(key: key);

  @override
  State<History_Screen> createState() => _History_ScreenState();
}

class _History_ScreenState extends State<History_Screen> {
  bool load = true;
  bool? haveData;

  List<OrderModel> orderModels = [];
  List<HistoryModel> historyModels = [];
  HistoryModel? historyModel;
  List<int> ststusInts = [];
  UserModel? userModel;
  OrderModel? orderModel;
  int? index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findOwnerid();
  }

  Future<Null> findOwnerid() async {
    if (historyModels.length != 0) {
      historyModels.clear();
    } else {}
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String id = preferences.getString('id')!;
    print(id);

    String apifindOwner =
        '${MyConstant.domain}/bsruhorpak/getHistoryWhereidOwner.php?isAdd=true&idOwner=$id';
    await Dio().get(apifindOwner).then(
      (value) {
        print(value);
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
            HistoryModel model = HistoryModel.fromMap(item);

            // int status = 0;
            // switch (model.status) {
            //   case 'UserOrder':
            //     status = 0;
            //     break;
            //   case 'OwnerOrder':
            //     status = 1;
            //     break;
            //   case 'Finish':
            //     status = 2;
            //     break;
            //   default:

            setState(() {
              load = false;
              haveData = true;
              historyModels.add(model);
              // ststusInts.add(status);
              print(model);
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
              ? buildContent()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HistoryView(),
                    Center(
                      child: ShowTitle(
                        title: 'ยังไม่มีประวัติ',
                        textStyle: MyConstant().h1Style(),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget buildContent() => ListView.builder(
        itemCount: historyModels.length,
        itemBuilder: (context, index) => Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTitle(
                      title:
                          'วันเวลาที่เข้าพัก ${historyModels[index].dateOrder}',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
              buildHead(),
              buildListHorpak(index),
            ],
          ),
        ),
      );
  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Colors.blue),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: 'หอพัก',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: 'ชื่อผู้ใช้',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: 'เบอร์โทรศัพท์',
              textStyle: MyConstant().h2WhiteStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
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
            flex: 1,
            child: ShowTitle(
              title: historyModels[index].nameProduct,
              textStyle: MyConstant().h3BlackStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ShowTitle(
                title: historyModels[index].nameBuyer,
                textStyle: MyConstant().h3BlackStyle(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  launch('tel://${historyModels[index].phoneBuyer}');
                },
                child: Text(
                  historyModels[index].phoneBuyer,
                  style: MyConstant().h3BlackStyle(),
                ),
              ),
              // ShowTitle(
              //   title: historyModels[index].phoneBuyer,
              //   textStyle: MyConstant().h3BlackStyle(),
              // ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                print('คลิก$historyModels');
                confirmDialogDelete(historyModels[index]);
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> confirmDialogDelete(HistoryModel historyModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowTitle(
            title: 'ลบ ${historyModel.nameProduct} ?',
            textStyle: MyConstant().h2Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## Confirm Delete at id ==> ${historyModel.id}');
              String apiDeleteProductWhereId =
                  '${MyConstant.domain}/bsruhorpak/deleteHistoryWhereId.php?isAdd=true&id=${historyModel.id}';
              await Dio().get(apiDeleteProductWhereId).then((value) {
                Navigator.pop(context);
                findOwnerid();
              });
            },
            child: Text('ลบ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }
}
