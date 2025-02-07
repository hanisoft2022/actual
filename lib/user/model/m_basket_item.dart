import 'package:actual/product/model/m_product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_basket_item.g.dart';

@JsonSerializable()
class MBasketItem {
  final MProduct product;
  final int count;

  MBasketItem({
    required this.product,
    required this.count,
  });

  MBasketItem copyWith({
    MProduct? product,
    int? count,
  }) {
    return MBasketItem(
      product: product ?? this.product,
      count: count ?? this.count,
    );
  }

  factory MBasketItem.fromJson(Map<String, dynamic> json) => _$MBasketItemFromJson(json);
}
