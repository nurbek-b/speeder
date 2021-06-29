
enum TabBarEventType {
  showSpeedometer,
  showStatistics,
  showProfile,
}

abstract class TabBarEvent {
  final TabBarEventType type;
  TabBarEvent({ required this.type});
}

class ShowSpeedometerPageEvent extends TabBarEvent {
  ShowSpeedometerPageEvent() : super(type: TabBarEventType.showSpeedometer);
}

class ShowStatisticsPageEvent extends TabBarEvent {
  ShowStatisticsPageEvent() : super(type: TabBarEventType.showStatistics);
}

class ShowProfilePageEvent extends TabBarEvent {
  ShowProfilePageEvent() : super(type: TabBarEventType.showProfile);
}

