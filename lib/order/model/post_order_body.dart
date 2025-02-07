import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable()
class MPostOrderBodyProduct {
  final String productId;
  final int count;

  MPostOrderBodyProduct({required this.productId, required this.count});

  factory MPostOrderBodyProduct.fromJson(Map<String, dynamic> json) => _$MPostOrderBodyProductFromJson(json);

  Map<String, dynamic> toJson() => _$MPostOrderBodyProductToJson(this);
}

@JsonSerializable()
class MPostOrderBody {
  final String id;
  final List<MPostOrderBodyProduct> products;
  final int totalPrice;
  final String createdAt;

  MPostOrderBody({required this.id, required this.products, required this.totalPrice, required this.createdAt});

  factory MPostOrderBody.fromJson(Map<String, dynamic> json) => _$MPostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$MPostOrderBodyToJson(this);
}
