import 'package:json_annotation/json_annotation.dart';

part 'm_patch_basket_body.g.dart';

@JsonSerializable()
// Patch Basket Body 안에 있는 Basket라는 뜻
class PatchBasketBodyBasket {
  final String productId;
  final int count;

  PatchBasketBodyBasket({required this.productId, required this.count});

  factory PatchBasketBodyBasket.fromJson(Map<String, dynamic> json) => _$PatchBasketBodyBasketFromJson(json);

  Map<String, dynamic> toJson() => _$PatchBasketBodyBasketToJson(this);
}

@JsonSerializable()
class MPatchBasketBody {
  final List<PatchBasketBodyBasket> listOfBasketItems;

  MPatchBasketBody({required this.listOfBasketItems});

  Map<String, dynamic> toJson() => _$MPatchBasketBodyToJson(this);
}
