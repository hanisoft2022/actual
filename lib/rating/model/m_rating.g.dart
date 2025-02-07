// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MRating _$MRatingFromJson(Map<String, dynamic> json) => MRating(
      id: json['id'] as String,
      user: MUser.fromJson(json['user'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toInt(),
      content: json['content'] as String,
      imgUrls: UtilsData.listPathsToUrls(json['imgUrls'] as List),
    );

Map<String, dynamic> _$MRatingToJson(MRating instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'rating': instance.rating,
      'content': instance.content,
      'imgUrls': instance.imgUrls,
    };
