/* External dependencies */
import 'package:flutter/material.dart';

import '../../size_config.dart';

class FeaturesWidget extends StatelessWidget {
  final String leftIcon;
  final String rightIcon;
  final String title;

  const FeaturesWidget({
    Key? key,
    required this.leftIcon,
    required this.rightIcon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10),),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              leftIcon,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Image.asset(rightIcon),
          ],
        ),
      ),
    );
  }
}
