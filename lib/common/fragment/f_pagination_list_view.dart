import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/common/utils/utils_pagination.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class FPaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const FPaginationListView({
    required this.provider,
    required this.itemBuilder,
    super.key,
  });

  @override
  ConsumerState<FPaginationListView> createState() => _FPaginationListViewState<T>();
}

class _FPaginationListViewState<T extends IModelWithId> extends ConsumerState<FPaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  void scrollListener() {
    UtilsPagination.paginate(controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 완전 첫 로딩일 때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러일 때
    if (state is CursorPaginationError) {
      print('에러 발생');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          ElevatedButton(
            onPressed: () => ref.read(widget.provider.notifier).paginate(forceRefetch: true),
            child: const Text('다시 시도'),
          )
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    // cp는 cursor pagination의 약자
    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate(forceRefetch: true);
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          // +1을 하는 이유: CircularProgressIndicator 혹은 '마지막 데이터입니다.' 넣기 위해서.
          itemCount: cp.data.length + 1,
          separatorBuilder: (context, index) => const Divider(color: Colors.transparent),
          itemBuilder: (context, index) {
            // index == cp.data.length는 맨 마지막임을 뜻함.
            if (index == cp.data.length) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(child: cp is CursorPaginationFetchingMore ? const CircularProgressIndicator() : const Text('마지막 데이터입니다.')));
            }
            final pItem = cp.data[index];

            return widget.itemBuilder(
              context,
              index,
              pItem,
            );
          },
        ),
      ),
    );
  }
}
