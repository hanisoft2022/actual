import 'package:actual/common/const/color.dart';
import 'package:actual/product/model/m_product.dart';

import 'package:actual/restaurant/model/m_restaurant_detail.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class FProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const FProductCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    required this.onSubtract,
    required this.onAdd,
  });

  factory FProductCard.fromMProduct({
    required MProduct model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) =>
      FProductCard(
        id: model.id,
        image: Image.network(
          model.imgUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price,
        onSubtract: onSubtract,
        onAdd: onAdd,
      );

  factory FProductCard.fromMRestaurantDetailProduct({
    required MRestaurantDetailProduct model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) =>
      FProductCard(
        id: model.id,
        image: Image.network(
          model.imgUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price,
        onSubtract: onSubtract,
        onAdd: onAdd,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final basket = ref.watch(basketProvider);

    return Column(children: [
      SizedBox(
        height: 100,
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(15), child: image),
            const Gap(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: COLOR_BODY_TEXT,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₩ ${price.toString()}',
                    style: const TextStyle(
                      color: COLOR_PRIMARY,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (onSubtract != null && onAdd != null)
        Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
                // total: (basket.firstWhere((element) => element.product.id == id).count *
                //         basket.firstWhere((element) => element.product.id == id).product.price)
                //     .toString(),
                totalPrice: ref.watch(basketProvider.notifier).getItemTotalPrice(id),
                // count: basket.firstWhere((element) => element.product.id == id).count,
                count: ref.watch(basketProvider.notifier).getCount(id),
                onSubtract: onSubtract!,
                onAdd: onAdd!))
    ]);
  }
}

class _Footer extends StatelessWidget {
  final String totalPrice;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    required this.totalPrice,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Text('총액 ₩ $totalPrice', style: const TextStyle(color: COLOR_PRIMARY, fontWeight: FontWeight.bold))),
      Row(children: [
        renderButton(icon: Icons.remove, onTap: onSubtract),
        const Gap(8),
        SizedBox(
            width: 20,
            child: Text(count.toString(),
                style: const TextStyle(
                  color: COLOR_PRIMARY,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center)),
        const Gap(8),
        renderButton(icon: Icons.add, onTap: onAdd)
      ])
    ]);
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: COLOR_PRIMARY,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon),
      ),
    );
  }
}
