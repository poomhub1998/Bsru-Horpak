import 'dart:convert';

import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ShowOrderOwner extends StatefulWidget {
  const ShowOrderOwner({Key? key}) : super(key: key);

  @override
  State<ShowOrderOwner> createState() => _ShowOrderOwnerState();
}

class _ShowOrderOwnerState extends State<ShowOrderOwner> {
  bool load = true;

  @override
  void initState() {
    super.initState();
  }

  Future<Null> loadValueFromAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String id = preferences.getString('id')!;

    String apiGetProductWhereidOwner =
        '${MyConstant.domain}/bsruhorpak/getOwnerWhereidOwner.php?isAdd=true&idOwner=$id';
    await Dio().get(apiGetProductWhereidOwner).then(
      (value) {
        print('value $value');
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('dddd${model.name}');
          setState(() {
            load = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
