import 'package:actual/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    // watch - 값이 변경될 때마다 다시 빌드.
    // read - 한번만 읽고 값이 변경돼도 다시 빌드하지 않음.
    final provider = ref.read(authProvider);

    return GoRouter(
        routes: provider.routes,
        initialLocation: '/splash',
        refreshListenable: provider,
        redirect: (context, state) => provider.redirectLogic(state));
  },
);
// final routerProvider = Provider<GoRouter>((ref) {
//   final auth = ref.watch(authProvider.notifier);
//   final routes = ref.watch(authProvider);

//   return GoRouter(
//     initialLocation: '/splash',
//     routes: routes.routes,
//     redirect: (context, state) => auth.redirectLogic(state),
//   );
// });
