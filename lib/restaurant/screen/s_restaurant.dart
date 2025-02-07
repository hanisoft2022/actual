import 'package:actual/common/fragment/f_pagination_list_view.dart';
import 'package:actual/restaurant/fragment/f_restaurant_card.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';

import 'package:actual/restaurant/screen/s_restaurant_detail.dart';

import 'package:actual/restaurant/provider/restaurant_provider.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class SRestaurant extends StatelessWidget {
  const SRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    return FPaginationListView<MRestaurant>(
      provider: restaurantProvider,
      itemBuilder: <MRestaurant>(_, __, model) => InkWell(
          onTap: () => context.goNamed(
                SRestaurantDetail.routeName,
                pathParameters: {'rid': model.id},
              ),
          child: FRestaurantCard.fromMRestaurant(model: model)),
    );
  }
}
