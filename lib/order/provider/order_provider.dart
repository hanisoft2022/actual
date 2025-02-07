import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/order/model/m_order.dart';
import 'package:actual/order/model/post_order_body.dart';
import 'package:actual/order/repository/order_repository.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider = StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>(
  (ref) {
    final repo = ref.watch(orderRepositoryProvider);
    return OrderStateNotifier(ref: ref, repository: repo);
  },
);

class OrderStateNotifier extends PaginationProvider<MOrder, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({required super.repository, required this.ref});

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();

      final id = uuid.v4();

      final state = ref.read(basketProvider);

      await repository.postOrder(
          body: MPostOrderBody(
              id: id,
              products: state.map((e) => MPostOrderBodyProduct(productId: e.product.id, count: e.count)).toList(),
              totalPrice: state.map((e) => e.product.price * e.count).sum,
              createdAt: DateTime.now().toString()));

      ref.read(basketProvider.notifier).clearBasket();
      return true;
    } catch (e) {
      return false;
    }
  }
}
