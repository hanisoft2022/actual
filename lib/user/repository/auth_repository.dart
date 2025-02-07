import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/login_response.dart';
import 'package:actual/common/model/token_response.dart';
// import 'package:actual/common/model/token_response.dart';
import 'package:actual/common/utils/utils_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(dio, baseUrl: 'http://$ip/auth');
});

class AuthRepository {
  // http://$ip/auth
  final Dio dio;
  final String baseUrl;

  AuthRepository(
    this.dio, {
    required this.baseUrl,
  });

  Future<LoginResponse> login({required String username, required String password}) async {
    final token = UtilsData.plainToBase64('$username:$password');

    final response = await dio.post('$baseUrl/login', options: Options(headers: {'authorization': 'Basic $token'}));

    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> token({required String refreshToken}) async {
    final resp = await dio.post('$baseUrl/token', options: Options(headers: {'refreshToken': 'true'}));

    return TokenResponse.fromJson(resp.data);
  }
}
