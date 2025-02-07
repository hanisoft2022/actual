// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MProduct _$MProductFromJson(Map<String, dynamic> json) => MProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: UtilsData.pathToUrl(json['imgUrl'] as String),
      detail: json['detail'] as String,
      price: (json['price'] as num).toInt(),
      restaurant:
          MRestaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MProductToJson(MProduct instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'detail': instance.detail,
      'imgUrl': instance.imgUrl,
      'price': instance.price,
      'restaurant': instance.restaurant,
    };
