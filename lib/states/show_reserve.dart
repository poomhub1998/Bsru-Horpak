import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class ShowReserve extends StatefulWidget {
  const ShowReserve({Key? key}) : super(key: key);

  @override
  State<ShowReserve> createState() => _ShowReserveState();
}

class _ShowReserveState extends State<ShowReserve> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  ProductModel? productModel;
  int? total;
  String? idBuyer;
  String? dateTimeStr;
  String? showDate;
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
    Intl.defaultLocale = 'th';
    initializeDateFormatting();
    // Intl.defaultLocale = 'th';
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
    var now = DateTime.now();
    var toShow = now.yearInBuddhistCalendar;

    // var formatter = DateFormat('dd/MM/yyyy HH:mm');
    var formatter = DateFormat('dd/MMMM/yyyy HH:mm');
    // var formatter = DateFormat('dd/MM/yyyy HH:mm');

    var showDate = formatter.formatInBuddhistCalendarThai(now);

    // print(showDate);

    setState(() {
      dateTimeStr = formatter.formatInBuddhistCalendarThai(now);
      showDate;
      // print('sssss $showDate');
    });
    // print('???????????? = $dateTimeStr');
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
  //   print('???????????? $dateTimeStr');
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
    final start = dateRange.start;
    final end = dateRange.end;

    return Scaffold(
      appBar: AppBar(
        title: Text('?????????????????????????????????????????????'),
      ),
      body: load
          ? ShowProgress()
          : sqliteModels.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingView(),
                    ShowTitle(
                      title: '?????????????????????????????????????????????????????????',
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
              //           title: '?????????????????????????????????????????????????????????',
              //           textStyle: MyConstant().h1Style(),
              //         ),
              //       ),
              //     ],
              //   )
              : buildContent(),
    );
  }

  Column buildContent() {
    final start = dateRange.start;
    final end = dateRange.end;
    final differenc = dateRange.duration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showHorpak(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShowTitle(
                title: '?????????????????? :',
                textStyle: MyConstant().h3Style(),
              ),
            ),
            ShowTitle(
              title: dateTimeStr == null ? '' : dateTimeStr!,
              textStyle: MyConstant().h3Style(),
            ),
          ],
        ),
        buildHead(),
        listHorpak(),

        // Text('???????????????  ${differenc.inDays} ?????????'),
        buildDivider(),
        buttonController(),
        Row(
          children: [
            Expanded(
              child: SizedBox(),
            ),
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
                  title: '???????????????????????????????????? ?????? ',
                  textStyle: MyConstant().h1Style(),
                ),
                subtitle: ShowTitle(
                  title: '???????????????????????????????????? ?',
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
                  child: Text('??????'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('??????????????????'),
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
        //     // print('?????????????????? $sqliteModels ??????????????? $userModel , ');
        //     Navigator.pushNamed(context, MyConstant.conFrimReseve);
        //   },
        //   child: Text('?????????'),
        // ),
        Container(
          margin: EdgeInsets.only(left: 4, right: 8),
          child: ElevatedButton(
            onPressed: () => confirmEmptyCart(),
            child: Text('???????????????????????????'),
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
    final start = dateRange.start;
    final end = dateRange.end;
    final differenc = dateRange.duration;
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
                title: ' ${sqliteModels[index].name}',
                textStyle: MyConstant().h3BlackStyle(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].price,
              textStyle: MyConstant().h3BlackStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: pickDateRang,
              child: Text('??????????????? ${differenc.inDays} ?????????'),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ButtonStyle(),
              onPressed: () async {
                int idSQLite = sqliteModels[index].id!;
                // print(
                //     '?????????????????? ${sqliteModels[index]} ??????????????? ${userModel!.name} ????????????${userModel!.id}, ');
                var now = DateTime.now();
                var toShow = now.yearInBuddhistCalendar;
                var formatter = DateFormat('dd/MMMM/yyy HH:mm');
                // var formatter = DateFormat.yMMMMEEEEdHH:mm();
                var showDate = formatter.formatInBuddhistCalendarThai(now);

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
                print(showDate);

                print(
                    'idBuyer $idBuyer ?????????????????? $nameBuyer, ?????????????????????????????? $phoneBuyer idOwner $idOwner ??????????????????????????????????????? $nameOwner ?????????????????????????????????????????? $phoneOwner, ?????????????????? $name idproduct $idProduct ???????????? $priceProduct ddd $showDate ');
                // print('???????????? = $dateTimeStr');
                String url =
                    '${MyConstant.domain}/bsruhorpak/insertReserve.php?isAdd=true&idBuyer=$idBuyer&nameBuyer=$nameBuyer&phoneBuyer=$phoneBuyer&dateOrder=$showDate&idOwner=$idOwner&nameOwner=$nameOwner&phoneOwner=$phoneOwner&idProduct=$idProduct&nameProduct=$nameProduct&priceProduct=$priceProduct&lat=$lat&lng=$lng&status=UserOrder';
                await Dio().get(url).then((value) {
                  if (value.toString() == 'true') {
                    SQLiteHelper().deleteSQLiteWhereId(idSQLite).then((value) {
                      print('??????????????????');
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
                              '???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????';
                          String body = '??????????????????????????????????????????????????????????????????????????????????????????';
                          String urlSendToken =
                              '${MyConstant.domain}/bsruhorpak/apiNotification.php?isAdd=true&token=$tokenOwner&title=$title&body=$body';

                          print(
                              'tile $title body $body tokenOwner $tokenOwner');
                          await Dio().get(urlSendToken).then(
                            (value) {
                              Navigator.pushNamed(
                                  context, MyConstant.routBuyer);
                              MyDialog().normalDialog(
                                  context, '????????????????????????$nameProduct', '??????????????????');
                              processReadSQLite();
                            },
                          );
                        }
                      });
                    });
                  } else {
                    MyDialog().normalDialog(
                        context, '????????????????????????$nameProduct', '???????????????????????????');
                  }
                });

                // Navigator.pushNamed(context, MyConstant.conFrimReseve);
              },
              child: Text('?????????'),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: pickDateRang,
          //         child: Text('${start.day}/${start.month}/${start.year}'),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 12,
          //     ),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: pickDateRang,
          //         child: Text('${end.day}/${end.month}/${end.year}'),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.purple),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ShowTitle(
                  title: '???????????????????????????',
                  textStyle: MyConstant().h2WhiteStyle(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: '????????????',
                textStyle: MyConstant().h2WhiteStyle(),
              ),
            ),
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: '??????????????????????????????????????????',
                textStyle: MyConstant().h2WhiteStyle(),
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

  Future pickDateRang() async {
    var now = DateTime.now();
    var toShow = now.yearInBuddhistCalendar;

    // var formatter = DateFormat('dd/MM/yyyy HH:mm');
    var formatter = DateFormat('dd/MMMM/yyyy HH:mm');
    // var formatter = DateFormat('dd/MM/yyyy HH:mm');

    var showDate = formatter.formatInBuddhistCalendarThai(now);
    DateTimeRange? newDateRang = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDateRang == null) return;
    setState(() {
      dateRange = newDateRang;
      print(newDateRang);
    });
  }
}
