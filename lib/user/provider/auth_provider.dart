// ignore_for_file: avoid_print

import 'package:actual/common/screen/s_root_tab.dart';
import 'package:actual/common/screen/s_splash.dart';
import 'package:actual/order/screen/s_order_done.dart';
import 'package:actual/restaurant/screen/s_basket.dart';
import 'package:actual/restaurant/screen/s_restaurant_detail.dart';
import 'package:actual/user/model/m_user.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:actual/user/screen/s_login.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(ref: ref),
);

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) : super() {
    ref.listen<MUserBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SSplash.routeName,
          builder: (context, state) => const SSplash(),
        ),
        GoRoute(path: '/', name: SRootTab.routeName, builder: (context, state) => const SRootTab(), routes: [
          GoRoute(
              path: 'restaurant/:rid',
              name: SRestaurantDetail.routeName,
              builder: (context, state) => SRestaurantDetail(id: state.pathParameters['rid']!))
        ]),
        GoRoute(
          path: '/basket',
          name: SBasket.routeName,
          builder: (context, state) => const SBasket(),
        ),
        GoRoute(
          path: '/order_done',
          name: SOrderDone.routeName,
          builder: (context, state) => const SOrderDone(),
        ),
        GoRoute(
          path: '/login',
          name: SLogin.routeName,
          builder: (context, state) => const SLogin(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen이 필요한 이유:
  // 앱을 첨음 시작했을 때
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(GoRouterState state) {
    print('--------------------------------------------------');
    print('auth_provider.dart 파일 코드의 redirectLogic 메서드 시작');
    final MUserBase? user = ref.read(userMeProvider);

    final isLogInScreen = state.uri.path == '/login';

    // [1] 유저 정보가 없음.
    // 로그인중이라면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      print('! 유저 정보 없음. auth_provider.dart 파일 확인');
      return isLogInScreen ? null : '/login';
    }

    // [2] 유저 정보가 있음.

    // 사용자 정보가 있는 상태인데도 불구하고
    // Log In 화면이거나 Splash 화면이면
    // Home 화면으로 이동
    if (user is MUser) {
      print('! 유저 정보 있음. auth_provider.dart 파일 확인');
      return isLogInScreen || state.uri.path == '/splash' ? '/' : null;
    }

    // [3] 유저 정보 에러.
    // Log In 화면으로 이동
    if (user is MUserError) {
      print('! 유저 정보 에러. auth_provider.dart 파일 확인');
      return isLogInScreen ? null : '/login';
    }

    print('auth_provider.dart 파일 코드의 redirectLogic 메서드 종료');
    print('--------------------------------------------------');
    return null;
  }
}
