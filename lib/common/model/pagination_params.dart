import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  final String? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });

  PaginationParams copyWith({
    String? after,
    int? count,
  }) =>
      PaginationParams(
        after: after ?? this.after,
        count: count ?? this.count,
      );

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
