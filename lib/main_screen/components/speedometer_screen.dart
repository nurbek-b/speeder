/* External dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/geo_service.dart';
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
  late double latitude, longitude;

  /// Current Velocity in m/s
  late double _velocity;

  /// Velocity limit.
  late double _maxVelocity;

  /// Hive box
  late var statisticsBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _velocity = context.read<MainScreenBloc>().state.velocity.toDouble();
    _maxVelocity = context.read<MainScreenBloc>().state.maxVelocity.toDouble();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return StreamBuilder<Object>(
            stream: GeoService().velocityUpdatedStreamController.stream,
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

  /// Velocity in m/s to miles per hour converter
  double kphtomilesph(double kph) => kph * 1.609;

  /// Relevant velocity in chosen unit
  String convertedVelocity(String unit, double velocity) {
    if (unit == 'KMH')
      return velocity.toInt().toString();
    else if (unit == 'MPH') return kphtomilesph(velocity).toInt().toString();
    return velocity.toInt().toString();
  }

  void _getUserLocation() async {
    Position position = await GeoService().determinePosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      context.read<MainScreenBloc>().add(GetInitialCoordinatesEvent(
            latitude: latitude,
            longitude: longitude,
          ));
      Hive.box('statistics').put('startLatitude', latitude);
      Hive.box('statistics').put('startLongitude', longitude);
    });
  }
}
