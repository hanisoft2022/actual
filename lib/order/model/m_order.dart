import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/utils_data.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_order.g.dart';

@JsonSerializable()
class MOrderProduct {
  final String id;
  final String name;
  @JsonKey(fromJson: UtilsData.pathToUrl)
  final String imgUrl;
  final String detail;
  final int price;

  MOrderProduct(
      {required this.id, required this.name, required this.detail, required this.imgUrl, required this.price});

  factory MOrderProduct.fromJson(Map<String, dynamic> json) => _$MOrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$MOrderProductToJson(this);
}

@JsonSerializable()
class MOrderProductAndCount {
  final MOrderProduct product;
  final int count;

  MOrderProductAndCount({required this.product, required this.count});

  factory MOrderProductAndCount.fromJson(Map<String, dynamic> json) => _$MOrderProductAndCountFromJson(json);
}

@JsonSerializable()
class MOrder implements IModelWithId {
  @override
  final String id;
  final List<MOrderProductAndCount> products;
  final MRestaurant restaurant;
  final int totalPrice;
  @JsonKey(fromJson: UtilsData.stringToDateTime)
  final DateTime createdAt;

  MOrder(
      {required this.id,
      required this.products,
      required this.restaurant,
      required this.totalPrice,
      required this.createdAt});

  factory MOrder.fromJson(Map<String, dynamic> json) => _$MOrderFromJson(json);
}
