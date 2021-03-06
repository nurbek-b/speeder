/* External dependencies */
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local dependencies */
import '../main_screen/main_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../statistics_screen/statistics_screen.dart';
import '../subscription_screen/subscription_screen.dart';
import '../utils/SubscriptionContainer.dart';
import 'tabbar.dart';
import 'tab_bar_bloc.dart';
import 'tab_bar_event.dart';
import 'tab_bar_state.dart';


class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() {
    var _duration = new Duration(milliseconds: 500);
    return Timer(_duration, checkFirstSeen);
  }

  Future checkFirstSeen() async {
    bool _subscribed = await SubscriptionContainer.instance.isSubscribed().first;
    if (!_subscribed) {
      /// _seen is not true, so way to SubscriptionScreen
      Navigator.of(context).push(
          CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => SubscriptionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBarBloc, TabBarState>(
        builder: (BuildContext context, TabBarState state) {
          return Scaffold(
            body: _buildBody(state),
            bottomNavigationBar: Tabbar(),
          );
        });
  }

  Widget _buildBody(state) {
    if (state.currentPage == TabBarEventType.showSpeedometer) return MainScreen();
    if (state.currentPage == TabBarEventType.showStatistics) return StatisticsScreen();
    if (state.currentPage == TabBarEventType.showProfile) return ProfileScreen();
    return widget;
  }
}
