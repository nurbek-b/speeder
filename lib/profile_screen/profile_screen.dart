/* External dependencies */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

/* Local dependencies */
import '../size_config.dart';
import '../main_screen/components/main_screen_bloc.dart';
import '../main_screen/components/main_screen_state.dart';
import '../utils/SubscriptionContainer.dart';
import 'components/limit_and_alert.dart';
import 'components/profile_item.dart';
import 'components/scale_checkbox.dart';
import 'components/speed_unit_checkbox.dart';

const String privacyPolicy =
    'https://translate.google.com/?sl=en&tl=ru&text=privacy%20policy&op=translate';
const String termsOfUse =
    'https://translate.google.com/?sl=en&tl=ru&text=terms%20of%20use%0A&op=translate';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(110),
        backgroundColor: Color(0xFF252525),
        title: Text(
          'STATISTICS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'BarlowCondensed-Regular',
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(1),
                    horizontal: getProportionateScreenWidth(10),
                  ),
                  child: ProfileItem(
                    onPressed: () {
                      print('units pressed');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<MainScreenBloc>(context),
                            child: SpeedUnitCheckBox(),
                          ),
                        ),
                      );
                    },
                    icon: 'assets/icons/speed_icon.png',
                    title: 'SPEED UNITS',
                    actual: state.velocityUnit,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(1),
                    horizontal: getProportionateScreenWidth(10),
                  ),
                  child: ProfileItem(
                    onPressed: () {
                      print('scale pressed');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<MainScreenBloc>(context),
                            child: ScaleCheckBox(),
                          ),
                        ),
                      );
                    },
                    icon: 'assets/icons/scale_icon.png',
                    title: 'SCALE',
                    actual: state.scale,
                  ),
                ),
                StreamBuilder<bool>(
                  initialData: false,
                  stream: SubscriptionContainer.instance.isSubscribed(),
                  builder: (context, isSubscribed) {
                    return isSubscribed.data!
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(1),
                              horizontal: getProportionateScreenWidth(10),
                            ),
                            child: ProfileItem(
                              onPressed: () {
                                print('limit pressed');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<MainScreenBloc>(context),
                                      child: LimitAndAlert(),
                                    ),
                                  ),
                                );
                              },
                              icon: 'assets/icons/limit_icon.png',
                              title: 'SPEED LIMIT',
                              actual: state.velocityLimit.toString(),
                            ),
                          )
                        : Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(1),
                                  horizontal: getProportionateScreenWidth(10),
                                ),
                                child: ProfileItem(
                                  onPressed: () {},
                                  icon: 'assets/icons/limit_icon.png',
                                  title: 'SPEED LIMIT',
                                  actual: state.velocityLimit.toString(),
                                ),
                              ),
                              Container(
                                height: getProportionateScreenHeight(80),
                                width: double.infinity,
                                color: Colors.black54,
                              ),
                            ],
                          );
                  }
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20),
                    horizontal: getProportionateScreenWidth(10),
                  ),
                  child: Container(
                    height: getProportionateScreenHeight(80),
                    decoration: BoxDecoration(
                      color: Color(0xFF252525),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: InkWell(
                      onTap: showPrivacyPolicy,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'PRIVACY POLICY',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            CupertinoIcons.chevron_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(20),
                    horizontal: getProportionateScreenWidth(10),
                  ),
                  child: Container(
                    height: getProportionateScreenHeight(80),
                    decoration: BoxDecoration(
                      color: Color(0xFF252525),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: InkWell(
                      onTap: showTermsOfUse,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'TERMS OF USE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                          Spacer(),
                          Icon(CupertinoIcons.chevron_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  showTermsOfUse() {
    launch(termsOfUse);
  }

  showPrivacyPolicy() {
    launch(privacyPolicy);
  }
}
