import 'dart:async';
import 'dart:convert';
import 'package:bsru_horpak/models/Order_model.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/loading_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/sqlite_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/utility/sqlite_heiper.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowReserve extends StatefulWidget {
  const ShowReserve({Key? key}) : super(key: key);

  @override
  State<ShowReserve> createState() => _ShowReserveState();
}

class _ShowReserveState extends State<ShowReserve> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  ProductModel? productModel;
  int? total;
  String? idBuyer;
  String? dateTimeStr;
  int index = 0;
  bool? haveData;

  List<OrderModel> orderModels = [];
  List<int> ststusInts = [];
  List<ProductModel> productModels = [];

  OrderModel? orderModel;
  double? lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    // findDeraiIdOwner();
    findUserModel();
    processReadSQLite();
    findIdBuyer();
    finfBuyer();
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

  Future<void> findIdBuyer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
    // print('เวลา = $dateTimeStr');
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isEmpty) {
      sqliteModels.clear();
    }
    await SQLiteHelper().readSQLite().then((value) {
      setState(() {
        load = false;
        sqliteModels = value;
        // findDeraiIdOwner();
        // calculateTotal();
      });
    });
  }

  // void calculateTotal() async {
  //   total = 0;
  //   for (var item in sqliteModels) {
  //     int sumInt = int.parse(item.sum.trim());
  //     setState(() {
  //       total = total! + sumInt;
  //     });
  //   }
  // }

  // Future<void> findDeraiIdOwner() async {
  //   String idOwner = sqliteModels[index].idProduct;
  //   print('### idadsad ===> $idOwner');
  //   print('เวลา $dateTimeStr');
  //   String apiGetUserWhereId =
  //       '${MyConstant.domain}/bsruhorpak/getProductWhereIdOwner.php?isAdd=true&idOwner=$idOwner';
  //   await Dio().get(apiGetUserWhereId).then((value) {
  //     for (var item in jsonDecode(value.data)) {
  //       setState(() {
  //         productModel = ProductModel.fromMap(item);
  //       });
  //     }
  //   });
  // }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    // print('## id Logined ==> $id');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetUserWhereId).then((value) {
      // print('vulue === $value');
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          // print('name login ${userModel!.name}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หอพักที่คุณสนใจ'),
      ),
      body: load
          ? ShowProgress()
          : sqliteModels.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingView(),
                    ShowTitle(
                      title: 'ยังไม่ได้เลือกหอพัก',
                      textStyle: MyConstant().h1Style(),
                    ),
                  ],
                )

              // Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         width: 200,
              //         child: ShowImage(
              //           path: MyConstant.logo,
              //         ),
              //       ),
              //       Center(
              //         child: ShowTitle(
              //           title: 'ยังไม่ได้เลือกหอพัก',
              //           textStyle: MyConstant().h1Style(),
              //         ),
              //       ),
              //     ],
              //   )
              : buildContent(),
    );
  }

  Column buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showHorpak(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShowTitle(
                title: 'เวลา :',
                textStyle: MyConstant().h3Style(),
              ),
            ),
            ShowTitle(
              title: dateTimeStr == null ? 'dd/MM/yy ' : dateTimeStr!,
              textStyle: MyConstant().h3Style(),
            ),
          ],
        ),
        buildHead(),
        listHorpak(),
        buildDivider(),
        buttonController(),
        Row(
          children: [
            Expanded(child: SizedBox()),
          ],
        )
      ],
    );
  }

  Future<void> confirmEmptyCart() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(path: MyConstant.logo),
                title: ShowTitle(
                  title: 'คุณต้องการจะ ลบ ',
                  textStyle: MyConstant().h1Style(),
                ),
                subtitle: ShowTitle(
                  title: 'หอพักทั้งหมด ?',
                  textStyle: MyConstant().h3Style(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await SQLiteHelper().emptySQLite().then((value) {
                      Navigator.pop(context);
                      processReadSQLite();
                    });
                  },
                  child: Text('ลบ'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ยกเลิก'),
                ),
              ],
            ));
  }

  Row buttonController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ElevatedButton(
        //   onPressed: () {
        //     // print('ข้อมูล $sqliteModels คนจอง $userModel , ');
        //     Navigator.pushNamed(context, MyConstant.conFrimReseve);
        //   },
        //   child: Text('จอง'),
        // ),
        Container(
          margin: EdgeInsets.only(left: 4, right: 8),
          child: ElevatedButton(
            onPressed: () => confirmEmptyCart(),
            child: Text('ลบทั้งหมด'),
          ),
        ),
      ],
    );
  }

  Divider buildDivider() {
    return Divider(
      color: MyConstant.dark,
    );
  }

  ListView listHorpak() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShowTitle(
                title: sqliteModels[index].name,
                textStyle: MyConstant().h4Style(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].price,
              textStyle: MyConstant().h4Style(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowTitle(
              title: sqliteModels[index].phone,
              textStyle: MyConstant().h4Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ButtonStyle(),
              onPressed: () async {
                int idSQLite = sqliteModels[index].id!;
                // print(
                //     'ข้อมูล ${sqliteModels[index]} คนจอง ${userModel!.name} ไอดี${userModel!.id}, ');
                DateTime dateOrder = DateTime.now();

                DateFormat dateOrDer = DateFormat('dd/MM/yyyy HH:mm');

                dateTimeStr = dateOrDer.format(dateOrder);
                String idBuyer = userModel!.id;
                String nameBuyer = userModel!.name;
                String phoneBuyer = userModel!.phone;
                String name = sqliteModels[index].name;
                String idOwner = sqliteModels[index].idOwner;
                String nameOwner = sqliteModels[index].nameOwner;
                String phoneOwner = sqliteModels[index].phone;
                String idProduct = sqliteModels[index].idProduct;
                String nameProduct = sqliteModels[index].name;
                String priceProduct = sqliteModels[index].price;
                String lat = sqliteModels[index].lat;
                String lng = sqliteModels[index].lng;

                print(
                    'idBuyer $idBuyer ผู้จอง $nameBuyer, เบอร์คนจอง $phoneBuyer idOwner $idOwner ชื่อเจ้าของหอ $nameOwner เบอร์เจ้าของหอ $phoneOwner, ชื่อหอ $name idproduct $idProduct ราคา $priceProduct ');
                // print('เวลา = $dateTimeStr');
                String url =
                    '${MyConstant.domain}/bsruhorpak/insertReserve.php?isAdd=true&idBuyer=$idBuyer&nameBuyer=$nameBuyer&phoneBuyer=$phoneBuyer&dateOrder=$dateTimeStr&idOwner=$idOwner&nameOwner=$nameOwner&phoneOwner=$phoneOwner&idProduct=$idProduct&nameProduct=$nameProduct&priceProduct=$priceProduct&lat=$lat&lng=$lng&status=UserOrder';
                await Dio().get(url).then((value) {
                  if (value.toString() == 'true') {
                    SQLiteHelper().deleteSQLiteWhereId(idSQLite).then((value) {
                      print('ลบแล้ว');
                      String urlfindTokenOwner =
                          '${MyConstant.domain}/bsruhorpak/getUserWhereid.php?isAdd=true&id=$idOwner';
                      Dio().get(urlfindTokenOwner).then((value) async {
                        var resul = jsonDecode(value.data);
                        // print('value $resul');
                        for (var json in resul) {
                          // print(json);
                          UserModel model = UserModel.fromMap(json);
                          // print('model5555 $model');
                          String tokenOwner = model.token;
                          // print('TokenOwner $tokenOwner');
                          String title =
                              'มีคนจองหอของคุณเช็ดที่หน้าการจองหอพักด้วยครับ';
                          String body = 'เช็ดที่หน้าการจองหอพักด้วยครับ';
                          String urlSendToken =
                              '${MyConstant.domain}/bsruhorpak/apiNotification.php?isAdd=true&token=$tokenOwner&title=$title&body=$body';

                          print(
                              'tile $title body $body tokenOwner $tokenOwner');
                          await Dio().get(urlSendToken).then(
                            (value) {
                              Navigator.pushNamed(
                                  context, MyConstant.routBuyer);
                              MyDialog().normalDialog(
                                  context, 'จองหอพัก$nameProduct', 'สำเร็จ');
                              processReadSQLite();
                            },
                          );
                        }
                      });
                    });
                  } else {
                    MyDialog().normalDialog(
                        context, 'จองหอพัก$nameProduct', 'ไม่สำเร็จ');
                  }
                });

                // Navigator.pushNamed(context, MyConstant.conFrimReseve);
              },
              child: Text('จอง'),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                int idSQLite = sqliteModels[index].id!;
                print('### You delete==> $idSQLite');
                await SQLiteHelper()
                    .deleteSQLiteWhereId(idSQLite)
                    .then((value) => processReadSQLite());
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

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 111, 177, 232)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ShowTitle(
                  title: 'ชื่อหอพัก',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'ราคา',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'เบอร์',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Padding showHorpak() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ShowTitle(
            title: sqliteModels == null ? '' : 'BSRU HORPAK',
            textStyle: MyConstant().h1Style(),
          ),
        ],
      ),
    );
  }
}
