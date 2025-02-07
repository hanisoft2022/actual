import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/provider/auth_provider.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));

  return dio;
}

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.storage, required this.ref});

  // 1) 요청을 보낼 때
  // 요청이 보내질 때마다
  // 요청의 Header에 accessToken: true 값이 있으면
  // 실제 토큰을 storage에서 가져와서
  // authorization: Bearer $accessToken으로
  // 요청의 Header에 토큰을 실제로 넣어줌

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // ignore: avoid_print
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      // 실제 토큰 가져오기
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers['authorization'] = 'Bearer $accessToken';
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      // 실제 토큰 가져오기
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers['authorization'] = 'Bearer $refreshToken';
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때 (status code)
    // 토큰 재발급 시도를 하고, 재발급에 성공하면
    // 새로운 토큰으로 다시 요청을 보내는 처리

    // ignore: avoid_print
    print('[ERR] [${err.response?.statusCode}] ${err.message}');

    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      // 리프레시 토큰이 없으면 에러 그대로 전달
      if (refreshToken == null) {
        // 에러를 던질 때는 handler.reject를 사용
        return handler.reject(err);
      }

      final isStatus401 = err.response?.statusCode == 401;
      final isPathRefresh = err.requestOptions.path == '/auth/token';

      if (isStatus401 && !isPathRefresh) {
        final dio = Dio();

        try {
          final resp = await dio.post(
            'http://$ip/auth/token',
            options: Options(
              headers: {
                'authorization': 'Bearer $refreshToken',
              },
            ),
          );

          final accessToken = resp.data['accessToken'];

          final options = err.requestOptions;

          // 새로운 accessToken 넣어주기
          options.headers['authorization'] = 'Bearer $accessToken';

          // 새로운 accessToken 저장
          await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

          // 재발급 성공 시 다시 요청 보내기
          final response = await dio.fetch(options);

          return handler.resolve(response);
        } on DioException catch (err) {
          ref.read(authProvider.notifier).logout();
          return handler.reject(err);
        }
      }
    }

    return handler.reject(err);
  }
}
