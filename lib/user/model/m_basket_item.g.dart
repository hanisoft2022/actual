// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_basket_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MBasketItem _$MBasketItemFromJson(Map<String, dynamic> json) => MBasketItem(
      product: MProduct.fromJson(json['product'] as Map<String, dynamic>),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$MBasketItemToJson(MBasketItem instance) =>
    <String, dynamic>{
      'product': instance.product,
      'count': instance.count,
    };
