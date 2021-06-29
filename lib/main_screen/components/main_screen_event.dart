enum MainScreenEventType {
  showMap,
  showSpeedometer,
  showHud,
  getInitialCoordinates,
  changeVelocityUnit,
  changeScale,
  setLimit,
  setAlert,
}

abstract class MainScreenEvent {
  final MainScreenEventType type;

  MainScreenEvent({required this.type});
}

class MainScreenShowMapEvent extends MainScreenEvent {
  MainScreenShowMapEvent() : super(type: MainScreenEventType.showMap);
}

class MainScreenShowSpeedometerEvent extends MainScreenEvent {
  MainScreenShowSpeedometerEvent()
      : super(type: MainScreenEventType.showSpeedometer);
}

class MainScreenShowHudEvent extends MainScreenEvent {
  MainScreenShowHudEvent() : super(type: MainScreenEventType.showHud);
}

class GetInitialCoordinatesEvent extends MainScreenEvent {
  final double latitude;
  final double longitude;

  GetInitialCoordinatesEvent({
    required this.longitude,
    required this.latitude,
  }) : super(type: MainScreenEventType.getInitialCoordinates);
}

class ChangeVelocityUnitEvent extends MainScreenEvent {
  final String velocityUnit;

  ChangeVelocityUnitEvent({
    required this.velocityUnit,
  }) : super(type: MainScreenEventType.changeVelocityUnit);
}

class ChangeScaleEvent extends MainScreenEvent {
  final int maxVelocity;
  final String scale;

  ChangeScaleEvent({required this.maxVelocity, required this.scale})
      : super(type: MainScreenEventType.changeScale);
}

class SetVelocityLimitEvent extends MainScreenEvent {
  final int velocityLimit;

  SetVelocityLimitEvent({
    required this.velocityLimit,
  }) : super(type: MainScreenEventType.setLimit);
}

class SetAlertOverVelocityEvent extends MainScreenEvent {
  final bool alert;

  SetAlertOverVelocityEvent({
    required this.alert,
  }) : super(type: MainScreenEventType.setAlert);
}
