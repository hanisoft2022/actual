// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_patch_basket_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchBasketBodyBasket _$PatchBasketBodyBasketFromJson(
        Map<String, dynamic> json) =>
    PatchBasketBodyBasket(
      productId: json['productId'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$PatchBasketBodyBasketToJson(
        PatchBasketBodyBasket instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'count': instance.count,
    };

MPatchBasketBody _$MPatchBasketBodyFromJson(Map<String, dynamic> json) =>
    MPatchBasketBody(
      listOfBasketItems: (json['listOfBasketItems'] as List<dynamic>)
          .map((e) => PatchBasketBodyBasket.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MPatchBasketBodyToJson(MPatchBasketBody instance) =>
    <String, dynamic>{
      'listOfBasketItems': instance.listOfBasketItems,
    };
