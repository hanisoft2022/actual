import 'package:actual/common/const/theme.dart';

import 'package:actual/user/provider/go_router_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(child: _App()),
  );
}

class _App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(theme: theme, debugShowCheckedModeBanner: false, routerConfig: router);
  }
}
