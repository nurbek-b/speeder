/* External dependencies */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* Local dependencies */
import '../../size_config.dart';

class ContinueButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onPressed;

  const ContinueButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  _ContinueButtonState createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(300),
      height: getProportionateScreenHeight(60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFD9F472), Color(0xFFE8391C)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: 8.0, top: 8.0, bottom: 8.0, right: 12.0),
                width: 100.0,
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                      fontSize: getProportionateScreenHeight(24),
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: getProportionateScreenWidth(20)),
                child: Image.asset(
                  'assets/icons/right_chevron_icon.png',
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
