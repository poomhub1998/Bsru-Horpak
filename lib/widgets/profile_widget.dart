import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfildView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0,
        ),
        Container(
          child: Lottie.asset(
            'assets/images/profile.json',
            width: 300,
            height: 300,
          ),
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
