import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:actual/restaurant/model/m_restaurant_detail.dart';
import 'package:actual/restaurant/model/m_restaurant.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo_restaurant.g.dart';

@riverpod
RepoRestaurant repoRestaurant(Ref ref) {
  final dio = ref.watch(dioProvider);
  final repository = RepoRestaurant(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
}

@RestApi()
abstract class RepoRestaurant implements IBasePaginationRepository<MRestaurant> {
  // 레스토랑 관련 API 호출을 관리하는 레포지토리 클래스
  // http://ip/restaurant
  factory RepoRestaurant(Dio dio, {String baseUrl}) = _RepoRestaurant;

  // 레스토랑 목록을 페이징 처리하여 가져오는 메서드
  //
  // 이 메서드는 페이지네이션 지원을 통해 레스토랑 목록을 가져옵니다.
  //
  // 헤더:
  // - accessToken: true (인증 토큰 필요)
  //
  // 엔드포인트: GET http://ip/restaurant/
  @override
  @GET('/')
  @Headers(<String, String>{'accessToken': 'true'})
  Future<CursorPagination<MRestaurant>> paginate({@Queries() PaginationParams? paginationParams});

  // 특정 레스토랑의 상세 정보를 가져오는 메서드
  //
  // 이 메서드는 레스토랑의 고유 ID를 사용하여 해당 레스토랑의 상세 정보를 가져옵니다.
  //
  // 헤더:
  // - accessToken: true (인증 토큰 필요)
  //
  // 엔드포인트: GET http://ip/restaurant/{id}
  @GET('/{id}')
  @Headers(<String, String>{'accessToken': 'true'})
  Future<MRestaurantDetail> getRestaurantDetail(
    @Path() String id,
  );
}
