import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
_PaginationInfo 클래스를 정의한 이유:
아래 'throttle [2]'에서 throttle 인스턴스인 paginationThrottle의 setValue 메서드에는 하나의 아규먼트만을 넣을 수 있기 때문임.
*/
class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({this.fetchCount = 20, this.fetchMore = false, this.forceRefetch = false});
}

class PaginationProvider<T extends IModelWithId, U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  // throttle [1]. Throttle 인스턴스화
  final paginationThrottle =
      Throttle(const Duration(milliseconds: 500), initialValue: _PaginationInfo(), checkEquality: false);

  PaginationProvider({required this.repository}) : super(CursorPaginationLoading()) {
    paginate();
    /*
    throttle [3]. Throttle 인스턴스에 이벤트 연결
    'throttle [2]'에서 setValue에 할당한 아규먼트가 아래 state에 해당됨.
    'throttle [1]'에서 설정된 기간 1초가 지나면 _throttledPagination 메서드 호출
    */
    paginationThrottle.values.listen((state) => _throttledPagination(state));
  }

  Future<void> paginate({
    int fetchCount = 20,
    /*
    추가로 데이터 더 가져오기
    true: 추가로 데이터 더 가져옴
    false: 새로고침 (현재 상태를 덮어씌움)
    */
    bool fetchMore = false,
    /*
    강제로 다시 로딩하기
    true: CursorPaginationLoading()
    */
    bool forceRefetch = false,
  }) async {
    // throttle [2]. Throttle 인스턴스에 아규먼트 할당('throttle [3]'으로 이동).
    paginationThrottle.setValue(
      _PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
      ),
    );
  }

  void _throttledPagination(_PaginationInfo info) async {
    try {
      final fetchCount = info.fetchCount;
      final fetchMore = info.fetchMore;
      final forceRefetch = info.forceRefetch;

      /*
      상태(State)는 아래와 같이 5가지임.
      1) CursorPagination - 정상적으로 데이터가 있는 상태
      2) CursorPaginationLoading - 데이터가 로딩 중인 상태 (현재 캐시 없음)
      3) CursorPaginationError - 에러가 있는 상태
      4) CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져올 때
      5) CursorPaginationFetchingMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때
      */

      // 상황(Situation)은 아래와 같이 나눌 수 있음:
      // 데이터 요청 중단: 바로 반환하는 상황
      // [1-1] 더 이상 가져올 데이터가 없는 경우 (hasMore이 false)
      //       관련 상태: CursorPagination
      // [1-2] 현재 로딩 중이거나 이미 데이터를 가져오는 작업이 진행 중인 경우
      //       관련 상태: CursorPaginationLoading, CursorPaginationRefetching, CursorPaginationFetchingMore

      // 데이터 요청: 바로 반환하지 않고 데이터 처리하여 반환하는 상황
      // [2-1] 추가 데이터 로드: fetch more인 경우
      //       관련 상태: CursorPaginationFetchingMore
      // [2-2] 첫 페이지 로드: fetch more이 아닌 경우
      //       관련 상태: CursorPaginationLoading, CursorPaginationRefetching
      // [2-3] 공통 응답 처리: [2-1], [2-2] 공통

      // 데이터 요청 중단: 바로 반환하는 상황
      if (_shouldReturnEarly(fetchMore, forceRefetch)) return;

      // [2-0] PaginationParams 생성
      final paginationParams = _createPaginationParams(fetchCount, fetchMore);

      // [2-1], [2-2]에 따른 상태 업데이트
      _updateStateForPagination(fetchMore, forceRefetch);

      // [2-3] 공통 API 요청 및 응답 처리
      await _fetchAndProcessData(paginationParams);
    } catch (e, stack) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

// [1] 데이터 요청 중단 조건 확인
// - 더 이상 가져올 데이터가 없는 경우 (hasMore == false)
// - 현재 로딩 중이거나 이미 데이터를 가져오는 작업이 진행 중인 경우
  bool _shouldReturnEarly(bool fetchMore, bool forceRefetch) {
    if (state is CursorPagination<T> && !forceRefetch) {
      final pState = state as CursorPagination<T>;
      if (!pState.meta.hasMore) return true; // [1-1]
    }

    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;

    return fetchMore && (isLoading || isRefetching || isFetchingMore); // [1-2]
  }

// [2-0] PaginationParams 생성
// - fetch more인 경우 마지막 데이터 ID를 기반으로 after 값을 설정.
// - 그렇지 않은 경우 첫 페이지부터 데이터를 가져옴.
  PaginationParams _createPaginationParams(int fetchCount, bool fetchMore) {
    if (fetchMore && state is CursorPagination<T>) {
      final pState = state as CursorPagination<T>;
      return PaginationParams(count: fetchCount, after: pState.data.last.id);
    }
    return PaginationParams(count: fetchCount);
  }

// [2-1], [2-2]에 따른 상태 업데이트
// - fetch more인 경우: 기존 데이터를 유지하며 추가 데이터를 로드 중임을 나타냄.
// - 첫 페이지 로드인 경우:
//   - 기존 데이터를 유지하며 새로고침 진행 (CursorPaginationRefetching)
//   - 또는 기존 데이터를 무시하고 처음부터 로드 (CursorPaginationLoading)
  void _updateStateForPagination(bool fetchMore, bool forceRefetch) {
    if (fetchMore && state is CursorPagination<T>) {
      final pState = state as CursorPagination<T>;
      // [2-1] 추가 데이터를 가져오는 중인 상태로 전환
      // - 기존 데이터를 유지하며 추가 데이터를 가져오는 작업 진행 중임을 나타냄
      state = CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);
    } else if (state is CursorPagination && !forceRefetch) {
      final pState = state as CursorPagination<T>;
      // [2-2] 기존 데이터를 유지하며 첫 페이지부터 새로고침 중인 상태로 전환
      // - 기존 데이터를 보존하면서 새 데이터를 가져오는 작업 진행 중임을 나타냄
      state = CursorPaginationRefetching<T>(meta: pState.meta, data: pState.data);
    } else {
      // [2-2] 강제 새로고침(forceRefetch)이거나, 현재 상태가 CursorPagination이 아닌 경우
      // - 기존 데이터를 무시하고 처음부터 데이터를 다시 로드
      // - UI에서 로딩 인디케이터를 표시하도록 트리거
      state = CursorPaginationLoading();
    }
  }

