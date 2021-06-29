import 'package:flutter/cupertino.dart';
/* External dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local dependencies */
import '../../main_screen/components/main_screen_bloc.dart';
import '../../main_screen/components/main_screen_event.dart';
import '../../main_screen/components/main_screen_state.dart';
import '../../size_config.dart';

class LimitAndAlert extends StatefulWidget {
  LimitAndAlert({Key? key}) : super(key: key);

  @override
  _LimitAndAlertState createState() => _LimitAndAlertState();
}

class _LimitAndAlertState extends State<LimitAndAlert> {
  bool _alert = false;
  int selectedValue = 3;

  List<int> limits = [40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240];

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0xFF252525),
            height: MediaQuery.of(context).copyWith().size.height * 0.30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style:
                            TextStyle(color: Color(0xFFFF5C00), fontSize: 18),
                      ),
                    ),
                    Text(
                      'Speed Limit',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        int limit = limits.elementAt(selectedValue);
                        Navigator.pop(context);
                        context
                            .read<MainScreenBloc>()
                            .add(SetVelocityLimitEvent(velocityLimit: limit));
                      },
                      child: Text(
                        'OK',
                        style:
                            TextStyle(color: Color(0xFFFF5C00), fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.2,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme:
                          CupertinoTextThemeData(pickerTextStyle: TextStyle()),
                    ),
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: 3),
                      magnification: 1.5,
                      useMagnifier: true,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      itemExtent: 30.0,
                      children: limits.map((e) => Text(e.toString())).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(80),
        backgroundColor: Color(0xFF252525),
        title: Text(
          'SPEED LIMIT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'BarlowCondensed-Regular',
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: getProportionateScreenHeight(80),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
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
                    child: Row(
                      children: [
                        Text(
                          'ALERT SPEED LIMIT',
                          style: new TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        CupertinoSwitch(
                          value: _alert,
                          onChanged: (bool value) {
                            setState(() {
                              _alert = value;
                              if (_alert == true) {
                                context.read<MainScreenBloc>().add(
                                    SetAlertOverVelocityEvent(alert: true));
                              } else {
                                context.read<MainScreenBloc>().add(
                                    SetAlertOverVelocityEvent(alert: false));
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  height: getProportionateScreenHeight(80),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    child: InkWell(
                      onTap: showPicker,
                      child: ListTile(
                        leading: Image.asset('assets/icons/limit_icon.png'),
                        trailing: Icon(
                          CupertinoIcons.chevron_forward,
                          color: Color(0xFFA7A7A7),
                        ),
                        title: Row(
                          children: [
                            Text(
                              'SPEED LIMIT',
                              style: new TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Text(
                              state.velocityLimit.toString(),
                              style: new TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
