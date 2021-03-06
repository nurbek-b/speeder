/* External dependencies */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/* Local dependencies */
import '../models/statistics_item_model.dart';
import '../utils/SubscriptionContainer.dart';
import '../subscription_screen/subscription_screen.dart';
import '../size_config.dart';
import 'components/item_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<bool>(
        initialData: true,
        stream: SubscriptionContainer.instance.isSubscribed(),
        builder: (context, isSubscribed) {
          print(isSubscribed.data);
          return isSubscribed.data!
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
                      valueListenable: Hive.box<StatisticItem>('statisticsItem')
                          .listenable(),
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
                              Hive.box<StatisticItem>('statisticsItem')
                                  .listenable(),
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
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => SubscriptionScreen()));
                      },
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black54,
                        child: Center(
                          child: Image.asset('assets/icons/lock_icon.png'),
                        ),
                      ),
                    ),
                  ],
                );
        });
  }
}
