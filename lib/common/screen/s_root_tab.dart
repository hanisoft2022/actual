import 'package:actual/common/const/color.dart';

import 'package:actual/common/layout/l_default.dart';

import 'package:actual/order/screen/s_order.dart';
import 'package:actual/product/screen/s_product.dart';
import 'package:actual/restaurant/screen/s_basket.dart';
import 'package:actual/restaurant/screen/s_restaurant.dart';
import 'package:actual/user/provider/basket_provider.dart';

import 'package:actual/user/screen/s_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:badges/badges.dart' as badges;

class SRootTab extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const SRootTab({super.key});

  @override
  ConsumerState<SRootTab> createState() => _SRootTabState();
}

class _SRootTabState extends ConsumerState<SRootTab> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(
      () => setState(() {}),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LDefault(
      title: '하니의 배달민족',
      iconButton: IconButton(
          onPressed: () {
            context.pushNamed(SBasket.routeName);
          },
          icon: badges.Badge(
              showBadge: ref.watch(basketProvider).isNotEmpty,
              position: badges.BadgePosition.topEnd(top: -3, end: -3),
              badgeStyle: const badges.BadgeStyle(padding: EdgeInsets.all(3)),
              child: const Icon(Icons.shopping_basket, color: COLOR_PRIMARY))),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: COLOR_PRIMARY,
        unselectedItemColor: COLOR_BODY_TEXT,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: controller.index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: '프로필'),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          SRestaurant(),
          SProduct(),
          SOrder(),
          SProfile(),
        ],
      ),
    );
  }
}
