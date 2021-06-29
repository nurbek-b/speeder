/* External dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local dependencies */
import '../../main_screen/components/main_screen_bloc.dart';
import '../../main_screen/components/main_screen_event.dart';
import '../../size_config.dart';

class ScaleCheckBox extends StatefulWidget {
  ScaleCheckBox({Key? key}) : super(key: key);

  @override
  _ScaleCheckBoxState createState() => _ScaleCheckBoxState();
}

class _ScaleCheckBoxState extends State<ScaleCheckBox> {
  bool _isChecked60 = false;
  bool _isChecked120 = false;
  bool _isChecked240 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(80),
        backgroundColor: Color(0xFF252525),
        title: Text(
          'SCALE',
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
                    '0-60',
                    style: new TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  value: _isChecked60,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked60 = value!;
                      _isChecked120 = false;
                      _isChecked240 = false;
                    });
                    context.read<MainScreenBloc>().add(
                          ChangeScaleEvent(
                            maxVelocity: 60,
                            scale: '0-60',
                          ),
                        );
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
                    '0-120',
                    style: new TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  value: _isChecked120,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked120 = value!;
                      _isChecked60 = false;
                      _isChecked240 = false;
                    });
                    context.read<MainScreenBloc>().add(
                          ChangeScaleEvent(
                            maxVelocity: 120,
                            scale: '0-120',
                          ),
                        );
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
                    '0-240',
                    style: new TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  value: _isChecked240,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked240 = value!;
                      _isChecked60 = false;
                      _isChecked120 = false;
                    });
                    context.read<MainScreenBloc>().add(
                          ChangeScaleEvent(
                            maxVelocity: 240,
                            scale: '0-240',
                          ),
                        );
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
