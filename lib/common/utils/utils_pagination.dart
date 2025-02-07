import 'package:actual/common/provider/pagination_provider.dart';
import 'package:flutter/widgets.dart';

class UtilsPagination {
  static void paginate({required ScrollController controller, required PaginationProvider provider}) {
    if (controller.offset > controller.position.maxScrollExtent * 0.9) {
      provider.paginate(fetchMore: true);
    }
  }
}
