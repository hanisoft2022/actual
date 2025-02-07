import 'package:actual/common/const/color.dart';
import 'package:actual/common/layout/l_default.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/utils/utils_pagination.dart';
import 'package:actual/product/fragment/f_product_card.dart';
import 'package:actual/product/model/m_product.dart';
import 'package:actual/rating/fragment/f_rating_card.dart';
import 'package:actual/rating/model/m_rating.dart';
import 'package:actual/restaurant/fragment/f_restaurant_card.dart';

import 'package:actual/restaurant/model/m_restaurant.dart';

import 'package:actual/restaurant/model/m_restaurant_detail.dart';

import 'package:actual/restaurant/provider/restaurant_provider.dart';

import 'package:actual/restaurant/provider/restaurant_rating_provider.dart';
import 'package:actual/restaurant/screen/s_basket.dart';
import 'package:actual/user/model/m_basket_item.dart';

import 'package:actual/user/provider/basket_provider.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:badges/badges.dart' as badges;
import 'package:skeletonizer/skeletonizer.dart';

class SRestaurantDetail extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

  final String id;

  const SRestaurantDetail({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<SRestaurantDetail> createState() => _SRestaurantDetailState();
}

class _SRestaurantDetailState extends ConsumerState<SRestaurantDetail> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    UtilsPagination.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MRestaurant? state = ref.watch(restaurantDetailProvider(widget.id));
    final CursorPaginationBase ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final List<MBasketItem> listOfBasketItems = ref.watch(basketProvider);

    final bool isLoading = state == null;

    if (state == null) {
      return const LDefault(child: Center(child: CircularProgressIndicator()));
    }

    return LDefault(
        title: state.name,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed(SBasket.routeName);
            },
            backgroundColor: COLOR_PRIMARY,
            child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.white),
                showBadge: listOfBasketItems.isNotEmpty,
                badgeContent: Text(listOfBasketItems.map((e) => e.count).sum.toString(),
                    style: const TextStyle(color: COLOR_PRIMARY, fontSize: 10, fontWeight: FontWeight.bold)),
                child: const Icon(Icons.shopping_basket_outlined))),
        child: Skeletonizer(
          enabled: isLoading,
          child: CustomScrollView(controller: controller, slivers: [
            FRestaurantDetailHeader(model: state),
            // 해당 부분은 추후 skeletonizer 패키지 사용
            if (state is! MRestaurantDetail) const FRestaurantDetailSkeleton(),
            if (state is MRestaurantDetail) ...[
              const CategoryTitle(title: '메뉴'),
              FRestaurantProductsList(
                products: state.products,
                restaurant: state,
                ref: ref,
              ),
              const CategoryTitle(title: '후기'),
              if (ratingsState is CursorPagination<MRating>) FRestaurantDetailRatings(models: ratingsState.data)
            ]
          ]),
        ));
  }
}

class FRestaurantDetailHeader extends StatelessWidget {
  final MRestaurant model;

  const FRestaurantDetailHeader({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FRestaurantCard.fromMRestaurant(
        model: model,
        isDetail: true,
      ),
    );
  }
}

class FRestaurantDetailSkeleton extends StatelessWidget {
  const FRestaurantDetailSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverSkeletonizer(
      child: SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('skeleton text skeleton text'),
              Text('skeleton text skeleton text skeleton text'),
              Text(''),
              Text(
                'skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text skeleton text',
              ),
            ],
          ),
          // 모양 안 살리고 줄바꿈 되는 일반적인 text를 사용하려면 아래와 같이 Text위젯을 Flexible 위젯으로 감싸기
          // Text 위젯을 Flexible 위젯으로 감쌀 경우 자동 줄바꿈이 된다.
          // Flexible(child: Text('줄바꿈 되는 일반적인 text'))
        ),
      ),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  final String title;

  const CategoryTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ));
  }
}

class FRestaurantProductsList extends StatelessWidget {
  final MRestaurant restaurant;
  final List<MRestaurantDetailProduct> products;
  final WidgetRef ref;

  const FRestaurantProductsList({super.key, required this.products, required this.ref, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final MRestaurantDetailProduct item = products[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () {
                    ref.read(basketProvider.notifier).addToBasket(
                          product: MProduct(
                            id: item.id,
                            name: item.name,
                            imgUrl: item.imgUrl,
                            detail: item.detail,
                            price: item.price,
                            restaurant: restaurant,
                          ),
                        );
                  },
                  child: FProductCard.fromMRestaurantDetailProduct(model: item),
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}

class FRestaurantDetailRatings extends StatelessWidget {
  final List<MRating> models;

  const FRestaurantDetailRatings({
    super.key,
    required this.models,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), child: FRatingCard.fromModel(model: models[index])),
                childCount: models.length)));
  }
}