// [2-3] 공통 API 요청 및 응답 처리
// - 서버에서 데이터를 가져온 후 상태를 업데이트.
// - 추가 데이터를 가져오는 경우 기존 데이터에 병합.
// - 첫 페이지를 로드하는 경우 새로운 데이터로 교체.
  Future<void> _fetchAndProcessData(PaginationParams paginationParams) async {
    final resp = await repository.paginate(paginationParams: paginationParams);

    if (state is CursorPaginationFetchingMore<T>) {
      final pState = state as CursorPaginationFetchingMore<T>;

      // 기존 데이터에 새로운 데이터를 병합하여 업데이트.
      state = resp.copyWith(data: [...pState.data, ...resp.data]);
    } else {
      // 새로운 데이터로 상태를 교체.
      state = resp;
    }
  }
}

/*

아래는 리팩토링 전 _throttledPagination 메서드

void _throttledPagination(_PaginationInfo info) async {
    try {
      final fetchCount = info.fetchCount;
      final fetchMore = info.fetchMore;
      final forceRefetch = info.forceRefetch;

      // 상태(State)는 아래와 같이 5가지임.
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩 중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationFetchingMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

      // 상황(Situation)은 아래와 같이 나눌 수 있음:
      // 데이터 요청 중단: 바로 반환하는 상황
      // [1-1] 더 이상 가져올 데이터가 없는 경우 (hasMore이 false)
      //       관련 상태: CursorPagination
      // [1-2] 현재 로딩 중이거나 이미 데이터를 가져오는 작업이 진행 중인 경우
      //       관련 상태: CursorPaginationLoading, CursorPaginationRefetching, CursorPaginationFetchingMore

      // 데이터 요청: 바로 반환하지 않고 데이터 처리하여 반환하는 상황
      // [2-1] 추가 데이터 로드: fetch more인 경우
      //       관련 상태: CursorPaginationFetchingMore
      // [2-2] 첫 페이지 로드: fetch more이 아닌 경우
      //       관련 상태: CursorPaginationLoading, CursorPaginationRefetching
      // [2-3] 공통 응답 처리: [2-1], [2-2] 공통

      // [1-1] hasMore이 false여서 바로 return하는 경우
      if (state is CursorPagination && !forceRefetch) {
        // pState은 parsed state라는 뜻
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }
      // [1-2] 이미 데이터를 가져오는 작업이 진행 중인 상황
      // fetchMore가 true인 경우(추가 데이터를 요청하는 상황)에도,
      // 아래 상태 중 하나에 해당하면 중복 요청을 방지하기 위해 반환:
      // - 전체 데이터를 처음부터 로드 중 (CursorPaginationLoading)
      // - 기존 데이터 유지 + 새로고침 진행 중 (CursorPaginationRefetching)
      // - 추가 데이터를 가져오는 중 (CursorPaginationFetchingMore)
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 지금까지 그냥 return하는 경우 2가지를 살펴봄.
      // 지금부터는 paginate하는 경우에 해당되는 코드임.

      // [2-0] 우선 paginationParams 인스턴스를 생성한다.
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // [2-1] fetch more인 상황. 즉, 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(after: pState.data.last.id);
      }

      // [2-2] fetch more이 아닌 상황. 즉, 데이터를 처음부터 가져오는 상황
      else {
        // 만약 데이터가 있는 상태라면 (CursorPagination)
        // 기존 데이터를 보존한 채 새로고침(API 요청)을 진행:
        // 예: 필터 변경, 검색 조건 변경 등
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(meta: pState.meta, data: pState.data);
        } else {
          // force refetch이거나 기존 상태가 없을 경우:
          // 기존 데이터를 무시하고 처음부터 데이터 로드
          state = CursorPaginationLoading();
        }
      }

      // [2-3] [1], [2] 공통. API 요청 및 응답 처리
      final resp = await repository.paginate(paginationParams: paginationParams);
      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}

*/
