// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MOrderProduct _$MOrderProductFromJson(Map<String, dynamic> json) =>
    MOrderProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      detail: json['detail'] as String,
      imgUrl: UtilsData.pathToUrl(json['imgUrl'] as String),
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$MOrderProductToJson(MOrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'detail': instance.detail,
      'price': instance.price,
    };

MOrderProductAndCount _$MOrderProductAndCountFromJson(
        Map<String, dynamic> json) =>
    MOrderProductAndCount(
      product: MOrderProduct.fromJson(json['product'] as Map<String, dynamic>),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$MOrderProductAndCountToJson(
        MOrderProductAndCount instance) =>
    <String, dynamic>{
      'product': instance.product,
      'count': instance.count,
    };

MOrder _$MOrderFromJson(Map<String, dynamic> json) => MOrder(
      id: json['id'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => MOrderProductAndCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      restaurant:
          MRestaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
      totalPrice: (json['totalPrice'] as num).toInt(),
      createdAt: UtilsData.stringToDateTime(json['createdAt'] as String),
    );

Map<String, dynamic> _$MOrderToJson(MOrder instance) => <String, dynamic>{
      'id': instance.id,
      'products': instance.products,
      'restaurant': instance.restaurant,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
    };
