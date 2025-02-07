import 'package:actual/common/const/color.dart';
import 'package:actual/order/model/m_order.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FOrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productsDetail;
  final int price;

  const FOrderCard(
      {super.key,
      required this.orderDate,
      required this.image,
      required this.name,
      required this.productsDetail,
      required this.price});

  factory FOrderCard.fromModel({required MOrder model}) {
    final productsDetail = model.products.length == 1
        ? model.products.first.product.name
        : '${model.products.first.product.name} 외 ${model.products.length - 1}개';

    return FOrderCard(
      name: model.restaurant.name,
      orderDate: model.createdAt,
      image: Image.network(model.restaurant.thumbUrl, width: 50, height: 50, fit: BoxFit.cover),
      productsDetail: productsDetail,
      price: model.totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Gap(8),
        Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(16), child: image),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Gap(8),
                Text('$productsDetail ₩$price', style: const TextStyle(color: COLOR_BODY_TEXT))
              ],
            )
          ],
        ),
        const Gap(16)
      ],
    );
  }
}
