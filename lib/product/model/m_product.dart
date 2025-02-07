import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/utils_data.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_product.g.dart';

@JsonSerializable()
class MProduct implements IModelWithId {
  @override
  final String id;
  final String name;
  final String detail;
  @JsonKey(fromJson: UtilsData.pathToUrl)
  final String imgUrl;
  final int price;
  final MRestaurant restaurant;

  MProduct({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
    required this.restaurant,
  });

  factory MProduct.fromJson(Map<String, dynamic> json) => _$MProductFromJson(json);
}
