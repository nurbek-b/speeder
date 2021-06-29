/* External dependencies */
import 'package:hive/hive.dart';

/* Local dependencies */
part 'statistics_item_model.g.dart';

@HiveType(typeId: 0)
class StatisticItem {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String distance;
  @HiveField(2)
  String maxSpeed;

  StatisticItem({
    required this.date,
    required this.distance,
    required this.maxSpeed,
  });
}
