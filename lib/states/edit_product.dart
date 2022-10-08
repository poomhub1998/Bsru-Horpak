import 'dart:io';
import 'dart:math';
import 'package:bsru_horpak/utility/my_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bsru_horpak/models/product_model.dart';
import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_progress.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  const EditProduct({Key? key, required this.productModel}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detilController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  List<String> pathImages = [];
  final formkey = GlobalKey<FormState>();
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productModel = widget.productModel;
    // print('แก้ไข ${productModel!.images}');
    convertStringToArray();
    nameController.text = productModel!.name;
    priceController.text = productModel!.price;
    phoneController.text = productModel!.phone;
    addressController.text = productModel!.address;
    detilController.text = productModel!.detail;
  }

  void convertStringToArray() {
    String string = productModel!.images;
    print('string ก่อนตัด ==>> $string');
    string = string.substring(1, string.length - 1);
    print('string หลังตัด ==>> $string');
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      files.add(null);
    }
    print('### pathImages ==>> $pathImages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล'),
        actions: [
          IconButton(
            onPressed: () => processEdit(),
            icon: Icon(Icons.edit),
            tooltip: 'แก้ไขข้อมูล',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(
              FocusScopeNode(),
            ),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle('แก้ไขข้อมูลหอพัก'),
                  buildName(constraints),
                  buildPrice(constraints),
                  buildPhone(constraints),
                  buildAddress(constraints),
                  buildDetail(constraints),
                  buildTitle('แก้ไขรูปภาพ'),
                  buildImage(constraints, 0),
                  buildImage(constraints, 1),
                  buildImage(constraints, 2),
                  buildImage(constraints, 3),
                  buildEditProduct(constraints)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildEditProduct(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: constraints.maxWidth,
      child: ElevatedButton.icon(
        onPressed: () => processEdit(),
        icon: Icon(Icons.edit),
        label: Text('แก้ไขข้อมูล'),
      ),
    );
  }

  Future<Null> chooseImage(int index, ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        files[index] = File(result!.path);
        statusImage = true;
        // statusImage = true;
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Container buildImage(BoxConstraints constraints, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.camera),
            icon: Icon(Icons.add_a_photo),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: constraints.maxWidth * 0.5,
            height: constraints.maxWidth * 0.5,
            child: files[index] == null
                ? CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}/bsruhorpak/${pathImages[index]}',
                    placeholder: (context, url) => ShowProgress(),
                  )
                : Image.file(files[index]!),
          ),
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.gallery),
            icon: Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: constraints.maxWidth * 0.75,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรอกชื่อที่ต้องการเปลี่ยน';
                } else {
                  return null;
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อหอพัก',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: constraints.maxWidth * 0.75,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรอกราคาที่ต้องเปลี่ยน';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'ราคา',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: constraints.maxWidth * 0.75,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรอกเบอร์ที่ต้องการเปลี่ยน';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildDetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: constraints.maxWidth * 0.75,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรอกรายละเอียดที่ต้องกาารเปลี่ยน';
                } else {
                  return null;
                }
              },
              controller: detilController,
              decoration: InputDecoration(
                labelText: 'รายอะเอียดหอพัก',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: constraints.maxWidth * 0.75,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรอกที่อยู่ ที่ต้องการเปลี่ยน';
                } else {
                  return null;
                }
              },
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'ที่อยู่',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Future<Null> processEdit() async {
    if (formkey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);
      String name = nameController.text;
      String price = priceController.text;
      String phone = phoneController.text;
      String detail = detilController.text;
      String address = addressController.text;
      String id = productModel!.id;
      String images;

      if (statusImage) {
        // upload Image and Refresh array pathImages
        int index = 0;
        for (var item in files) {
          if (item != null) {
            int i = Random().nextInt(10000000);
            String nameImage = 'productEdit$i.jpg';
            String apiUploadImage =
                '${MyConstant.domain}/bsruhorpak/saveProduct.php';

            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            await Dio().post(apiUploadImage, data: formData).then((value) {
              pathImages[index] = '/product/$nameImage';
            });
          }
          index++;
        }

        images = pathImages.toString();
        Navigator.pop(context);
      } else {
        images = pathImages.toString();
        Navigator.pop(context);
      }

      print('status = $statusImage');
      print(
          'id = $id name $name price $price phone $phone address $address detail $detail');
      print('image $images');

      String apiEditProduct =
          '${MyConstant.domain}/bsruhorpak/editProductWhereId.php?isAdd=true&id=$id&name=$name&price=$price&phone=$phone&address=$address&detail=$detail&images=$images';
      await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    }
  }
}
