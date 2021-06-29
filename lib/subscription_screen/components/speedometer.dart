/* External dependencies */
import 'package:flutter/material.dart';

import '../../size_config.dart';

class LogoAndText extends StatelessWidget {
  LogoAndText({Key? key}) : super(key: key);

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xFFD9F472), Color(0xFFE8391C)],
  ).createShader(Rect.fromLTWH(100.0, 0.0, 200.0, 0.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(20),),
            child: Image.asset(
              'assets/icons/speedometer_icon.png',
              height: getProportionateScreenHeight(180),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
            child: Text(
              'Speedometer \nmaster'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(32),
                fontWeight: FontWeight.w700,
                foreground: Paint()..shader = linearGradient,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
