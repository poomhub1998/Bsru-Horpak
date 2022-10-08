import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/models/user_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMangeOwner extends StatefulWidget {
  final UserModel userModel;

  const ShowMangeOwner({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowMangeOwner> createState() => _ShowMangeOwnerState();
}

class _ShowMangeOwnerState extends State<ShowMangeOwner> {
  UserModel? userModel;
  List<ProductModel> productModels = [];

  @override
  void initState() {
    // TODO: implement initState

    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('## refreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bsruhorpak/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in jsonDecode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyConstant.primary,
          child: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(context, MyConstant.routOwner)
              .then((value) => refreshUserModel()),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowTitle(
                        title: 'ชื่อ  : ${userModel!.name}',
                        textStyle: MyConstant().h1Style()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowTitle(
                        title: 'ที่อยู่ : ${userModel!.address}',
                        textStyle: MyConstant().h2Style()),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       width: constraints.maxWidth * 0.6,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ShowTitle(
                  //           title: userModel!.address,
                  //           textStyle: MyConstant().h2Style(),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShowTitle(
                      title: 'เบอร์โทรศัพท์ : ${userModel!.phone}',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ShowTitle(
                        title: 'รูปโปรไฟล์ :',
                        textStyle: MyConstant().h2Style()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        width: constraints.maxWidth * 0.6,
                        child: CachedNetworkImage(
                          imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                          placeholder: (context, url) => ShowProgress(),
                        ),
                      ),
                    ],
                  ),
                  ShowTitle(
                      title: 'Location :', textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        width: constraints.maxWidth * 0.6,
                        height: constraints.maxWidth * 0.6,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            zoom: 16,
                          ),
                          markers: <Marker>[
                            Marker(
                                markerId: MarkerId('id'),
                                position: LatLng(
                                  double.parse(userModel!.lat),
                                  double.parse(userModel!.lng),
                                ),
                                infoWindow: InfoWindow(
                                    title: 'You Here ',
                                    snippet:
                                        'lat = ${userModel!.lat}, lng = ${userModel!.lng}')),
                          ].toSet(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
