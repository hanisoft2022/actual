import 'package:actual/common/utils/utils_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_user.g.dart';

abstract interface class MUserBase {}

class MUserLoading implements MUserBase {}

class MUserError implements MUserBase {
  final String error;

  MUserError({required this.error});
}

@JsonSerializable()
class MUser implements MUserBase {
  final String id;
  final String username;
  @JsonKey(fromJson: UtilsData.pathToUrl)
  final String imageUrl;

  MUser({required this.id, required this.username, required this.imageUrl});

  factory MUser.fromJson(Map<String, dynamic> json) => _$MUserFromJson(json);

  Map<String, dynamic> toJson() => _$MUserToJson(this);
}
