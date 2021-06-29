/* External dependencies */
import 'package:flutter/material.dart';

/* Local dependencies */
import '../../utils/SubscriptionContainer.dart';


class TermsPrivacyButtons extends StatelessWidget {
  const TermsPrivacyButtons({Key? key}) : super(key: key);

  termsOfUsePressed() {
    SubscriptionContainer.instance.showTermsOfUse();
  }

  privacyPolicyPressed() {
    SubscriptionContainer.instance.showPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: termsOfUsePressed,
            child: Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFB6B6B6),
              ),
            ),
          ),
          Text(
            '|',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFB6B6B6),
            ),
          ),
          TextButton(
            onPressed: privacyPolicyPressed,
            child: Text(
              'Privacy policy',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFB6B6B6),
              ),
            ),
          ),
        ],
      )
    );
  }
}
