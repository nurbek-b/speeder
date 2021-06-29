/* External dependencies */
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/* Local dependencies */
import '../../size_config.dart';
import 'main_screen_bloc.dart';
import 'main_screen_state.dart';
import 'main_screen_event.dart';

class LiveSpeedometerScreen extends StatefulWidget {
  const LiveSpeedometerScreen({Key? key}) : super(key: key);

  @override
  _LiveSpeedometerScreenState createState() => _LiveSpeedometerScreenState();
}

class _LiveSpeedometerScreenState extends State<LiveSpeedometerScreen> {
  /// Geolocator is used to find velocity
  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  late double latitude, longitude;

  /// Stream that emits values when velocity updates
  StreamController<double> _velocityUpdatedStreamController =
      StreamController<double>();

  /// Current Velocity in m/s
  late double _velocity;

  /// Velocity limit.
  late double _velocityLimit;
  late double _maxVelocity;
  late int _maxVelocityPerDay;

  /// Hive box
  late var statisticsBox;

  /// Velocity in m/s to miles per hour converter
  double kphtomilesph(double kps) => kps * 1.609;

  /// Relevant velocity in chosen unit
  String convertedVelocity(String unit, double velocity) {
    if (unit == 'KMH')
      return velocity.toInt().toString();
    else if (unit == 'MPH') return kphtomilesph(velocity).toInt().toString();
    return velocity.toInt().toString();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      context.read<MainScreenBloc>().add(GetInitialCoordinatesEvent(
            latitude: latitude,
            longitude: longitude,
          ));
      Hive.box('statistics').put('startLatitude', latitude.toString());
      Hive.box('statistics').put('startLongitude', longitude.toString());
    });
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
    _getUserLocation();

    _maxVelocityPerDay =
        Hive.box('statistics').get('maxVelocityPerDay') ?? 0;

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
    _maxVelocity = context.read<MainScreenBloc>().state.maxVelocity.toDouble();
  }

  /// Callback that runs when velocity updates, which in turn updates stream.
  void _onAccelerate(double speed) {
    locator.getCurrentPosition().then(
      (Position updatedPosition) {
        _velocity = updatedPosition.speed * 3.6;
        if (_velocity > _velocityLimit) _playAudio();
        if (_velocity > _maxVelocityPerDay)
          Hive.box('statistics').put('maxVelocityPerDay', _velocity);
        if (_velocity < 0) _velocity = 0;
        if (_velocity >= _maxVelocity) _velocity = _maxVelocity;
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
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                    radiusFactor: getProportionateScreenWidth(0.7),
                    minimum: 0,
                    maximum: double.tryParse(
                      convertedVelocity(
                          state.velocityUnit.toUpperCase(), _maxVelocity),
                    )!,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: state.minVelocity.toDouble(),
                          endValue: _maxVelocity.toDouble(),
                          gradient: const SweepGradient(colors: <Color>[
                            Color(0xFFD9F472),
                            Color(0xFFE8391C)
                          ], stops: <double>[
                            0.35,
                            0.65
                          ]),
                          startWidth: getProportionateScreenHeight(35),
                          endWidth: getProportionateScreenHeight(35)),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        value: double.tryParse(
                          convertedVelocity(
                              state.velocityUnit.toUpperCase(), _velocity),
                        )!,
                        needleColor: Colors.white,
                        needleLength: getProportionateScreenHeight(2),
                        knobStyle: KnobStyle(
                            knobRadius: getProportionateScreenHeight(0.2),
                            color: Colors.white),
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                            child: RichText(
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: convertedVelocity(
                                      state.velocityUnit.toUpperCase(),
                                      _velocity),
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                                TextSpan(
                                  text: '\n${state.velocityUnit.toUpperCase()}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ]),
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.8),
                    ],
                  ),
                ]),
              );
            });
      },
    );
  }
}
