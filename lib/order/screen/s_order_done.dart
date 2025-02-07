import 'package:actual/common/const/color.dart';
import 'package:actual/common/layout/l_default.dart';
import 'package:actual/common/screen/s_root_tab.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SOrderDone extends StatelessWidget {
  static String get routeName => 'orderDone';

  const SOrderDone({super.key});

  @override
  Widget build(BuildContext context) {
    return LDefault(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.thumb_up_alt_outlined, color: COLOR_PRIMARY, size: 50),
                const Gap(32),
                const Text('결제가 완료되었습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: COLOR_PRIMARY)),
                const Gap(42),
                ElevatedButton(
                    onPressed: () => context.goNamed(
                          SRootTab.routeName,
                        ),
                    style: ElevatedButton.styleFrom(backgroundColor: COLOR_PRIMARY, foregroundColor: Colors.white),
                    child: const Text('홈으로'))
              ],
            )));
  }
}
