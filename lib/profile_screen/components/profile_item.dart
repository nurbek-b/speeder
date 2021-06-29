/* External dependencies */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* Local dependencies */
import '../../size_config.dart';

class ProfileItem extends StatelessWidget {
  final String icon;
  final String title;
  final String actual;
  final GestureTapCallback onPressed;

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.actual,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      height: getProportionateScreenHeight(80),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            SizedBox(width: getProportionateScreenWidth(10),),
            Image.asset(icon),
            SizedBox(width: getProportionateScreenWidth(10),),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'BarlowCondensed-Regular',
              ),
            ),
            Spacer(),
            Text(
              actual,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'BarlowCondensed-Regular',
              ),
            ),
            SizedBox(width: getProportionateScreenWidth(10),),
            Icon(
              CupertinoIcons.right_chevron,
              color: Colors.white,
            ),
            SizedBox(width: getProportionateScreenWidth(5),)
          ],
        ),
      ),
    );
  }
}
