/* External dependencies */
import 'package:flutter/material.dart';

class CloseAndRestoreRow extends StatelessWidget {
  final GestureTapCallback onPressedIcon;
  final GestureTapCallback onPressedRestore;

  const CloseAndRestoreRow({
    Key? key,
    required this.onPressedIcon,
    required this.onPressedRestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/icons/xmark_icon.png',
            color: Color(0xFFB6B6B6),
            height: 16,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Restore purchases',
              style: TextStyle(
                color: Color(0xFFB6B6B6),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
