import 'package:actual/common/fragment/f_pagination_list_view.dart';
import 'package:actual/product/fragment/f_product_card.dart';
import 'package:actual/product/model/m_product.dart';
import 'package:actual/product/provider/product_provider.dart';
import 'package:actual/restaurant/screen/s_restaurant_detail.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SProduct extends StatelessWidget {
  const SProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return FPaginationListView<MProduct>(
        provider: productProvider,
        itemBuilder: <MProduct>(_, __, model) => GestureDetector(
            onTap: () => context.goNamed(
                  SRestaurantDetail.routeName,
                  pathParameters: {'rid': model.restaurant.id},
                ),
            child: FProductCard.fromMProduct(model: model)));
  }
}
