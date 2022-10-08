import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('Settings'),
          actions: <Widget>[
            // IconButton(
            //     icon: Icon(Icons.exit_to_app),
            //     color: Colors.white,
            //     onPressed: () {
            //       // signOut(context);
            //     })
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset(
                  'assets/logo.png',
                  height: 120,
                )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.purple[100],
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Align(
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              // Image.asset(
                              //   '/',
                              //   width: 400,
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 250,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              // Image.asset(
                              //   'assets/.png',
                              //   width: 400,
                              // ),
                              SizedBox(
                                height: 250,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
