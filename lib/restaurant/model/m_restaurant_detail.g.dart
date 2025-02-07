// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_restaurant_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MRestaurantDetailProduct _$MRestaurantDetailProductFromJson(
        Map<String, dynamic> json) =>
    MRestaurantDetailProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: UtilsData.pathToUrl(json['imgUrl'] as String),
      detail: json['detail'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$MRestaurantDetailProductToJson(
        MRestaurantDetailProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'detail': instance.detail,
      'imgUrl': instance.imgUrl,
      'price': instance.price,
    };

MRestaurantDetail _$MRestaurantDetailFromJson(Map<String, dynamic> json) =>
    MRestaurantDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbUrl: UtilsData.pathToUrl(json['thumbUrl'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      priceRange:
          $enumDecode(_$RestaurantPriceRangeEnumMap, json['priceRange']),
      ratings: (json['ratings'] as num).toDouble(),
      ratingsCount: (json['ratingsCount'] as num).toInt(),
      deliveryTime: (json['deliveryTime'] as num).toInt(),
      deliveryFee: (json['deliveryFee'] as num).toInt(),
      detail: json['detail'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) =>
              MRestaurantDetailProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MRestaurantDetailToJson(MRestaurantDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbUrl': instance.thumbUrl,
      'tags': instance.tags,
      'priceRange': _$RestaurantPriceRangeEnumMap[instance.priceRange]!,
      'ratings': instance.ratings,
      'ratingsCount': instance.ratingsCount,
      'deliveryTime': instance.deliveryTime,
      'deliveryFee': instance.deliveryFee,
      'detail': instance.detail,
      'products': instance.products,
    };

const _$RestaurantPriceRangeEnumMap = {
  RestaurantPriceRange.expensive: 'expensive',
  RestaurantPriceRange.medium: 'medium',
  RestaurantPriceRange.cheap: 'cheap',
};
