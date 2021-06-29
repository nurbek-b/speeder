/* External dependencies */
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

/* Local dependencies */
import '../../size_config.dart';
import '../../utils/SubscriptionContainer.dart';
import 'main_screen_bloc.dart';
import 'main_screen_state.dart';

class LiveGeoMap extends StatefulWidget {
  const LiveGeoMap({Key? key}) : super(key: key);

  @override
  _LiveGeoMapState createState() => _LiveGeoMapState();
}

class _LiveGeoMapState extends State<LiveGeoMap> {
  bool _subscribed = false;

  late BitmapDescriptor myIcon;

  late var latitude, longitude;

  /// GeoLocator is used to find velocity
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
    SubscriptionContainer.instance.isSubscribed().first.then((value) {
      setState(() {
        _subscribed = value;
      });
    });
    super.initState();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(10, 10)),
      'assets/icons/map_marker_icon.png',
    ).then((onValue) {
      myIcon = onValue;
      // _getCurrentLocation();
    }).whenComplete(() {
      setState(() {});
    });

    /// Getting initial coordinates and saving to Hive
    _maxVelocityPerDay =
        Hive.box('statistics').get('maxVelocityPerDay').toInt();

    /// Speedometer functionality. Updates any time velocity chages.
    locator
        .getPositionStream(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        )
        .listen(
          (Position position) => _onAccelerate(position.speed),
        );

    /// Set velocities to zero when app opens
    _velocity = context.read<MainScreenBloc>().state.velocity.toDouble();
    _velocityLimit =
        context.read<MainScreenBloc>().state.maxVelocity.toDouble();
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
        return _subscribed
            ? Scaffold(
                bottomNavigationBar: StreamBuilder<Object>(
                    stream: _velocityUpdatedStreamController.stream,
                    builder: (context, snapshot) {
                      return Container(
                        height: getProportionateScreenHeight(200),
                        color: Color(0xFF252525),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(40),
                              ),
                              Text(
                                '${convertedVelocity(state.velocityUnit.toUpperCase(), _velocity)} ${state.velocityUnit}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Current speed'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                body: Stack(
                  children: [
                    Center(
                        child: PlatformMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.latitude,
                          state.longitude,
                        ),
                        zoom: 17,
                      ),
                      markers: Set<Marker>.of(
                        [
                          Marker(
                            markerId: MarkerId('Me'),
                            position: LatLng(state.latitude, state.longitude),
                            icon: myIcon,
                          ),
                        ],
                      ),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      onMapCreated: (controller) {
                        Future.delayed(Duration(seconds: 1)).then(
                          (_) {
                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  bearing: 0.0,
                                  target: LatLng(
                                    state.latitude,
                                    state.longitude,
                                  ),
                                  zoom: 17,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )),
                    Align(
                      alignment: Alignment(-0.9, -0.8),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: 16.0, right: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            print('Gone back');
                          },
                          child: Icon(
                            CupertinoIcons.left_chevron,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.9, -0.8),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(bottom: 16.0, right: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            print('Gone back');
                          },
                          child: Icon(
                            CupertinoIcons.left_chevron,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                body: Stack(
                  children: [
                    PlatformMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.latitude,
                          state.longitude,
                        ),
                        zoom: 17,
                      ),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      onMapCreated: (controller) {
                        Future.delayed(Duration(seconds: 1)).then(
                          (_) {
                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  bearing: 0.0,
                                  target: LatLng(
                                    state.latitude,
                                    state.longitude,
                                  ),
                                  zoom: 17,
                                ),
                              ),
                            );
                          },
                        );
                      },
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
                ),
              );
      },
    );
  }
}
