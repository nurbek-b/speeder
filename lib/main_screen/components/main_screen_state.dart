/* Local dependencies */
import 'main_screen_event.dart';

class MainScreenState {
  /* Speeds */
  int velocity;
  int minVelocity;
  int maxVelocity;
  int velocityLimit;
  bool overVelocityAlert;
  String velocityUnit;
  String scale;

  /* Geo */
  double latitude, longitude;
  double startLatitude, startLongitude;

  /* Mode of page */
  MainScreenEventType currentMode;

  MainScreenState({
    /* Speeds */
    this.velocity = 0,
    this.minVelocity = 0,
    this.maxVelocity = 120,
    this.velocityLimit = 120,
    this.overVelocityAlert = false,
    this.velocityUnit = 'KMH',
    this.scale = '0-60',

    /* Geo */
    this.latitude = 0,
    this.longitude = 0,
    this.startLatitude = 0,
    this.startLongitude = 0,

    /* Mode of page */
    this.currentMode = MainScreenEventType.showSpeedometer,
  });

  MainScreenState cloneWith({
    /* Speeds */
    int velocity = 0,
    int minVelocity = 0,
    int maxVelocity = 120,
    int velocityLimit = 120,
    bool overVelocityAlert = false,
    String velocityUnit = 'KMH',
    String scale = '0-120',

    /* Geo */
    double? latitude,
    double? longitude,
    double? startLatitude,
    double? startLongitude,

    /* Mode of page */
    MainScreenEventType? currentMode,
  }) {
    return MainScreenState(
      /* Speeds */
      velocity: velocity,
      minVelocity: minVelocity,
      maxVelocity: maxVelocity,
      velocityLimit: velocityLimit,
      overVelocityAlert: overVelocityAlert,
      velocityUnit: velocityUnit,
      scale: scale,

      /* Geo */
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,

      /* Mode of page */
      currentMode: currentMode ?? this.currentMode,
    );
  }
}
