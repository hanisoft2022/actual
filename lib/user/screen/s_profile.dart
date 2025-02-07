import 'package:actual/user/provider/auth_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SProfile extends ConsumerWidget {
  const SProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(authProvider.notifier).logout();
        },
        child: const Text('로그아웃'),
      ),
    );
  }
}
