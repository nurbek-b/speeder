/* External dependencies */
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

/* Local dependencies */
import '../main_screen/components/main_screen_bloc.dart';
import 'audio_service.dart';

typedef TraceCallback(newLocation);

class GeoService {
  GeoService._privateConstructor() {
    _maxVelocityPerDay = Hive.box('statistics').get('maxVelocityPerDay') ?? 0.0;

    /// Speedometer functionality. Updates any time velocity chages.
    locator
        .getPositionStream(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        )
        .listen(
          (Position position) => _onAccelerate(position.speed),
        );

    _velocity = 0;
    _velocityLimit = MainScreenBloc().state.velocityLimit.toDouble();
    _maxVelocity = MainScreenBloc().state.maxVelocity.toDouble();
  }

  static final GeoService _instance = GeoService._privateConstructor();

  static GeoService get instance => _instance;

  late bool serviceEnabled;
  late LocationPermission permission;

  /// Current Velocity in m/s
  late double _velocity;

  /// Velocity limit.
  late double _velocityLimit;
  late double _maxVelocity;
  late double _maxVelocityPerDay;

  /// Geolocator is used to find velocity
  GeolocatorPlatform locator = GeolocatorPlatform.instance;

  /// Stream that emits values when velocity updates
  StreamController<double> velocityUpdatedStreamController =
      StreamController.broadcast();

  Future<Position> determinePosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('service enabled $serviceEnabled');
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print('permission is $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  /// Callback that runs when velocity updates, which in turn updates stream.
  void _onAccelerate(double speed) {
    _velocity = speed * 3.6;
    if (_velocity > _velocityLimit) Audio().playAudio();
    if (_velocity > _maxVelocityPerDay)
      Hive.box('statistics').put('maxVelocityPerDay', _velocity);
    if (_velocity < 0) _velocity = 0;
    if (_velocity >= _maxVelocity) _velocity = _maxVelocity;
    print("Velocity ${_velocity.runtimeType}");
    velocityUpdatedStreamController.sink.add(_velocity);
  }

  void dispose() {
    velocityUpdatedStreamController.close();
  }
}
