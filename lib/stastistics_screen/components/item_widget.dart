/* External dependencies */
import 'package:flutter/material.dart';

/* Local dependencies */
import '../../size_config.dart';

class StatisticsItem extends StatelessWidget {
  final String date;
  final String distance;
  final String maxVelocity;

  const StatisticsItem({
    Key? key,
    required this.date,
    required this.distance,
    required this.maxVelocity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: getProportionateScreenHeight(120),
        decoration: BoxDecoration(
            color: Color(0xFF252525),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(30)),
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(
                color: Color(0xFF3A3A3A),
                height: getProportionateScreenHeight(0.1)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(1),
                    horizontal: getProportionateScreenWidth(30),
                  ),
                  child: RichText(
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'DISTANCE\n',
                        ),
                        TextSpan(
                          text: "$distance Meters",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'BarlowCondensed-Regular'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(1),
                    horizontal: getProportionateScreenWidth(30),
                  ),
                  child: RichText(
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'MAX SPEED\n',
                        ),
                        TextSpan(
                          text: '$maxVelocity km/h',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'BarlowCondensed-Regular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
