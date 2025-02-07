import 'package:actual/common/fragment/f_pagination_list_view.dart';
import 'package:actual/order/fragment/f_order_card.dart';
import 'package:actual/order/model/m_order.dart';

import 'package:actual/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SOrder extends ConsumerStatefulWidget {
  const SOrder({super.key});

  @override
  ConsumerState<SOrder> createState() => _SOrderState();
}

class _SOrderState extends ConsumerState<SOrder> {
  @override
  void initState() {
    super.initState();
    ref.read(orderProvider.notifier).paginate(forceRefetch: true);
  }

  @override
  Widget build(BuildContext context) {
    return FPaginationListView<MOrder>(
      provider: orderProvider,
      itemBuilder: <MOrder>(_, __, model) => FOrderCard.fromModel(model: model),
    );
  }
}
