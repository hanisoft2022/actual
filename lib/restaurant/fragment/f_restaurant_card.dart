import 'package:actual/common/const/color.dart';

import 'package:actual/restaurant/model/m_restaurant_detail.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget renderDot() => const Text(' · ', style: TextStyle(color: Colors.black));

class FRestaurantCard extends StatelessWidget {
  final Image image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings;
  final bool isDetail;
  final String? heroKey;
  final String? detail;

  const FRestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    this.heroKey,
  });

  factory FRestaurantCard.fromMRestaurant({
    required MRestaurant model,
    bool isDetail = false,
  }) =>
      FRestaurantCard(
        image: Image.network(
          model.thumbUrl,
          fit: BoxFit.cover,
        ),
        name: model.name,
        tags: model.tags,
        ratingsCount: model.ratingsCount,
        deliveryTime: model.deliveryTime,
        deliveryFee: model.deliveryFee,
        ratings: model.ratings,
        isDetail: isDetail,
        heroKey: model.id,
        detail: model is MRestaurantDetail ? model.detail : null,
      );

  @override
  Widget build(BuildContext context) {
    final List<WIconText> cIconTextComponents = [
      WIconText(icon: Icons.star, label: '${ratings.toString()}점'),
      WIconText(icon: Icons.receipt, label: '${ratingsCount.toString()}건'),
      WIconText(icon: Icons.timelapse_outlined, label: '$deliveryTime분'),
      WIconText(icon: Icons.monetization_on, label: deliveryFee == 0 ? '무료' : '${deliveryFee.toString()}원'),
    ];

    return Column(
      children: [
        if (heroKey != null)
          Hero(
              tag: ValueKey(heroKey),
              child: ClipRRect(borderRadius: BorderRadius.circular(isDetail ? 0 : 15), child: image)),
        if (heroKey == null) ClipRRect(borderRadius: BorderRadius.circular(isDetail ? 0 : 15), child: image),
        const Gap(15),
        Padding(
          padding: isDetail ? const EdgeInsets.symmetric(horizontal: 15) : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Gap(8),
              Text(tags.join(' · '), style: const TextStyle(color: COLOR_BODY_TEXT, fontSize: 14)),
              const Gap(8),
              Row(
                children: cIconTextComponents
                    .expand(
                      (widget) => [widget, renderDot()],
                    )
                    .toList()
                  ..removeLast(),
              ),
              if (isDetail && detail != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class WIconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const WIconText({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: COLOR_PRIMARY,
          size: 14,
        ),
        const Gap(4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
