import 'package:actual/common/model/cursor_pagination_model.dart';

import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';
import 'package:actual/restaurant/model/m_restaurant_detail.dart';

import 'package:actual/restaurant/repository/repo_restaurant.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider = Provider.family<MRestaurant?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider = StateNotifierProvider<RestaurantNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(repoRestaurantProvider);
  final notifier = RestaurantNotifier(repository: repository);
  return notifier;
});

class RestaurantNotifier extends PaginationProvider<MRestaurant, RepoRestaurant> {
  RestaurantNotifier({required super.repository});

  void getDetail({required String id}) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (즉, CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // 시도를 했음에도 불구하고 state가 CursorPagination이 아니라면 그냥 return함.
    if (state is! CursorPagination) {
      return;
    }

    // 지금부터 진짜!!
    final pState = state as CursorPagination<MRestaurant>;

    final MRestaurantDetail resp = await repository.getRestaurantDetail(id);

    if (pState.data.where((element) => element.id == id).isEmpty) {
      // [MRestaurant(1), MRestaurant(2), MRestaurant(3)]
      // 요청 id: 10
      // list.where((element) => element.id == 10) 데이터 X
      // 데이터가 없을 때는 그냥 캐시의 끝에다가 데이터를 추가해버린다.
      // [MRestaurant(1), MRestaurant(2), MRestaurant(3),
      // MRestaurantDetail(10)]
      state = pState.copyWith(data: <MRestaurant>[...pState.data, resp]);
    } else {
      // [MRestaurant(1), MRestaurant(2), MRestaurant(3)]
      // id가 2인 친구의 detail 모델을 가져와라.
      // getDetail(id: 2);
      // [MRestaurant(1), MRestaurantDetail(2), MRestaurant(3)]
      state = pState.copyWith(data: pState.data.map<MRestaurant>((e) => e.id == id ? resp : e).toList());
    }
  }
}
