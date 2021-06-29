/* External dependencies */
import 'package:cron/cron.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

/* Local dependencies */
import 'tab_bar/tab_bar_bloc.dart';
import 'main_screen/components/main_screen_bloc.dart';
import 'models/statistics_item_model.dart';
import 'subscription_screen/subscription_screen.dart';
import 'tab_bar/navigation_page.dart';
import 'utils/SubscriptionContainer.dart';

bool _subscribed = false;

void main() async {
  Hive.registerAdapter(StatisticItemAdapter());

  await SubscriptionContainer.instance.setupStorage();

  _subscribed = await SubscriptionContainer.instance.isSubscribed().first;

  await Hive.openBox('settings');

  await Hive.openBox('statistics');

  await Hive.openBox<StatisticItem>('statisticsItem');

  Hive.box('settings').put('onBoardingShown', true);

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  print(formattedDate);
  var distanceInit = Hive.box('statistics').get(formattedDate) ?? null;
  var maxSpeed = Hive.box('statistics').get('maxVelocityPerDay') ?? null;

  if (distanceInit == null) {
    print('adding data');
    Hive.box('statistics').put(formattedDate, 0.0.toString());
  } else if (maxSpeed == null) {
    Hive.box('statistics').put('maxVelocityPerDay', 0);
  }

  final cron = Cron();
  cron.schedule(Schedule.parse('59 23 * * *'), () async {
    DateTime now = DateTime.now();
    DateTime formattedDate = DateFormat('yyyy-MM-dd').format(now) as DateTime;
    double distance = Hive.box('statistics').get(formattedDate) as double;
    Hive.box<StatisticItem>('statisticsItem').add(
      StatisticItem(
        date: formattedDate,
        maxSpeed: 'min',
        distance: distance.toString(),
      ),
    );
  });
  cron.schedule(Schedule.parse('01 00 * * *'), () async {
    DateTime now = DateTime.now();
    DateTime formattedDate = DateFormat('yyyy-MM-dd').format(now) as DateTime;
    Hive.box('statistics').put('maxVelocityPerDay', 0);
    Hive.box('statistics').put(formattedDate, 0);
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() async {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TabBarBloc>(
            create: (BuildContext context) => TabBarBloc()),
        BlocProvider<MainScreenBloc>(
            create: (BuildContext context) => MainScreenBloc()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'BarlowCondensed-Regular'),
          title: 'Speedometer: Mile Tracker',
          home: _subscribed ? NavigationPage() : SubscriptionScreen()),
    );
  }
}
