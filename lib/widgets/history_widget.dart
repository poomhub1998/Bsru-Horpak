import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0,
        ),
        Container(
          child: Lottie.asset('assets/images/history.json'),
        ),
        // Text(
        //   'ยังไม่มีข้อมูล ...',
        //   style: TextStyle(
        //     fontSize: 16.0,
        //   ),
        // ),
      ],
    );
  }
}
