/* External dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

/* Local dependencies */
import '../size_config.dart';
import 'components/geo_location_map.dart';
import 'components/hud_screen.dart';
import 'components/main_screen_bloc.dart';
import 'components/main_screen_state.dart';
import 'components/main_screen_event.dart';
import 'components/speedometer_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF252525),
        toolbarHeight: getProportionateScreenHeight(120),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleSwitch(
              minHeight: getProportionateScreenHeight(70),
              minWidth: getProportionateScreenWidth(120),
              cornerRadius: 10.0,
              activeBgColor: [Color(0xFF3A3A3A)],
              inactiveBgColor: Colors.black,
              inactiveFgColor: Colors.white,
              initialLabelIndex: 0,
              totalSwitches: 2,
              labels: ['SPEEDOMETER', 'HUD'],
              radiusStyle: true,
              fontSize: getProportionateScreenHeight(22),
              onToggle: (index) {
                if (index == 0) {
                  context
                      .read<MainScreenBloc>()
                      .add(MainScreenShowSpeedometerEvent());
                } else {
                  context.read<MainScreenBloc>().add(MainScreenShowHudEvent());
                }
              },
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<MainScreenBloc>(context),
                        child: LiveGeoMap(),
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/icons/map_icon.png',
                  height: getProportionateScreenWidth(40),
                ))
          ],
        ),
      ),
      body: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (BuildContext context, MainScreenState state) {
          MainScreenEventType currentMode = state.currentMode;
          if (currentMode == MainScreenEventType.showSpeedometer) {
            return LiveSpeedometerScreen();
          } else if (currentMode == MainScreenEventType.showHud) {
            return LiveHudScreen();
          } else {
            return Container(
              child: Center(child: Text('Unknown error!')),
            );
          }
        },
      ),
    );
  }
}
