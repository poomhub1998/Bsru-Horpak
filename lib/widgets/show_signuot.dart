import 'package:bsru_horpak/utility/my_constant.dart';
import 'package:bsru_horpak/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear().then(
                    (value) => Navigator.pushNamedAndRemoveUntil(
                        context, MyConstant.routAuthen, (route) => false),
                  );
            },
            tileColor: Colors.red[700],
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: ShowTitle(
              title: 'ออกจากระบบ',
              textStyle: MyConstant().h2WhiteStyle(),
            )),
      ],
    );
  }
}
