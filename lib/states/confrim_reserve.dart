import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConFrimReseve extends StatefulWidget {
  const ConFrimReseve({Key? key}) : super(key: key);

  @override
  State<ConFrimReseve> createState() => _ConFrimReseveState();
}

class _ConFrimReseveState extends State<ConFrimReseve> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบข้อมูล'),
      ),
    );
  }
}
