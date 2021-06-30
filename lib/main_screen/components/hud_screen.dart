/* External dependencies */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Local dependencies */
import '../../utils/geo_service.dart';
import '../../size_config.dart';
import 'main_screen_bloc.dart';
import 'main_screen_state.dart';

class LiveHudScreen extends StatefulWidget {
  const LiveHudScreen({Key? key}) : super(key: key);

  @override
  _LiveHudScreenState createState() => _LiveHudScreenState();
}

class _LiveHudScreenState extends State<LiveHudScreen> {

  /// Current Velocity in m/s
  late double _velocity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _velocity = context.read<MainScreenBloc>().state.velocity.toDouble();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return StreamBuilder<double>(
            stream: GeoService.instance.velocityUpdatedStreamController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Container(
                color: Colors.black,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                        text: convertedVelocity(
                            state.velocityUnit.toUpperCase(), snapshot.data!),
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

  /// Velocity in m/s to miles per hour converter
  double kphtomilesph(double mps) => mps * 1.609;

  /// Relevant velocity in chosen unit
  String convertedVelocity(String unit, double velocity) {
    if (unit == 'KMH')
      return velocity.toInt().toString();
    else if (unit == 'MPH') return kphtomilesph(velocity).toInt().toString();
    return velocity.toInt().toString();
  }
}
