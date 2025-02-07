import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/rating/model/m_rating.dart';
import 'package:actual/restaurant/repository/repo_restaurant_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider =
    StateNotifierProvider.family<RestaurantRatingNotifier, CursorPaginationBase, String>((ref, id) {
  final repository = ref.watch(repoRestaurantRatingProvider(id));

  final notifier = RestaurantRatingNotifier(repository: repository);

  return notifier;
});

class RestaurantRatingNotifier extends PaginationProvider<MRating, RepoRestaurantRating> {
  RestaurantRatingNotifier({required super.repository});
}
