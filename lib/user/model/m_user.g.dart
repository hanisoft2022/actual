// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MUser _$MUserFromJson(Map<String, dynamic> json) => MUser(
      id: json['id'] as String,
      username: json['username'] as String,
      imageUrl: UtilsData.pathToUrl(json['imageUrl'] as String),
    );

Map<String, dynamic> _$MUserToJson(MUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'imageUrl': instance.imageUrl,
    };
