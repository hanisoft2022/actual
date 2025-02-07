import 'package:actual/product/model/m_product.dart';
import 'package:actual/user/model/m_basket_item.dart';
import 'package:actual/user/model/m_patch_basket_body.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:collection/collection.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider = StateNotifierProvider<BasketProvider, List<MBasketItem>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);

    return BasketProvider(repository: repository);
  },
);

class BasketProvider extends StateNotifier<List<MBasketItem>> {
  final UserMeRepository repository;

  // debounce [1]. Debounce 인스턴스화
  final updateBasketDebounce = Debouncer(const Duration(seconds: 1), initialValue: null, checkEquality: false);

  BasketProvider({required this.repository}) : super([]) {
    /*
    debounce [3]. Debounce 인스턴스에 이벤트 연결
    'debounce [2]'에서 setValue에 할당한 아규먼트가 아래 state에 해당됨.
    'debounce [1]'에서 설정된 기간 1초 이내의 이벤트는 patchBasket 메서드 호출하지 않음.
    */
    updateBasketDebounce.values.listen((_) => patchBasket());
  }

  // 장바구니 상품 수정 메서드
  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: MPatchBasketBody(
            listOfBasketItems:
                state.map((e) => PatchBasketBodyBasket(productId: e.product.id, count: e.count)).toList()));
  }

  // 장바구니에 아이템(MBasketItem) 추가 메서드
  Future<void> addToBasket({
    required MProduct product,
  }) async {
    /*
    장바구니 안에 상품의 유무의 따라 경우의 수 2가지로 나눌 수 있다.
    case 1. 장바구니에 추가하려는 상품이 존재하지 않는 경우
            -> 장바구니에 상품을 추가한다.
    case 2. 장바구니에 추가하려는 상품이 이미 존재하는 경우
            -> 장바구니에 있는 상품의 count 값을 +1 한다.
   */

    final bool exists = state.firstWhereOrNull((element) => element.product.id == product.id) != null;

    // case 1
    if (!exists) {
      state = [...state, MBasketItem(product: product, count: 1)];
    } else {
      // case 2
      state = state.map((e) => e.product.id == product.id ? e.copyWith(count: e.count + 1) : e).toList();
    }

    // Optimistic Response (긍정적 응답)
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트함.
    // debounce [2]. Debounce 인스턴스에 아규먼트 할당('debounce [3]'으로 이동).
    updateBasketDebounce.setValue(null);
  }

  // 장바구니에 아이템(MBasketItem) 삭제 메서드
  Future<void> removeFromBasket({
    required MProduct product,
    // true면 count와 관계없이 아예 삭제한다.
    bool isDelete = false,
  }) async {
    // 장바구니 안에 상품의 유무의 따라 경우의 수 2가지로 나눌 수 있다.
    // case 1. 장바구니에 상품이 없다면
    //         -> 즉시 함수를 반환하고 아무것도 하지 않는다.
    // case 2. 장바구니에 추가하려는 상품이 존재하는 경우
    //         -> 1) 상품의 카운트가 1이면 삭제한다.
    //         -> 2) 상품의 카운트가 1보다 크면 -1 한다.

    final bool exists = state.firstWhereOrNull((element) => element.product.id == product.id) != null;

    // case 1
    if (!exists) {
      return;
    }

    final MBasketItem existingProduct = state.firstWhere((element) => element.product.id == product.id);

    // case 2
    // case 2-1)
    if (existingProduct.count == 1 || isDelete) {
      state = state.where((element) => element.product.id != product.id).toList();
    } else {
      // case 2-2)
      state = state.map((e) => e.product.id == product.id ? e.copyWith(count: e.count - 1) : e).toList();
    }
    // Optimistic Response (긍정적 응답)
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트함.
    // debounce [2]. Debounce 인스턴스에 아규먼트 할당('debounce [3]'으로 이동).
    updateBasketDebounce.setValue(null);
  }

  String getItemTotalPrice(String id) {
    final MBasketItem item = state.firstWhere((element) => element.product.id == id);
    return (item.count * item.product.price).toString();
  }

  int getCount(String id) {
    return state.firstWhere((element) => element.product.id == id).count;
  }

  int get totalPrice {
    return state.map((e) => e.count * e.product.price).sum;
  }

  // 장바구니 초기화 메서드
  void clearBasket() {
    state = [];
    updateBasketDebounce.setValue(null);
  }
}
