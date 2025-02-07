import 'package:actual/common/const/color.dart';
import 'package:actual/common/layout/l_default.dart';
import 'package:actual/order/provider/order_provider.dart';
import 'package:actual/order/screen/s_order_done.dart';
import 'package:actual/product/fragment/f_product_card.dart';

import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SBasket extends ConsumerWidget {
  static String get routeName => 'basket';

  const SBasket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const LDefault(
        title: '장바구니',
        child: Center(
          child: Text(
            '장바구니가 비었습니다.\n 음식을 추가해주세요.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // final productsTotalPrice = basket.fold(
    //   0,
    //   (previousValue, nextValue) => previousValue + nextValue.count * nextValue.product.price,
    // );
    final int productsTotalPrice = ref.watch(basketProvider.notifier).totalPrice;

    final deliveryFee = basket.first.product.restaurant.deliveryFee;
    return LDefault(
        title: '장바구니',
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
                child: Column(children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 32,
                  ),
                  itemBuilder: (context, index) {
                    final model = basket[index];

                    return FProductCard.fromMProduct(
                      model: model.product,
                      onAdd: () {
                        ref.read(basketProvider.notifier).addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref.read(basketProvider.notifier).removeFromBasket(product: model.product);
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              const Gap(20),
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('장바구니 금액', style: TextStyle(color: COLOR_BODY_TEXT)),
                    Text('₩$productsTotalPrice')
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('배달비', style: TextStyle(color: COLOR_BODY_TEXT)), Text('W$deliveryFee')]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('총액', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₩${productsTotalPrice + deliveryFee}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              ]),
              const Gap(12),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        final resp = await ref.read(orderProvider.notifier).postOrder();

                        if (resp) {
                          if (context.mounted) {
                            context.goNamed(SOrderDone.routeName);
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('결제를 실패하였습니다.')));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: COLOR_PRIMARY, foregroundColor: Colors.white),
                      child: const Text('결제하기'))),
            ]))));
  }
}
