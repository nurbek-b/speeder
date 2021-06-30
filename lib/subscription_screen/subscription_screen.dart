/* External dependencies */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

/* Local dependencies */
import '../size_config.dart';
import '../utils/SubscriptionContainer.dart';
import '../tab_bar/navigation_page.dart';
import 'components/continue_button.dart';
import 'components/close_restore.dart';
import 'components/features_button.dart';
import 'components/speedometer.dart';
import 'components/terms_privacy_buttons.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends State<SubscriptionScreen>
    with WidgetsBindingObserver {
  String buttonText = "Continue";
  late double distance;

  /// Current position
  late Position _currentPosition;


  @override
  void initState() {
    super.initState();
    _setupSubscriptionBinder();
  }

  _setupSubscriptionBinder() {
    SubscriptionContainer.instance.register(this);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      print('App is closing!!!');
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      distance = Geolocator.distanceBetween(
        Hive.box('statistics').get('latitude'),
        Hive.box('statistics').get('longitude'),
        _currentPosition.latitude,
        _currentPosition.longitude,
      );
      double oldDistance = Hive.box('statistics').get(formattedDate.toString());
      oldDistance = oldDistance + distance;
      Hive.box('statistics').put(formattedDate.toString(), oldDistance);
    }
    SubscriptionContainer.instance.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// close icon and restore button
            CloseAndRestoreRow(
              onPressedIcon: crossPress,
              onPressedRestore: checkRestore,
            ),

            /// speedometer icon
            LogoAndText(),

            SizedBox(height: getProportionateScreenHeight(20)),

            /// Features text buttons
            FeaturesWidget(
              leftIcon: 'assets/vectors/left_track.png',
              title: 'Track yourself on a map',
              rightIcon: 'assets/vectors/right_track.png',
            ),
            FeaturesWidget(
              leftIcon: 'assets/vectors/access_left.png',
              title: 'Access to statistics',
              rightIcon: 'assets/vectors/access_right.png',
            ),
            FeaturesWidget(
              leftIcon: 'assets/vectors/alerts_left.png',
              title: 'Alerts if you speeding',
              rightIcon: 'assets/vectors/alerts_right.png',
            ),

            SizedBox(height: getProportionateScreenHeight(80)),

            TextButton(
              onPressed: () {},
              child: Text(
                'FREE unlimited access',
                style: TextStyle(
                  color: Color(0xFFD9EE6F),
                  fontSize: 20,
                ),
              ),
            ),

            /// Continue & Policy & Terms buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContinueButton(title: buttonText, onPressed: goPressed),
                TermsPrivacyButtons()
              ],
            ),
          ],
        ),
      ),
    );
  }

  goPressed() async {
    final result = await SubscriptionContainer.instance.submit();
    if (result) {
      SubscriptionContainer.instance.register(null);
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => NavigationPage()));
    }
  }

  crossPress() {
    SubscriptionContainer.instance.register(null);
    print('crosspressed');
    Navigator.pop(context);
  }

  checkRestore() async {
    final result = await SubscriptionContainer.instance.restore();
    if (result) {
      SubscriptionContainer.instance.register(null);
      Navigator.pop(context);
    }
  }
}
