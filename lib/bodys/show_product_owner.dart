import 'dart:convert';

import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/states/aad_horpak.dart';
import 'package:bsru_horpak/states/edit_product.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_image.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowProductOwner extends StatefulWidget {
  const ShowProductOwner({Key? key}) : super(key: key);

  @override
  State<ShowProductOwner> createState() => _ShowProductOwnerState();
}

class _ShowProductOwnerState extends State<ShowProductOwner> {
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];

  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (productModels.length != 0) {
      productModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiGetProductWhereIdProduct =
        '${MyConstant.domain}/bsruhorpak/getProductWhereIdOwner.php?isAdd=true&idOwner=$id';
    await Dio().get(apiGetProductWhereIdProduct).then(
      (value) {
        // print('### หอทั้งหมด ==> $value');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: ' ยังไม่ได้เพิ่มข้อมูลหอพัก',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'โปรดเพิ่มข้อมูลหอพัก',
                          textStyle: MyConstant().h2Style()),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () => Navigator.pushNamed(context, MyConstant.routAddHorPak)
            .then((value) => loadValueFromAPI()),
        child: Text('เพิ่ม'),
      ),
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
        child: Card(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                width: constraints.maxWidth * 0.5 - 4,
                height: constraints.maxWidth * 0.5 - 4,
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
                margin: EdgeInsets.only(),
                width: constraints.maxWidth * 0.5 - 4,
                height: constraints.maxWidth * 0.5 - 4,
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
                        title: cutWrod(' ${productModels[index].detail}'),
                        textStyle: MyConstant().h3Style()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              print('## You Click Edit');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProduct(
                                      productModel: productModels[index],
                                    ),
                                  )).then((value) => loadValueFromAPI());
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: MyConstant.dark,
                            )),
                        IconButton(
                            onPressed: () {
                              print('## You Click Delete from index = $index');
                              confirmDialogDelete(productModels[index]);
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: MyConstant.dark,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: createUrl(productModel.images),
            placeholder: (context, url) => ShowProgress(),
          ),
          title: ShowTitle(
            title: 'Delete ${productModel.name} ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: productModel.detail,
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## Confirm Delete at id ==> ${productModel.id}');
              String apiDeleteProductWhereId =
                  '${MyConstant.domain}/bsruhorpak/deleteProductWhereId.php?isAdd=true&id=${productModel.id}';
              await Dio().get(apiDeleteProductWhereId).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String cutWrod(String string) {
    String result = string;
    if (result.length >= 100) {
      result = result.substring(0, 100);
      result = '$result....';
    }
    return result;
  }
}
