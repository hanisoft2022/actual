import 'package:actual/common/const/color.dart';

import 'package:actual/common/layout/l_default.dart';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class SSplash extends StatelessWidget {
  static String get routeName => 'splash';

  const SSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return LDefault(
      backgroundColor: COLOR_PRIMARY,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/hanisoft_logo(transparent_background).png',
              color: Colors.white,
              width: MediaQuery.of(context).size.width / 2,
            ),
            const Gap(16),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
