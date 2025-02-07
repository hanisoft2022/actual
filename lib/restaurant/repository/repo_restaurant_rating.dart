import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:actual/rating/model/m_rating.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo_restaurant_rating.g.dart';

@riverpod
RepoRestaurantRating repoRestaurantRating(Ref ref, String id) {
  final dio = ref.watch(dioProvider);
  return RepoRestaurantRating(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
}

// final repoRestaurantRatingProvider = Provider.family<RepoRestaurantRating, String>(
//   (ref, id) {
//     final dio = ref.watch(dioProvider);

//     return RepoRestaurantRating(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
//   },
// );

// http://ip/restaurant/{id}/rating
@RestApi()
abstract class RepoRestaurantRating implements IBasePaginationRepository<MRating> {
  factory RepoRestaurantRating(Dio dio, {String baseUrl}) = _RepoRestaurantRating;

  @override
  @GET('/')
  @Headers(<String, String>{'accessToken': 'true'})
  Future<CursorPagination<MRating>> paginate({@Queries() PaginationParams? paginationParams});
}
