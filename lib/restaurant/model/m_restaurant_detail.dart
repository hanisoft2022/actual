import 'package:actual/common/utils/utils_data.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_restaurant_detail.g.dart';

@JsonSerializable()
class MRestaurantDetailProduct {
  final String id;
  final String name;
  final String detail;
  @JsonKey(fromJson: UtilsData.pathToUrl)
  final String imgUrl;
  final int price;

  MRestaurantDetailProduct({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory MRestaurantDetailProduct.fromJson(Map<String, dynamic> json) => _$MRestaurantDetailProductFromJson(json);
}

@JsonSerializable()
class MRestaurantDetail extends MRestaurant {
  final String detail;
  final List<MRestaurantDetailProduct> products;

  MRestaurantDetail({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory MRestaurantDetail.fromJson(Map<String, dynamic> json) => _$MRestaurantDetailFromJson(json);
}
