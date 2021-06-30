/* External dependencies */
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

/* Local dependencies */
import '../../size_config.dart';
import '../../utils/geo_service.dart';
import '../../utils/SubscriptionContainer.dart';
import '../../subscription_screen/subscription_screen.dart';
import 'main_screen_bloc.dart';
import 'main_screen_state.dart';

class LiveGeoMap extends StatefulWidget {
  const LiveGeoMap({Key? key}) : super(key: key);

  @override
  _LiveGeoMapState createState() => _LiveGeoMapState();
}

class _LiveGeoMapState extends State<LiveGeoMap> {
  late BitmapDescriptor myIcon;

  late var latitude, longitude;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(10, 10)),
      'assets/icons/map_marker_icon.png',
    ).then((onValue) {
      myIcon = onValue;
    }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<bool>(
      initialData: false,
      stream: SubscriptionContainer.instance.isSubscribed(),
      builder: (context, isSubscribed) {
        return BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, state) {
            return isSubscribed.data!
                ? Scaffold(
                    bottomNavigationBar: StreamBuilder<double>(
                        initialData: 0,
                        stream: GeoService.instance.velocityUpdatedStreamController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.black,
                              child: Stack(children: [
                                Center(
                                  child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor: Color(0xFFFF5C00)),
                                ),
                                Align(
                                  alignment: Alignment(-0.9, -0.8),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16.0, right: 16.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        print('Gone back');
                                      },
                                      child: Icon(
                                        CupertinoIcons.left_chevron,
                                        size: 35,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          }
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
                                    '${convertedVelocity(state.velocityUnit.toUpperCase(), snapshot.data!)} ${state.velocityUnit}',
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
                            Future.delayed(Duration(milliseconds: 1)).then(
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
                          alignment: Alignment(0.95, -0.85),
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.clear,
                              size: 30,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => SubscriptionScreen()));
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
    );
  }

  /// Velocity in m/s to miles per hour converter
  double kphtomilesph(double mps) => mps * 85 / 38;

  /// Relevant velocity in chosen unit
  String convertedVelocity(String unit, double velocity) {
    if (unit == 'KMH')
      return velocity.toInt().toString();
    else if (unit == 'MPH') return kphtomilesph(velocity).toInt().toString();
    return velocity.toInt().toString();
  }
}
