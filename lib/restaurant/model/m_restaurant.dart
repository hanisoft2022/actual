import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/utils_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_restaurant.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class MRestaurant implements IModelWithId {
  @override
  final String id;
  final String name;
  @JsonKey(fromJson: UtilsData.pathToUrl)
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  MRestaurant({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory MRestaurant.fromJson(Map<String, dynamic> json) => _$MRestaurantFromJson(json);
}
