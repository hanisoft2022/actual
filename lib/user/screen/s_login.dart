import 'package:actual/common/const/color.dart';
import 'package:actual/common/layout/l_default.dart';

import 'package:actual/common/widget/w_custom_text_form_field.dart';

import 'package:actual/user/model/m_user.dart';
import 'package:actual/user/provider/user_me_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';

class SLogin extends ConsumerStatefulWidget {
  static String routeName = '/login';

  const SLogin({super.key});

  @override
  ConsumerState<SLogin> createState() => _SLoginState();
}

class _SLoginState extends ConsumerState<SLogin> {
  String? _errorEmail;
  String? _errorPassword;
  String username = '';
  String password = '';

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorEmail = null;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _errorEmail = '유효하지 않은 이메일 주소입니다.';
      } else {
        _errorEmail = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorPassword = '비밀번호를 입력해주세요.';
      } else if (value.length < 8) {
        _errorPassword = '비밀번호는 8자 이상이어야 합니다.';
      } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
        _errorPassword = '비밀번호에 소문자를 포함해주세요.';
      }

      // else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      //   _errorPassword = '비밀번호에 대문자를 포함해주세요.';
      // } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      //   _errorPassword = '비밀번호에 숫자를 포함해주세요.';
      // } else if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
      //   _errorPassword = '비밀번호에 특수문자(@\$!%*?&)를 포함해주세요.';
      // }

      else {
        _errorPassword = null;
      }
    });
  }

  void onLogInButtonPressed() async {
    _validateEmail(username);
    _validatePassword(password);

    ref.read(userMeProvider.notifier).login(username: username, password: password);
  }

  void onSignInButtonPressed() async {
    _validateEmail(username);
    _validatePassword(password);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return LDefault(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(20),
                const FTitle(),
                const Gap(20),
                const FSubtitle(),
                const Gap(20),
                Center(
                  child: Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                ),
                const Gap(20),
                WCustomTextFormField(
                  icon: const Icon(Icons.person),
                  hintText: '이메일',
                  errorText: _errorEmail,
                  onChanged: (value) {
                    username = value;
                    _validateEmail(value);
                  },
                  autofocus: true,
                ),
                const Gap(15),
                WCustomTextFormField(
                  icon: const Icon(Icons.password),
                  hintText: '비밀번호',
                  errorText: _errorPassword,
                  onChanged: (value) {
                    password = value;
                    _validatePassword(value);
                  },
                  obscureText: true,
                ),
                const Gap(15),
                ElevatedButton(
                    onPressed: state is MUserLoading ? null : onLogInButtonPressed, child: const Text('로그인')),
                const Gap(15),
                FilledButton(onPressed: onSignInButtonPressed, child: const Text('회원가입')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FTitle extends StatelessWidget {
  const FTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}

class FSubtitle extends StatelessWidget {
  const FSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(fontSize: 15, color: COLOR_BODY_TEXT),
    );
  }
}
