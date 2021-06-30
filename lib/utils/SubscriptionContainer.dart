import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../subscription_screen/subscription_screen.dart';

final String privacyPolicy =
    'https://translate.google.com/?sl=en&tl=ru&text=privacy%20policy&op=translate';
final String termsOfUse =
    'https://translate.google.com/?sl=en&tl=ru&text=terms%20of%20use%0A&op=translate';
final String support =
    'https://translate.google.com/?sl=en&tl=ru&text=support%0A&op=translate';
final String appleAppID = "123456789";
final String supportEmail = 'admin@gmail.com';

const apphudplatform = const MethodChannel('com.example/tracker');

class SubscriptionContainer extends WidgetsBindingObserver {
  SubscriptionContainer._privateConstructor();

  static final SubscriptionContainer _instance =
      SubscriptionContainer._privateConstructor();

  static SubscriptionContainer get instance => _instance;

  final BehaviorSubject<bool> _isSubscribed = BehaviorSubject.seeded(false);

  Stream<bool> isSubscribed() => _isSubscribed.stream;

  SubscriptionScreenState? subscriptionPageState;

  setupStorage() async {
    await Hive.initFlutter();
    await Hive.openBox('settings');

    _isSubscribed.add(Hive.box('settings').get('subscribed', defaultValue: false));

    await _emmitAppleInit();

    return;
  }

  register(SubscriptionScreenState? subscriptionPageState) async {
    this.subscriptionPageState = subscriptionPageState;
  }

  Future<void> _emmitAppleInit() async {
    try {
      final String a = await apphudplatform.invokeMethod('AppleEmmit');
      print(a);
      print('Emmit Apple success1');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  showTermsOfUse() {
    launch(termsOfUse);
  }

  showPrivacyPolicy() {
    launch(privacyPolicy);
  }

  showSupport() {
    launch(support);
  }

  Future<bool> restore() async {
    final hasSubscription =
        await Hive.box('settings').get('subscribed', defaultValue: false);
    _isSubscribed.add(hasSubscription);
    if (!hasSubscription) {
      _showSubscriptionNotFound();
    }
    return hasSubscription;
  }

  _showSubscriptionNotFound() {
    final BuildContext? context = subscriptionPageState?.context;
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Subscription not found"),
            content: Text(
                'Your subscription is not found.\nPlease send your issues to: $supportEmail'),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            elevation: 5,
          );
        },
      );
    }
  }

  Future<bool> submit() async {
    await Hive.box('settings').put('subscribed', true);
    _isSubscribed.add(true);
    return true;
  }

  didChangeAppLifecycleState(AppLifecycleState state) {
    print('todo: handle $state');
  }
}
