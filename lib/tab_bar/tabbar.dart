/* External dependencies */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

/* Local dependencies */
import '../size_config.dart';
import 'tab_bar_bloc.dart';
import 'tab_bar_event.dart';

class Tabbar extends StatefulWidget {

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {

  List<Map<String, dynamic>> _getTabs() {
    final tabs = [
      {
        'event': ShowStatisticsPageEvent(),
        'child': BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/statistics_navbar_icon.svg'),
          activeIcon: SvgPicture.asset('assets/icons/statistics_navbar_icon.svg', color: Colors.white),
          label: 'Statistics',
        )
      },
      {
        'event': ShowSpeedometerPageEvent(),
        'child': BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/speedometer_navbar_icon.svg'),
          activeIcon: SvgPicture.asset('assets/icons/speedometer_navbar_icon.svg', color: Colors.white),
          label: 'Speedometer',
        )
      },
      {
        'event': ShowProfilePageEvent(),
        'child': BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/profile_navbar_icon.svg'),
          activeIcon: SvgPicture.asset('assets/icons/profile_navbar_icon.svg', color: Colors.white),
          label: 'Profile',
        )
      },
    ];
    return tabs;
  }
  int _selectedPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: getProportionateScreenHeight(120),
      child: BottomNavigationBar(
        backgroundColor: Color(0xFF252525),
        unselectedItemColor: Color(0xFFA7A7A7),
        selectedFontSize: 18.0,
        unselectedFontSize: 18.0,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
          final event = _getTabs()[index]['event'];
          context.read<TabBarBloc>().add(event);
        },
        items: this._getTabs().map<BottomNavigationBarItem>((tab) => tab['child']).toList(),
      ),
    );
  }
}
