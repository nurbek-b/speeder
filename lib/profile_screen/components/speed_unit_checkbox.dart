/* External dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local dependencies */
import '../../main_screen/components/main_screen_bloc.dart';
import '../../main_screen/components/main_screen_event.dart';
import '../../size_config.dart';

class SpeedUnitCheckBox extends StatefulWidget {
  SpeedUnitCheckBox({Key? key}) : super(key: key);

  @override
  _SpeedUnitCheckBoxState createState() => _SpeedUnitCheckBoxState();
}

class _SpeedUnitCheckBoxState extends State<SpeedUnitCheckBox> {
  bool _isCheckedMPH = false;
  bool _isCheckedKPH = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(80),
        backgroundColor: Color(0xFF252525),
        title: Text(
          'SPEED UNITS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'BarlowCondensed-Regular',
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              height: getProportionateScreenHeight(80),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF252525),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Color(0xFFA7A7A7),
                  fontFamily: 'BarlowCondensed-Regular',
                ),
                child: CheckboxListTile(
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  title: Text(
                    'KMH',
                    style: new TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  value: _isCheckedKPH,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckedKPH = value!;
                      _isCheckedMPH = false;
                    });
                    context
                        .read<MainScreenBloc>()
                        .add(ChangeVelocityUnitEvent(velocityUnit: 'KMH'));
                  },
                ),
              ),
            ),
            SizedBox(height: 2),
            Container(
              height: getProportionateScreenHeight(80),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF252525),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Theme(
                data: ThemeData(
                    unselectedWidgetColor: Color(0xFFA7A7A7),
                    fontFamily: 'BarlowCondensed-Regular'),
                child: CheckboxListTile(
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  title: Text(
                    'MPH',
                    style: new TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  value: _isCheckedMPH,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckedMPH = value!;
                      _isCheckedKPH = false;
                    });
                    context
                        .read<MainScreenBloc>()
                        .add(ChangeVelocityUnitEvent(velocityUnit: 'MPH'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
