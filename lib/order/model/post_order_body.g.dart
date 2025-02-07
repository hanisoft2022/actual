// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_order_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MPostOrderBodyProduct _$MPostOrderBodyProductFromJson(
        Map<String, dynamic> json) =>
    MPostOrderBodyProduct(
      productId: json['productId'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$MPostOrderBodyProductToJson(
        MPostOrderBodyProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'count': instance.count,
    };

MPostOrderBody _$MPostOrderBodyFromJson(Map<String, dynamic> json) =>
    MPostOrderBody(
      id: json['id'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => MPostOrderBodyProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$MPostOrderBodyToJson(MPostOrderBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'products': instance.products,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt,
    };
