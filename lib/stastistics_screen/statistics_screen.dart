/* External dependencies */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/* Local dependencies */
import '../models/statistics_item_model.dart';
import '../utils/SubscriptionContainer.dart';
import '../size_config.dart';
import 'components/item_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _subscribed = false;

  @override
  void initState() {
    SubscriptionContainer.instance.isSubscribed().first.then((value) {
      setState(() {
        _subscribed = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _subscribed
        ? Scaffold(
            appBar: AppBar(
              toolbarHeight: getProportionateScreenHeight(110),
              backgroundColor: Color(0xFF252525),
              title: Text(
                'STATISTICS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'BarlowCondensed-Regular',
                ),
              ),
            ),
            body: Container(
              color: Colors.black,
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<StatisticItem>('statisticsItem').listenable(),
                builder: (context, Box<StatisticItem> box, _) {
                  if (box.values.isEmpty)
                    return Center(
                      child: Text(
                        "Statistics list is empty",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  return ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      StatisticItem res = box.getAt(index)!;
                      return StatisticsItem(
                        date: res.date.toString(),
                        distance: res.distance,
                        maxVelocity: res.maxSpeed,
                      );
                    },
                  );
                },
              ),
            ),
          )
        : Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  toolbarHeight: getProportionateScreenHeight(110),
                  backgroundColor: Color(0xFF252525),
                  title: Text(
                    'STATISTICS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'BarlowCondensed-Regular',
                    ),
                  ),
                ),
                body: Container(
                  color: Colors.black,
                  child: ValueListenableBuilder(
                    valueListenable:
                        Hive.box<StatisticItem>('statisticsItem').listenable(),
                    builder: (context, Box<StatisticItem> box, _) {
                      if (box.values.isEmpty)
                        return Center(
                          child: Text(
                            "Statistics list is empty",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      return ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          StatisticItem res = box.getAt(index)!;
                          return StatisticsItem(
                            date: res.date.toString(),
                            distance: res.distance,
                            maxVelocity: res.maxSpeed,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black54,
                child: Center(
                  child: Image.asset('assets/icons/lock_icon.png'),
                ),
              ),
              Align(
                alignment: Alignment(0.95, -0.85),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.clear,
                    size: 30,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    print('Cross on lock pressed!');
                  },
                ),
              ),
            ],
          );
  }
}
