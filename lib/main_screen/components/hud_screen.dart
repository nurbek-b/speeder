/* External dependencies */
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

/* Local dependencies */
import '../../size_config.dart';
import 'main_screen_bloc.dart';
import 'main_screen_state.dart';

class LiveHudScreen extends StatefulWidget {
  const LiveHudScreen({Key? key}) : super(key: key);

  @override
  _LiveHudScreenState createState() => _LiveHudScreenState();
}

class _LiveHudScreenState extends State<LiveHudScreen> {
  /// Geolocator is used to find velocity
  GeolocatorPlatform locator = GeolocatorPlatform.instance;

  /// Stream that emits values when velocity updates
  StreamController<double> _velocityUpdatedStreamController =
      StreamController<double>();

  /// Current Velocity in m/s
  late double _velocity;

  /// Velocity limit.
  late double _velocityLimit;
  late int _maxVelocityPerDay;

  /// Velocity in m/s to km/hr converter
  double mpstokmph(double mps) => mps * 18 / 5;

  /// Velocity in m/s to miles per hour converter
  double mpstomilesph(double mps) => mps * 85 / 38;

  /// Relevant velocity in chosen unit
  String convertedVelocity(String unit, double velocity) {
    velocity = velocity;

    if (unit == 'KMH')
      return mpstokmph(velocity).toInt().toString();
    else if (unit == 'MPH') return mpstomilesph(velocity).toInt().toString();
    return velocity.toInt().toString();
  }

  final AudioCache _audioCache = AudioCache(
    prefix: 'assets/audio/',
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  Future<void> _playAudio() {
    return _audioCache.play('overspeed_notification.mp3');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// Getting initial coordinates and saving to Hive
    _maxVelocityPerDay = Hive.box('statistics').get('maxVelocityPerDay').toInt();

    /// Speedometer functionality. Updates any time velocity chages.
    locator
        .getPositionStream(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        )
        .listen(
          (Position position) => _onAccelerate(position.speed),
        );

    _velocity = 0;
    _velocityLimit =
        context.read<MainScreenBloc>().state.velocityLimit.toDouble();
  }

  /// Callback that runs when velocity updates, which in turn updates stream.
  void _onAccelerate(double speed) {
    locator.getCurrentPosition().then(
      (Position updatedPosition) {
        _velocity = (speed + updatedPosition.speed) / 2;
        if (_velocity > _velocityLimit) _playAudio();
        if (_velocity > _maxVelocityPerDay)
          Hive.box('statistics').put('maxVelocityPerDay', _velocity);
        if (_velocity < 0) _velocity = 0;
        _velocityUpdatedStreamController.add(_velocity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return StreamBuilder<Object>(
            stream: _velocityUpdatedStreamController.stream,
            builder: (context, snapshot) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                        text: convertedVelocity(
                            state.velocityUnit.toUpperCase(), _velocity),
                        style: TextStyle(
                            fontSize: 200,
                            fontFamily: 'BarlowCondensed-Regular',
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: state.velocityUnit.toUpperCase(),
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'BarlowCondensed-Regular',
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ]),
                  ),
                ),
              );
            });
      },
    );
  }
}
