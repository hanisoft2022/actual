import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({int? count, bool? hasMore}) =>
      CursorPaginationMeta(count: count ?? this.count, hasMore: hasMore ?? this.hasMore);

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) => _$CursorPaginationMetaFromJson(json);
}

// 기본이 되는 추상 클래스
abstract class CursorPaginationBase {}

// [1] 로딩
class CursorPaginationLoading implements CursorPaginationBase {}

// [2] 에러
class CursorPaginationError implements CursorPaginationBase {
  final String message;

  CursorPaginationError({required this.message});
}

// [3] 페이지네이션
@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> implements CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination<T> copyWith({CursorPaginationMeta? meta, List<T>? data}) =>
      CursorPagination<T>(meta: meta ?? this.meta, data: data ?? this.data);

  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

// [4] 새로고침
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({required super.meta, required super.data});
}

// [5] 리스트의 맨 아래로 내려서 추가 데이터를 요청
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({required super.meta, required super.data});
}
