import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/utils_data.dart';
import 'package:actual/user/model/m_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'm_rating.g.dart';

@JsonSerializable()
class MRating implements IModelWithId {
  @override
  final String id;
  final MUser user;
  final int rating;
  final String content;
  @JsonKey(fromJson: UtilsData.listPathsToUrls)
  final List<String> imgUrls;

  MRating({required this.id, required this.user, required this.rating, required this.content, required this.imgUrls});

  factory MRating.fromJson(Map<String, dynamic> json) => _$MRatingFromJson(json);

  Map<String, dynamic> toJson() => _$MRatingToJson(this);
}
